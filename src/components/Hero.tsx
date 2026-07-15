import { motion } from 'framer-motion';
import { APP_STORE_URL } from '../config/site';
import { APP_NAME, APP_SPLASH, APP_TAGLINE } from '../data/content';
import { MockupCarousel } from './MockupCarousel';
import { FloatingOrbs } from './FloatingOrbs';

const container = {
  hidden: { opacity: 0 },
  show: {
    opacity: 1,
    transition: { staggerChildren: 0.12, delayChildren: 0.15 },
  },
};

const item = {
  hidden: { opacity: 0, y: 28 },
  show: {
    opacity: 1,
    y: 0,
    transition: { duration: 0.7, ease: 'easeOut' as const },
  },
};

export function Hero() {
  return (
    <section className="hero-glow pattern-overlay relative min-h-screen overflow-hidden pt-32 pb-20">
      <FloatingOrbs />

      <div className="relative mx-auto grid max-w-6xl items-center gap-14 px-6 lg:grid-cols-2 lg:gap-10">
        <motion.div
          variants={container}
          initial="hidden"
          animate="show"
          className="text-center lg:text-right"
        >
          <motion.div
            variants={item}
            className="mb-6 inline-flex items-center gap-2 rounded-full border border-secondary/15 bg-paper/80 px-4 py-2 text-sm font-semibold text-secondary shadow-sm"
          >
            <span className="h-2 w-2 animate-pulse rounded-full bg-secondary" />
            تطبيق عربي للعبادة اليومية
          </motion.div>

          <motion.h1
            variants={item}
            className="font-quran text-5xl leading-tight sm:text-6xl lg:text-7xl"
          >
            <span className="gradient-text">{APP_NAME}</span>
          </motion.h1>

          <motion.p
            variants={item}
            className="mt-5 text-xl font-semibold text-primary/75"
          >
            {APP_TAGLINE}
          </motion.p>

          <motion.p
            variants={item}
            className="mt-4 text-base leading-relaxed text-primary/55"
          >
            {APP_SPLASH}
          </motion.p>

          <motion.div
            variants={item}
            className="mt-10 flex flex-wrap items-center justify-center gap-4 lg:justify-start"
          >
            <motion.a
              href={APP_STORE_URL}
              target="_blank"
              rel="noopener noreferrer"
              whileHover={{ scale: 1.04, y: -2 }}
              whileTap={{ scale: 0.97 }}
              className="inline-flex items-center gap-2 rounded-2xl bg-gradient-to-l from-secondary to-[#4a1520] px-8 py-4 text-base font-bold text-paper shadow-xl shadow-secondary/30"
            >
              <AppleIcon />
              حمّل من App Store
            </motion.a>
            <motion.a
              href="#features"
              whileHover={{ scale: 1.03 }}
              whileTap={{ scale: 0.97 }}
              className="inline-flex items-center gap-2 rounded-2xl border border-primary/12 bg-white/80 px-8 py-4 text-base font-bold text-primary backdrop-blur-sm"
            >
              اكتشف المميزات
            </motion.a>
          </motion.div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, scale: 0.92, y: 40 }}
          animate={{ opacity: 1, scale: 1, y: 0 }}
          transition={{ duration: 0.9, delay: 0.25, ease: [0.22, 1, 0.36, 1] }}
          id="screens"
        >
          <MockupCarousel />
        </motion.div>
      </div>
    </section>
  );
}

function AppleIcon() {
  return (
    <svg viewBox="0 0 24 24" className="h-5 w-5 fill-current" aria-hidden>
      <path d="M17.05 20.28c-.98.95-2.05.8-3.08.35-1.09-.46-2.09-.48-3.24 0-1.44.62-2.2.44-3.06-.35C2.79 15.25 3.51 7.59 9.05 7.31c1.35.07 2.29.74 3.08.8 1.18-.24 2.31-.93 3.57-.84 1.51.12 2.65.72 3.4 1.8-3.12 1.87-2.38 5.98.48 7.13-.57 1.5-1.31 2.99-2.54 4.09zM12.03 7.25c-.15-2.23 1.66-4.07 3.74-4.25.29 2.58-2.34 4.5-3.74 4.25z" />
    </svg>
  );
}
