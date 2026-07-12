import { motion } from 'framer-motion';

export function FloatingOrbs() {
  return (
    <div className="pointer-events-none absolute inset-0 overflow-hidden">
      <motion.div
        animate={{ x: [0, 30, 0], y: [0, -20, 0] }}
        transition={{ duration: 14, repeat: Infinity, ease: 'easeInOut' }}
        className="absolute -left-20 top-32 h-72 w-72 rounded-full bg-secondary/10 blur-3xl"
      />
      <motion.div
        animate={{ x: [0, -24, 0], y: [0, 28, 0] }}
        transition={{ duration: 18, repeat: Infinity, ease: 'easeInOut' }}
        className="absolute -right-16 top-1/3 h-96 w-96 rounded-full bg-primary/8 blur-3xl"
      />
      <motion.div
        animate={{ scale: [1, 1.08, 1], opacity: [0.4, 0.65, 0.4] }}
        transition={{ duration: 10, repeat: Infinity, ease: 'easeInOut' }}
        className="absolute bottom-20 left-1/3 h-64 w-64 rounded-full bg-paper blur-3xl"
      />
    </div>
  );
}
