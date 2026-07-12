import { PageMeta } from '../components/PageMeta';
import { termsAndConditions } from '../data/legal';
import { LegalPageLayout } from './LegalPageLayout';

export function TermsPage() {
  return (
    <>
      <PageMeta
        title={termsAndConditions.title}
        description={termsAndConditions.intro}
        path="/terms"
      />
      <LegalPageLayout
        title={termsAndConditions.title}
        lastUpdated={termsAndConditions.lastUpdated}
        intro={termsAndConditions.intro}
        sections={termsAndConditions.sections}
      />
    </>
  );
}
