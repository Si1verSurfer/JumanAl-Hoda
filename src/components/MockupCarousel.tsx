import { useEffect, useState } from 'react';
import { AnimatePresence, motion } from 'framer-motion';
import { carouselFeatures } from '../data/content';

export function MockupCarousel() {
  const [active, setActive] = useState(0);

  useEffect(() => {
    const timer = setInterval(() => {
      setActive((prev) => (prev + 1) % carouselFeatures.length);
    }, 4200);
    return () => clearInterval(timer);
  }, []);

  return (
    <div className="relative mx-auto w-full max-w-sm lg:max-w-md">
      <motion.div
        animate={{ y: [0, -10, 0] }}
        transition={{ duration: 5, repeat: Infinity, ease: 'easeInOut' }}
        className="phone-shadow relative"
      >
        <div className="absolute -inset-6 rounded-[3rem] bg-gradient-to-b from-secondary/20 via-transparent to-primary/10 blur-2xl" />

        <AnimatePresence mode="wait">
          <motion.img
            key={carouselFeatures[active].id}
            src={carouselFeatures[active].mock!}
            alt={carouselFeatures[active].title}
            initial={{ opacity: 0, scale: 0.96, y: 12 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            exit={{ opacity: 0, scale: 1.02, y: -8 }}
            transition={{ duration: 0.55, ease: [0.22, 1, 0.36, 1] }}
            className="relative w-full rounded-[2rem]"
          />
        </AnimatePresence>
      </motion.div>

      <div className="mt-8 flex justify-center gap-2">
        {carouselFeatures.map((feature, index) => (
          <button
            key={feature.id}
            type="button"
            aria-label={feature.title}
            onClick={() => setActive(index)}
            className="group p-1"
          >
            <motion.span
              animate={{
                width: index === active ? 32 : 8,
                backgroundColor:
                  index === active ? '#6B1E23' : 'rgba(44,15,18,0.18)',
              }}
              className="block h-2 rounded-full"
            />
          </button>
        ))}
      </div>

      <AnimatePresence mode="wait">
        <motion.p
          key={carouselFeatures[active].title}
          initial={{ opacity: 0, y: 8 }}
          animate={{ opacity: 1, y: 0 }}
          exit={{ opacity: 0, y: -6 }}
          className="mt-4 text-center text-sm font-semibold text-secondary"
        >
          {carouselFeatures[active].title}
        </motion.p>
      </AnimatePresence>
    </div>
  );
}
