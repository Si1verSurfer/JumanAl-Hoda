import { motion, useInView } from 'framer-motion';
import { useRef } from 'react';
import { APP_NAME, features } from '../data/content';

export function Features() {
  const ref = useRef(null);
  const inView = useInView(ref, { once: true, margin: '-80px' });

  return (
    <section id="features" className="relative py-24" ref={ref}>
      <div className="mx-auto max-w-6xl px-6">
        <motion.div
          initial={{ opacity: 0, y: 24 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.7 }}
          className="mb-16 text-center"
        >
          <p className="text-sm font-bold text-secondary">
            لماذا <span className="font-quran">{APP_NAME}</span>؟
          </p>
          <h2 className="font-naskh mt-3 text-4xl font-extrabold text-primary sm:text-5xl">
            تجربة عبادة متكاملة
          </h2>
          <p className="mx-auto mt-4 max-w-2xl text-base leading-relaxed text-primary/55">
            صُمّم التطبيق ليكون رفيقك اليومي في القرآن والأذكار ومواقيت الصلاة —
            بواجهة عربية هادئة وجميلة.
          </p>
        </motion.div>

        <div className="grid gap-8 md:grid-cols-2">
          {features.map((feature, index) => (
            <FeatureCard
              key={feature.id}
              feature={feature}
              index={index}
              inView={inView}
            />
          ))}
        </div>
      </div>
    </section>
  );
}

function FeatureCard({
  feature,
  index,
  inView,
}: {
  feature: (typeof features)[number];
  index: number;
  inView: boolean;
}) {
  const isEven = index % 2 === 0;

  return (
    <motion.article
      initial={{ opacity: 0, y: 40 }}
      animate={inView ? { opacity: 1, y: 0 } : {}}
      transition={{
        duration: 0.65,
        delay: index * 0.12,
        ease: [0.22, 1, 0.36, 1],
      }}
      whileHover={{ y: -6 }}
      className="group overflow-hidden rounded-3xl border border-primary/8 bg-white shadow-[0_16px_48px_rgba(44,15,18,0.07)]"
    >
      <div
        className={`grid items-center gap-6 p-6 sm:grid-cols-2 ${
          isEven ? '' : 'sm:[&>*:first-child]:order-2'
        }`}
      >
        <div className="relative overflow-hidden rounded-2xl bg-paper p-3">
          {feature.mock ? (
            <motion.img
              src={feature.mock}
              alt={feature.title}
              className="w-full rounded-xl"
              whileHover={{ scale: 1.03 }}
              transition={{ duration: 0.4 }}
            />
          ) : (
            <div
              className="flex min-h-[220px] flex-col items-center justify-center rounded-xl px-6 py-10 text-center"
              style={{
                background: `linear-gradient(145deg, ${feature.accent}18, ${feature.accent}08)`,
              }}
            >
              <span className="text-5xl">{feature.icon ?? '✨'}</span>
              <p className="font-naskh mt-4 text-lg font-bold text-primary">
                {feature.title}
              </p>
            </div>
          )}
          <div
            className="absolute inset-0 rounded-2xl opacity-0 transition-opacity group-hover:opacity-100"
            style={{
              background: `linear-gradient(135deg, ${feature.accent}12, transparent)`,
            }}
          />
        </div>

        <div className="px-2 pb-2">
          <span
            className="inline-block rounded-lg px-3 py-1 text-xs font-bold text-paper"
            style={{ backgroundColor: feature.accent }}
          >
            {String(index + 1).padStart(2, '0')}
          </span>
          <h3 className="font-naskh mt-4 text-2xl font-bold text-primary">
            {feature.title}
          </h3>
          <p className="mt-3 text-sm leading-7 text-primary/60">
            {feature.description}
          </p>
        </div>
      </div>
    </motion.article>
  );
}
