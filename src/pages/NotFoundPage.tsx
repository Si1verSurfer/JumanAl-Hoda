import { Link } from 'react-router-dom';
import { PageMeta } from '../components/PageMeta';
import { APP_NAME } from '../data/content';

export function NotFoundPage() {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center bg-surface px-6 text-center">
      <PageMeta title="الصفحة غير موجودة" path="/404" />
      <p className="font-quran text-6xl text-secondary">٤٠٤</p>
      <h1 className="font-naskh mt-4 text-3xl font-bold text-primary">
        الصفحة غير موجودة
      </h1>
      <p className="mt-3 max-w-md text-sm leading-7 text-primary/55">
        يبدو أن الرابط الذي طلبته غير صحيح. عد إلى الصفحة الرئيسية لتطبيق{' '}
        {APP_NAME}.
      </p>
      <Link
        to="/"
        className="mt-8 rounded-2xl bg-gradient-to-l from-secondary to-[#4a1520] px-8 py-4 text-sm font-bold text-paper shadow-lg shadow-secondary/25"
      >
        العودة للرئيسية
      </Link>
    </div>
  );
}
