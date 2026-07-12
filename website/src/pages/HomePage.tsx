import { PageMeta } from '../components/PageMeta';
import { SITE_DESCRIPTION, SITE_NAME } from '../config/site';
import { Navbar } from '../components/Navbar';
import { Hero } from '../components/Hero';
import { HighlightMarquee } from '../components/HighlightMarquee';
import { Features } from '../components/Features';
import { DownloadSection } from '../components/DownloadSection';
import { Footer } from '../components/Footer';

export function HomePage() {
  return (
    <>
      <PageMeta
        title={SITE_NAME}
        description={SITE_DESCRIPTION}
        path="/"
      />
      <Navbar />
      <main>
        <Hero />
        <HighlightMarquee />
        <Features />
        <DownloadSection />
      </main>
      <Footer />
    </>
  );
}
