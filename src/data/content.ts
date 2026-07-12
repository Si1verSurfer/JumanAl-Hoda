export type Feature = {
  id: string;
  title: string;
  description: string;
  accent: string;
  mock?: string;
  icon?: string;
};

export const APP_NAME = 'جُمانُ الهُدَى';
export const APP_TAGLINE = 'أذكار الصباح والمساء والأذكار اليومية';
export const APP_SPLASH =
  'القرآن · الأذكار · مواقيت الصلاة · القبلة · الخطب';

export const SUPPORT_EMAIL = 'basharrezk9@gmail.com';

export const features: Feature[] = [
  {
    id: 'adhkar',
    title: 'الأذكار والعبادة',
    description:
      'أبواب العبادة، السبحة الإلكترونية، أسماء الله الحسنى، واتجاه القبلة — كل ما تحتاجه يومياً في مكان واحد.',
    accent: '#6B1E23',
    icon: '📿',
  },
  {
    id: 'quran',
    title: 'القرآن الكريم',
    description:
      'اقرأ المصحف بخط واضح، ابحث عن السور والآيات، واحفظ آياتك المفضلة بسهولة.',
    mock: '/mocks/image2.png',
    accent: '#4A1520',
  },
  {
    id: 'prayer',
    title: 'مواقيت الصلاة',
    description:
      'مواقيت دقيقة حسب موقعك، تنبيهات الأذان، والتاريخ الهجري — مع واجهة هادئة ومريحة.',
    mock: '/mocks/image3.png',
    accent: '#8B2830',
  },
  {
    id: 'khutbahs',
    title: 'الخطب والأدلة',
    description:
      'مكتبة خطب منظّمة، أدلة العبادة، وآداب الدعاء — محتوى موثوق بتجربة قراءة جميلة.',
    mock: '/mocks/image4.png',
    accent: '#5C1F28',
  },
];

export const carouselFeatures = features.filter((f) => f.mock);

export const highlights = [
  { icon: '📖', label: 'مصحف تفاعلي' },
  { icon: '🕌', label: 'مواقيت وقبلة' },
  { icon: '📿', label: 'سبحة إلكترونية' },
  { icon: '📚', label: 'مكتبة خطب' },
  { icon: '🌙', label: 'أذكار يومية' },
  { icon: '🔔', label: 'تنبيهات الأذان' },
];
