#!/usr/bin/env python3
"""Generate assets/khutbahs/khutbahs_index.json with verified PDF filenames only."""

from __future__ import annotations

import json
import re
import sys
import time
import urllib.error
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

SOURCE_URL = (
    'https://raw.githubusercontent.com/rn0x/khutbahs-api/main/'
    'database/khutbahs_main_data.json'
)
TREE_URL = (
    'https://api.github.com/repos/rn0x/khutbahs-api/git/trees/main?recursive=1'
)
DETAIL_BASE = (
    'https://raw.githubusercontent.com/rn0x/khutbahs-api/main/'
    'database/khutbahs_details'
)
ROOT = Path(__file__).resolve().parent.parent
OUTPUT = ROOT / 'assets' / 'khutbahs' / 'khutbahs_index.json'
OVERRIDES = ROOT / 'assets' / 'khutbahs' / 'khutbahs_pdf_overrides.json'

EXCLUDED_CATEGORIES = {
    'أديان ومذاهب وفرق',
    'الجهاد',
    'السياسة والشأن العام',
}

USER_AGENT = 'goman-alhoda-index-generator'


def fetch_json(url: str, timeout: int = 120) -> object:
    request = urllib.request.Request(url, headers={'User-Agent': USER_AGENT})
    with urllib.request.urlopen(request, timeout=timeout) as response:
        return json.loads(response.read().decode('utf-8'))


def author_name(author: dict | None) -> str:
    if not author:
        return ''
    parts = [
        author.get('name_prefix') or '',
        author.get('first_name') or '',
        author.get('last_name') or '',
    ]
    return ' '.join(part for part in parts if part).strip()


def title_pdf_name(title: str) -> str:
    return f"{title.strip().replace(' ', '_')}.pdf"


def slug_pdf_name(slug: str) -> str:
    return f"{slug.strip().replace('-', '_')}.pdf"


def pdf_from_attachments(detail: dict, pdf_set: set[str]) -> str | None:
    attachments = detail.get('attachments') or []
    for attachment in attachments:
        name = (attachment.get('name') or '').strip()
        if name.lower().endswith('.pdf') and name in pdf_set:
            return name
    return None


def fetch_detail(slug: str) -> dict | None:
    encoded = urllib.request.quote(f'{slug}.json')
    url = f'{DETAIL_BASE}/{encoded}'
    try:
        detail = fetch_json(url, timeout=30)
        return detail if isinstance(detail, dict) else None
    except (urllib.error.HTTPError, urllib.error.URLError, TimeoutError, json.JSONDecodeError):
        return None


def resolve_pdf_name(
    item: dict,
    pdf_set: set[str],
    overrides: dict[str, str],
    detail_cache: dict[str, dict | None],
) -> str | None:
    entry_id = item.get('id')
    slug = (item.get('slug') or '').strip()
    title = (item.get('title') or '').strip()

    if entry_id is not None:
        override = overrides.get(str(entry_id))
        if override and override.lower().endswith('.pdf') and override in pdf_set:
            return override
    if slug:
        override = overrides.get(slug)
        if override and override.lower().endswith('.pdf') and override in pdf_set:
            return override

    candidates = [
        title_pdf_name(title),
        slug_pdf_name(slug),
    ]
    for candidate in candidates:
        if candidate in pdf_set:
            return candidate

    if slug not in detail_cache:
        detail_cache[slug] = fetch_detail(slug)
    detail = detail_cache.get(slug)
    if detail is not None:
        attachment_pdf = pdf_from_attachments(detail, pdf_set)
        if attachment_pdf is not None:
            return attachment_pdf

    return None


def load_repo_files() -> set[str]:
    print('Fetching GitHub file tree...')
    tree = fetch_json(TREE_URL)
    pdf_files = {
        entry['path'].split('/')[-1]
        for entry in tree['tree']
        if entry['path'].startswith('database/files/')
        and entry['path'].lower().endswith('.pdf')
    }
    print(f'Found {len(pdf_files)} PDF files on GitHub')
    return pdf_files


def main() -> int:
    input_path = Path(sys.argv[1]) if len(sys.argv) > 1 else None
    if input_path and input_path.exists():
        raw = json.loads(input_path.read_text(encoding='utf-8'))
        print(f'Loaded {len(raw)} entries from {input_path}')
    else:
        print(f'Downloading {SOURCE_URL}...')
        raw = fetch_json(SOURCE_URL)
        print(f'Downloaded {len(raw)} entries')

    pdf_set = load_repo_files()

    overrides: dict[str, str] = {}
    if OVERRIDES.exists():
        overrides = json.loads(OVERRIDES.read_text(encoding='utf-8'))

    detail_cache: dict[str, dict | None] = {}
    entries: list[dict] = []
    excluded = 0
    skipped_no_pdf = 0
    resolved_from_detail = 0

    pending_detail: list[dict] = []
    for item in raw:
        category = (item.get('category_text') or '').strip()
        if category in EXCLUDED_CATEGORIES:
            excluded += 1
            continue

        title = (item.get('title') or '').strip()
        entry_id = item.get('id')
        if not title or entry_id is None:
            continue

        quick_candidates = [
            title_pdf_name(title),
            slug_pdf_name((item.get('slug') or '').strip()),
        ]
        if any(candidate in pdf_set for candidate in quick_candidates):
            pdf_name = resolve_pdf_name(item, pdf_set, overrides, detail_cache)
        else:
            pending_detail.append(item)
            continue

        if pdf_name is None:
            skipped_no_pdf += 1
            continue

        entries.append({
            'id': entry_id,
            'title': title,
            'slug': (item.get('slug') or '').strip(),
            'categoryText': category,
            'authorName': author_name(item.get('author')),
            'createdAt': item.get('created_at'),
            'pdfFileName': pdf_name,
        })

    if pending_detail:
        print(f'Resolving {len(pending_detail)} entries via detail attachments...')
        slugs = [
            (item.get('slug') or '').strip()
            for item in pending_detail
            if (item.get('slug') or '').strip()
        ]
        unique_slugs = [slug for slug in dict.fromkeys(slugs) if slug not in detail_cache]
        if unique_slugs:
            with ThreadPoolExecutor(max_workers=16) as pool:
                futures = {
                    pool.submit(fetch_detail, slug): slug for slug in unique_slugs
                }
                for index, future in enumerate(as_completed(futures), start=1):
                    slug = futures[future]
                    detail_cache[slug] = future.result()
                    if index % 200 == 0:
                        print(f'  fetched detail {index}/{len(unique_slugs)}')

        for item in pending_detail:
            slug = (item.get('slug') or '').strip()
            pdf_name = resolve_pdf_name(item, pdf_set, overrides, detail_cache)
            if pdf_name is None:
                skipped_no_pdf += 1
                continue

            if slug in detail_cache and detail_cache[slug] is not None:
                resolved_from_detail += 1

            entries.append({
                'id': item.get('id'),
                'title': (item.get('title') or '').strip(),
                'slug': slug,
                'categoryText': (item.get('category_text') or '').strip(),
                'authorName': author_name(item.get('author')),
                'createdAt': item.get('created_at'),
                'pdfFileName': pdf_name,
            })

    entries.sort(key=lambda entry: entry['id'])

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(
        json.dumps(entries, ensure_ascii=False, separators=(',', ':')),
        encoding='utf-8',
    )

    print(
        f'Wrote {len(entries)} PDF-only entries to {OUTPUT} '
        f'({OUTPUT.stat().st_size} bytes)'
    )
    print(
        f'Excluded categories: {excluded}, '
        f'skipped without PDF: {skipped_no_pdf}, '
        f'resolved via detail attachments: {resolved_from_detail}'
    )
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
