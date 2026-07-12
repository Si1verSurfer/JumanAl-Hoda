import { PageMeta } from '../components/PageMeta';
import { privacyPolicy } from '../data/legal';
import { LegalPageLayout } from './LegalPageLayout';

export function PrivacyPage() {
  return (
    <>
      <PageMeta
        title={privacyPolicy.title}
        description={privacyPolicy.intro}
        path="/privacy"
      />
      <LegalPageLayout
        title={privacyPolicy.title}
        lastUpdated={privacyPolicy.lastUpdated}
        intro={privacyPolicy.intro}
        sections={privacyPolicy.sections}
      />
    </>
  );
}
