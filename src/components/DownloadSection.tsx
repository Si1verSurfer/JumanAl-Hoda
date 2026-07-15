import { motion, useInView } from 'framer-motion';
import { useRef } from 'react';
import { APP_STORE_URL } from '../config/site';
import { APP_NAME, SUPPORT_EMAIL } from '../data/content';

export function DownloadSection() {
  const ref = useRef(null);
  const inView = useInView(ref, { once: true, margin: '-60px' });

  return (
    <section
      id="download"
      ref={ref}
      className="relative overflow-hidden py-24"
    >
      <div className="absolute inset-0 bg-gradient-to-b from-paper via-cream to-paper" />
      <motion.div
        animate={{ rotate: 360 }}
        transition={{ duration: 80, repeat: Infinity, ease: 'linear' }}
        className="absolute -left-32 top-1/2 h-96 w-96 rounded-full border border-secondary/10"
      />
      <motion.div
        animate={{ rotate: -360 }}
        transition={{ duration: 100, repeat: Infinity, ease: 'linear' }}
        className="absolute -right-24 top-10 h-80 w-80 rounded-full border border-primary/8"
      />

      <motion.div
        initial={{ opacity: 0, y: 32 }}
        animate={inView ? { opacity: 1, y: 0 } : {}}
        transition={{ duration: 0.75 }}
        className="relative mx-auto max-w-3xl px-6 text-center"
      >
        <img
          src="/app-icon.png"
          alt={APP_NAME}
          className="mx-auto h-24 w-24 rounded-3xl shadow-2xl shadow-secondary/25"
        />

        <h2 className="font-naskh mt-8 text-4xl font-extrabold text-primary sm:text-5xl">
          ابدأ رحلتك مع{' '}
          <span className="font-quran">{APP_NAME}</span>
        </h2>
        <p className="mt-4 text-base leading-relaxed text-primary/60">
          حمّل التطبيق مجاناً واستمتع بتجربة عربية راقية للقرآن والأذكار
          ومواقيت الصلاة.
        </p>

        <motion.a
          href={APP_STORE_URL}
          target="_blank"
          rel="noopener noreferrer"
          whileHover={{ scale: 1.05, y: -3 }}
          whileTap={{ scale: 0.97 }}
          className="mt-10 inline-flex items-center gap-3 rounded-2xl bg-gradient-to-l from-secondary to-[#4a1520] px-10 py-5 text-lg font-bold text-paper shadow-2xl shadow-secondary/35"
        >
          <svg viewBox="0 0 24 24" className="h-6 w-6 fill-current" aria-hidden>
            <path d="M17.05 20.28c-.98.95-2.05.8-3.08.35-1.09-.46-2.09-.48-3.24 0-1.44.62-2.2.44-3.06-.35C2.79 15.25 3.51 7.59 9.05 7.31c1.35.07 2.29.74 3.08.8 1.18-.24 2.31-.93 3.57-.84 1.51.12 2.65.72 3.4 1.8-3.12 1.87-2.38 5.98.48 7.13-.57 1.5-1.31 2.99-2.54 4.09zM12.03 7.25c-.15-2.23 1.66-4.07 3.74-4.25.29 2.58-2.34 4.5-3.74 4.25z" />
          </svg>
          حمّل من App Store
        </motion.a>

        <p className="mt-8 text-sm text-primary/45">
          للدعم والاستفسارات:{' '}
          <a
            href={`mailto:${SUPPORT_EMAIL}`}
            className="font-semibold text-secondary hover:underline"
          >
            {SUPPORT_EMAIL}
          </a>
        </p>
      </motion.div>
    </section>
  );
}
