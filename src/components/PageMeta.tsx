import { useEffect } from 'react';
import { SITE_DESCRIPTION, SITE_NAME, SITE_URL } from '../config/site';

type PageMetaProps = {
  title: string;
  description?: string;
  path?: string;
};

function upsertMeta(
  attribute: 'name' | 'property',
  key: string,
  content: string,
) {
  const selector = `meta[${attribute}="${key}"]`;
  let element = document.querySelector(selector) as HTMLMetaElement | null;
  if (!element) {
    element = document.createElement('meta');
    element.setAttribute(attribute, key);
    document.head.appendChild(element);
  }
  element.setAttribute('content', content);
}

export function PageMeta({ title, description, path = '' }: PageMetaProps) {
  useEffect(() => {
    const fullTitle = title === SITE_NAME ? title : `${title} | ${SITE_NAME}`;
    const metaDescription = description ?? SITE_DESCRIPTION;
    const canonicalUrl = `${SITE_URL}${path}`;

    document.title = fullTitle;

    upsertMeta('name', 'description', metaDescription);
    upsertMeta('property', 'og:title', fullTitle);
    upsertMeta('property', 'og:description', metaDescription);
    upsertMeta('property', 'og:url', canonicalUrl);
    upsertMeta('name', 'twitter:title', fullTitle);
    upsertMeta('name', 'twitter:description', metaDescription);

    let canonical = document.querySelector(
      'link[rel="canonical"]',
    ) as HTMLLinkElement | null;
    if (!canonical) {
      canonical = document.createElement('link');
      canonical.rel = 'canonical';
      document.head.appendChild(canonical);
    }
    canonical.href = canonicalUrl;
  }, [title, description, path]);

  return null;
}
