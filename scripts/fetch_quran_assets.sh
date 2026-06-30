#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG="$ROOT/packages/quran_package/qcf_quran"
UPSTREAM="https://github.com/m4hmoud-atef/qcf_quran.git"

if [[ -d "$PKG/assets/fonts/qcf4" && -f "$PKG/lib/src/data/quran_text.dart" ]]; then
  echo "Quran assets already present."
  exit 0
fi

echo "Fetching large qcf_quran assets from upstream..."
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

git clone --depth 1 "$UPSTREAM" "$TMP/qcf"

mkdir -p "$PKG/assets" "$PKG/lib/src/data"
cp -R "$TMP/qcf/assets/fonts" "$PKG/assets/"
cp "$TMP/qcf/lib/src/data/quran_text.dart" "$PKG/lib/src/data/"

echo "Done. Fonts and quran_text.dart are installed under packages/quran_package/qcf_quran/"
