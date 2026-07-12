import { motion } from 'framer-motion';
import { highlights } from '../data/content';

export function HighlightMarquee() {
  const doubled = [...highlights, ...highlights];

  return (
    <section className="overflow-hidden border-y border-primary/6 bg-paper/60 py-6">
      <motion.div
        animate={{ x: ['0%', '50%'] }}
        transition={{ duration: 28, repeat: Infinity, ease: 'linear' }}
        className="flex w-max gap-4 px-4"
      >
        {doubled.map((item, index) => (
          <div
            key={`${item.label}-${index}`}
            className="flex items-center gap-2 rounded-full border border-primary/8 bg-white px-5 py-2.5 shadow-sm"
          >
            <span className="text-lg">{item.icon}</span>
            <span className="whitespace-nowrap text-sm font-semibold text-primary/75">
              {item.label}
            </span>
          </div>
        ))}
      </motion.div>
    </section>
  );
}
