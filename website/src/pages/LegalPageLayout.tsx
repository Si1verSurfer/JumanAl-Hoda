import { motion } from 'framer-motion';
import { Link, useSearchParams } from 'react-router-dom';
import { APP_NAME } from '../data/content';

type LegalPageProps = {
  title: string;
  lastUpdated: string;
  intro: string;
  sections: {
    title: string;
    paragraphs: string[];
    bullets?: string[];
  }[];
};

export function LegalPageLayout({ title, lastUpdated, intro, sections }: LegalPageProps) {
  const [searchParams] = useSearchParams();
  const embedded = searchParams.get('embed') === '1';

  return (
    <div className="min-h-screen bg-surface">
      {!embedded && (
        <header className="border-b border-primary/8 bg-white/80 backdrop-blur-xl">
          <div className="mx-auto flex max-w-4xl items-center justify-between px-6 py-4">
            <Link
              to="/"
              className="flex items-center gap-3 transition-opacity hover:opacity-80"
            >
              <img
                src="/app-icon.png"
                alt={APP_NAME}
                className="h-10 w-10 rounded-xl shadow-md"
              />
              <span className="font-quran text-lg text-primary">{APP_NAME}</span>
            </Link>
            <Link
              to="/"
              className="rounded-xl border border-primary/10 px-4 py-2 text-sm font-semibold text-primary/70 transition-colors hover:border-secondary/30 hover:text-secondary"
            >
              العودة للرئيسية
            </Link>
          </div>
        </header>
      )}

      <main
        className={`mx-auto max-w-4xl px-6 ${embedded ? 'py-6' : 'py-12'}`}
      >
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <p className="text-sm font-bold text-secondary">وثيقة قانونية</p>
          <h1 className="font-quran mt-2 text-4xl text-primary sm:text-5xl">
            {title}
          </h1>
          <p className="mt-3 text-sm text-primary/45">آخر تحديث: {lastUpdated}</p>

          <div className="mt-8 rounded-2xl border border-secondary/12 bg-paper/60 p-6">
            <p className="text-base leading-8 text-primary/75">{intro}</p>
          </div>
        </motion.div>

        <div className="mt-10 space-y-8">
          {sections.map((section, index) => (
            <motion.section
              key={section.title}
              initial={{ opacity: 0, y: 24 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true, margin: '-40px' }}
              transition={{ duration: 0.5, delay: index * 0.03 }}
              className="rounded-2xl border border-primary/8 bg-white p-6 shadow-sm"
            >
              <h2 className="font-naskh text-xl font-bold text-primary">
                {section.title}
              </h2>
              <div className="mt-4 space-y-3">
                {section.paragraphs.map((paragraph) => (
                  <p
                    key={paragraph.slice(0, 40)}
                    className="text-sm leading-8 text-primary/70"
                  >
                    {paragraph}
                  </p>
                ))}
              </div>
              {section.bullets && section.bullets.length > 0 && (
                <ul className="mt-4 space-y-2">
                  {section.bullets.map((bullet) => (
                    <li
                      key={bullet.slice(0, 40)}
                      className="flex gap-3 text-sm leading-7 text-primary/65"
                    >
                      <span className="mt-2 h-1.5 w-1.5 shrink-0 rounded-full bg-secondary" />
                      <span>{bullet}</span>
                    </li>
                  ))}
                </ul>
              )}
            </motion.section>
          ))}
        </div>
      </main>
    </div>
  );
}
