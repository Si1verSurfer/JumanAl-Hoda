import { SITE_URL, SUPPORT_EMAIL } from '../config/site';

export type SupportTopic = {
  id: string;
  icon: string;
  title: string;
  description: string;
};

export type SupportFaqItem = {
  id: string;
  icon: string;
  question: string;
  answer: string;
};

export const supportPage = {
  title: 'مركز الدعم',
  subtitle: 'نحن هنا لمساعدتك — إجابات سريعة وطرق تواصل مباشرة',
  heroBadge: 'مساعدة ودعم',
  quickActionsTitle: 'إجراءات سريعة',
  topicsTitle: 'مواضيع الدعم',
  faqTitle: 'الأسئلة الشائعة',
  ctaTitle: 'لم تجد إجابتك؟',
  ctaBody:
    'راسلنا وسنرد في أقرب وقت. اذكر نوع جهازك وإصدار النظام ووصفاً واضحاً للمشكلة.',
  ctaButton: 'تواصل معنا',
  emailLabel: 'إرسال بريد',
  copyLabel: 'نسخ البريد',
  websiteLabel: 'الموقع الرسمي',
  websiteUrl: SITE_URL,
  email: SUPPORT_EMAIL,
};

export const supportTopics: SupportTopic[] = [
  {
    id: 'notifications',
    icon: '🔔',
    title: 'إشعارات الصلاة',
    description: 'التفعيل، الأذان، والتذكيرات',
  },
  {
    id: 'location',
    icon: '📍',
    title: 'موقع الصلاة',
    description: 'المدينة، التوقيت، والحساب',
  },
  {
    id: 'quran',
    icon: '📖',
    title: 'القرآن والمحفوظات',
    description: 'القراءة، الآيات المحفوظة، والخط',
  },
  {
    id: 'settings',
    icon: '⚙️',
    title: 'المظهر والإعدادات',
    description: 'الوضع الليلي وصيغة الوقت',
  },
];

export const supportFaq: SupportFaqItem[] = [
  {
    id: 'notifications-off',
    icon: '🔔',
    question: 'إشعارات الصلاة لا تصل عند إغلاق التطبيق',
    answer:
      'تأكد من تفعيل إشعارات التطبيق من إعدادات الجهاز، ثم من الإعدادات ← إشعارات مواقيت الصلاة. على iPhone، اترك التطبيق يُحدّث الجدول مرة واحدة على الأقل بعد تحديد المدينة. إذا غيّرت المنطقة الزمنية للجهاز، افتح التطبيق لإعادة جدولة الأوقات حسب مدينتك.',
  },
  {
    id: 'change-location',
    icon: '📍',
    question: 'كيف أغيّر موقع مواقيت الصلاة؟',
    answer:
      'من شاشة مواقيت الصلاة اضغط على اسم المدينة أو «تغيير الموقع»، ثم ابحث عن مدينتك أو استخدم موقعك الحالي. سيتم حفظ الاختيار تلقائياً وتحديث الأوقات والإشعارات.',
  },
  {
    id: 'offline',
    icon: '📡',
    question: 'هل يعمل التطبيق بدون إنترنت؟',
    answer:
      'نعم. القرآن والأذكار ومواقيت الصلاة (حسب المدينة المحفوظة) تعمل بدون اتصال. تحميل الخطب ومزامنة بعض البيانات يتطلب إنترنتاً.',
  },
  {
    id: 'theme',
    icon: '🌙',
    question: 'كيف أغيّر مظهر التطبيق أو صيغة الوقت؟',
    answer:
      'من الإعدادات يمكنك اختيار الوضع الفاتح أو الداكن أو التلقائي، وتغيير صيغة عرض الوقت بين ١٢ و٢٤ ساعة.',
  },
  {
    id: 'report',
    icon: '🐛',
    question: 'كيف أبلّغ عن مشكلة أو أقترح تحسيناً؟',
    answer:
      'استخدم زر «إرسال بريد» في هذه الصفحة. اذكر نوع الجهاز وإصدار النظام ووصفاً واضحاً للمشكلة لنساعدك أسرع.',
  },
];
