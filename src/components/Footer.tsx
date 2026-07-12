import { Link } from 'react-router-dom';
import { APP_NAME, SUPPORT_EMAIL } from '../data/content';

export function Footer() {
  return (
    <footer className="border-t border-primary/8 bg-primary py-12 text-paper">
      <div className="mx-auto flex max-w-6xl flex-col items-center gap-8 px-6 text-center sm:flex-row sm:items-start sm:justify-between sm:text-right">
        <div className="flex items-center gap-3">
          <img
            src="/app-icon.png"
            alt={APP_NAME}
            className="h-12 w-12 rounded-xl"
          />
          <div>
            <p className="font-quran text-xl">{APP_NAME}</p>
            <p className="text-sm text-paper/65">رفيقك في الذكر والعبادة اليومية</p>
          </div>
        </div>

        <nav className="flex flex-col gap-2 text-sm text-paper/75">
          <Link to="/privacy" className="font-semibold transition-colors hover:text-paper">
            سياسة الخصوصية
          </Link>
          <Link to="/terms" className="font-semibold transition-colors hover:text-paper">
            الشروط والأحكام
          </Link>
        </nav>

        <div className="text-sm text-paper/70">
          <p>
            © {new Date().getFullYear()}{' '}
            <span className="font-quran">{APP_NAME}</span>
          </p>
          <a
            href={`mailto:${SUPPORT_EMAIL}`}
            className="mt-1 inline-block font-semibold text-paper/90 hover:underline"
          >
            {SUPPORT_EMAIL}
          </a>
        </div>
      </div>
    </footer>
  );
}
