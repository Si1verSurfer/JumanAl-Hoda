import { AnimatePresence, motion } from 'framer-motion';
import { useCallback, useState } from 'react';
import { Link, useSearchParams } from 'react-router-dom';
import { PageMeta } from '../components/PageMeta';
import { Footer } from '../components/Footer';
import { APP_NAME } from '../data/content';
import {
  supportFaq,
  supportPage,
  supportTopics,
} from '../data/support';

function copyToClipboard(text: string) {
  void navigator.clipboard.writeText(text);
}

export function SupportPage() {
  const [searchParams] = useSearchParams();
  const embedded = searchParams.get('embed') === '1';
  const [expandedId, setExpandedId] = useState<string | null>(null);
  const [copied, setCopied] = useState(false);

  const handleCopyEmail = useCallback(() => {
    copyToClipboard(supportPage.email);
    setCopied(true);
    window.setTimeout(() => setCopied(false), 2000);
  }, []);

  const mailtoHref = `mailto:${supportPage.email}?subject=${encodeURIComponent(
    'دعم تطبيق جُمانُ الهُدَى',
  )}`;

  return (
    <>
      <PageMeta
        title={supportPage.title}
        description={supportPage.subtitle}
        path="/support"
      />

      <div className="min-h-screen bg-surface">
        {!embedded && (
          <header className="fixed inset-x-0 top-0 z-50 border-b border-primary/8 bg-white/80 backdrop-blur-xl">
            <div className="mx-auto flex max-w-5xl items-center justify-between px-6 py-4">
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

        <main className={`mx-auto max-w-5xl px-6 ${embedded ? 'py-8' : 'pb-16 pt-28'}`}>
          {/* Hero */}
          <motion.section
            initial={{ opacity: 0, y: 24 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            className="relative overflow-hidden rounded-3xl bg-gradient-to-bl from-[#8B2A32] via-secondary to-primary p-8 shadow-[0_20px_60px_rgba(107,30,35,0.28)] sm:p-10"
          >
            <div
              className="pointer-events-none absolute -left-16 -top-16 h-48 w-48 rounded-full bg-white/10 blur-3xl"
              aria-hidden
            />
            <div
              className="pointer-events-none absolute -bottom-12 -right-8 h-40 w-40 rounded-full bg-paper/10 blur-2xl"
              aria-hidden
            />

            <div className="relative text-center sm:text-right">
              <span className="inline-flex items-center gap-2 rounded-full border border-paper/25 bg-paper/10 px-4 py-1.5 text-sm font-bold text-paper/90">
                <span className="h-2 w-2 rounded-full bg-paper" />
                {supportPage.heroBadge}
              </span>
              <h1 className="font-quran mt-5 text-4xl text-paper sm:text-5xl">
                {supportPage.title}
              </h1>
              <p className="mt-4 max-w-xl text-base leading-relaxed text-paper/85 sm:mr-0 sm:ml-auto">
                {supportPage.subtitle}
              </p>
            </div>
          </motion.section>

          {/* Quick actions */}
          <motion.section
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5, delay: 0.1 }}
            className="mt-10"
          >
            <h2 className="mb-4 flex items-center gap-2 text-sm font-extrabold text-secondary">
              <span className="text-lg">⚡</span>
              {supportPage.quickActionsTitle}
            </h2>
            <div className="grid gap-3 sm:grid-cols-3">
              <a
                href={mailtoHref}
                className="group flex items-center justify-center gap-3 rounded-2xl border border-secondary/15 bg-white px-5 py-4 text-center shadow-sm transition-all hover:border-secondary/35 hover:shadow-md"
              >
                <span className="flex h-10 w-10 items-center justify-center rounded-xl bg-secondary/10 text-lg transition-colors group-hover:bg-secondary/18">
                  ✉️
                </span>
                <span className="font-bold text-primary">{supportPage.emailLabel}</span>
              </a>

              <button
                type="button"
                onClick={handleCopyEmail}
                className="group flex items-center justify-center gap-3 rounded-2xl border border-secondary/15 bg-white px-5 py-4 text-center shadow-sm transition-all hover:border-secondary/35 hover:shadow-md"
              >
                <span className="flex h-10 w-10 items-center justify-center rounded-xl bg-secondary/10 text-lg transition-colors group-hover:bg-secondary/18">
                  {copied ? '✓' : '📋'}
                </span>
                <span className="font-bold text-primary">
                  {copied ? 'تم النسخ!' : supportPage.copyLabel}
                </span>
              </button>

              <a
                href={supportPage.websiteUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="group flex items-center justify-center gap-3 rounded-2xl border border-secondary/15 bg-white px-5 py-4 text-center shadow-sm transition-all hover:border-secondary/35 hover:shadow-md"
              >
                <span className="flex h-10 w-10 items-center justify-center rounded-xl bg-secondary/10 text-lg transition-colors group-hover:bg-secondary/18">
                  🌐
                </span>
                <span className="font-bold text-primary">{supportPage.websiteLabel}</span>
              </a>
            </div>
            <p className="mt-3 text-center text-sm font-semibold text-primary/45 sm:text-right">
              {supportPage.email}
            </p>
          </motion.section>

          {/* Topics */}
          <motion.section
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5, delay: 0.15 }}
            className="mt-12"
          >
            <h2 className="mb-5 flex items-center gap-2 text-sm font-extrabold text-secondary">
              <span className="text-lg">📚</span>
              {supportPage.topicsTitle}
            </h2>
            <div className="grid gap-4 sm:grid-cols-2">
              {supportTopics.map((topic, index) => (
                <motion.div
                  key={topic.id}
                  initial={{ opacity: 0, y: 16 }}
                  whileInView={{ opacity: 1, y: 0 }}
                  viewport={{ once: true }}
                  transition={{ duration: 0.4, delay: index * 0.05 }}
                  className="rounded-2xl border border-primary/8 bg-white p-5 shadow-sm transition-shadow hover:shadow-md"
                >
                  <div className="flex items-start gap-4">
                    <span className="flex h-12 w-12 shrink-0 items-center justify-center rounded-xl bg-gradient-to-bl from-secondary/15 to-secondary/5 text-2xl">
                      {topic.icon}
                    </span>
                    <div>
                      <h3 className="font-naskh text-lg font-bold text-primary">
                        {topic.title}
                      </h3>
                      <p className="mt-1 text-sm leading-relaxed text-primary/55">
                        {topic.description}
                      </p>
                    </div>
                  </div>
                </motion.div>
              ))}
            </div>
          </motion.section>

          {/* FAQ */}
          <motion.section
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5, delay: 0.2 }}
            className="mt-12"
          >
            <h2 className="mb-5 flex items-center gap-2 text-sm font-extrabold text-secondary">
              <span className="text-lg">❓</span>
              {supportPage.faqTitle}
            </h2>
            <div className="space-y-3">
              {supportFaq.map((item) => {
                const open = expandedId === item.id;
                return (
                  <div
                    key={item.id}
                    className="overflow-hidden rounded-2xl border border-primary/8 bg-white shadow-sm"
                  >
                    <button
                      type="button"
                      onClick={() =>
                        setExpandedId(open ? null : item.id)
                      }
                      className="flex w-full items-center gap-4 px-5 py-4 text-right transition-colors hover:bg-paper/40"
                      aria-expanded={open}
                    >
                      <span className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-secondary/8 text-lg">
                        {item.icon}
                      </span>
                      <span className="flex-1 font-naskh text-base font-bold text-primary">
                        {item.question}
                      </span>
                      <motion.span
                        animate={{ rotate: open ? 180 : 0 }}
                        transition={{ duration: 0.25 }}
                        className="shrink-0 text-secondary"
                        aria-hidden
                      >
                        ▾
                      </motion.span>
                    </button>

                    <AnimatePresence initial={false}>
                      {open && (
                        <motion.div
                          initial={{ height: 0, opacity: 0 }}
                          animate={{ height: 'auto', opacity: 1 }}
                          exit={{ height: 0, opacity: 0 }}
                          transition={{ duration: 0.28, ease: 'easeInOut' }}
                          className="overflow-hidden"
                        >
                          <p className="border-t border-primary/6 px-5 py-4 text-sm leading-8 text-primary/70">
                            {item.answer}
                          </p>
                        </motion.div>
                      )}
                    </AnimatePresence>
                  </div>
                );
              })}
            </div>
          </motion.section>

          {/* CTA */}
          <motion.section
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5 }}
            className="mt-12 overflow-hidden rounded-3xl bg-gradient-to-bl from-[#8B2A32] via-secondary to-primary p-8 text-center shadow-[0_16px_48px_rgba(107,30,35,0.22)] sm:text-right"
          >
            <h2 className="font-quran text-2xl text-paper sm:text-3xl">
              {supportPage.ctaTitle}
            </h2>
            <p className="mt-3 text-sm leading-relaxed text-paper/82">
              {supportPage.ctaBody}
            </p>
            <a
              href={mailtoHref}
              className="mt-6 inline-flex items-center gap-2 rounded-xl bg-paper px-6 py-3 text-sm font-extrabold text-secondary shadow-lg transition-transform hover:scale-[1.02] active:scale-[0.98]"
            >
              ✉️ {supportPage.ctaButton}
            </a>
          </motion.section>
        </main>

        {!embedded && <Footer />}
      </div>
    </>
  );
}
