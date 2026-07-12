import { motion } from 'framer-motion';
import { Link } from 'react-router-dom';
import { APP_NAME } from '../data/content';

type NavLink =
  | { type: 'anchor'; href: string; label: string }
  | { type: 'route'; to: string; label: string };

const links: NavLink[] = [
  { type: 'anchor', href: '#features', label: 'المميزات' },
  { type: 'anchor', href: '#screens', label: 'لقطات التطبيق' },
  { type: 'anchor', href: '#download', label: 'التحميل' },
  { type: 'route', to: '/support', label: 'الدعم' },
];

export function Navbar() {
  return (
    <motion.header
      initial={{ y: -24, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ duration: 0.7, ease: [0.22, 1, 0.36, 1] }}
      className="fixed inset-x-0 top-0 z-50 px-4 pt-4"
    >
      <nav className="mx-auto flex max-w-6xl items-center justify-between rounded-2xl border border-primary/8 bg-white/75 px-5 py-3 shadow-[0_8px_32px_rgba(44,15,18,0.08)] backdrop-blur-xl">
        <Link to="/" className="flex items-center gap-3">
          <img
            src="/app-icon.png"
            alt={APP_NAME}
            className="h-10 w-10 rounded-xl shadow-md"
          />
          <span className="font-quran text-xl text-primary">
            {APP_NAME}
          </span>
        </Link>

        <div className="hidden items-center gap-8 md:flex">
          {links.map((link) =>
            link.type === 'route' ? (
              <Link
                key={link.to}
                to={link.to}
                className="text-sm font-semibold text-primary/65 transition-colors hover:text-secondary"
              >
                {link.label}
              </Link>
            ) : (
              <a
                key={link.href}
                href={link.href}
                className="text-sm font-semibold text-primary/65 transition-colors hover:text-secondary"
              >
                {link.label}
              </a>
            ),
          )}
        </div>

        <motion.a
          href="#download"
          whileHover={{ scale: 1.04 }}
          whileTap={{ scale: 0.97 }}
          className="rounded-xl bg-gradient-to-l from-secondary to-[#4a1520] px-5 py-2.5 text-sm font-bold text-paper shadow-lg shadow-secondary/25"
        >
          حمّل التطبيق
        </motion.a>
      </nav>
    </motion.header>
  );
}
