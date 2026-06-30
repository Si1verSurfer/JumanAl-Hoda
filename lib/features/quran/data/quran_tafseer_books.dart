class TafseerBook {
  const TafseerBook({
    required this.slug,
    required this.nameArabic,
  });

  final String slug;
  final String nameArabic;
}

/// Arabic ayah tafseer resources from Quran.com (qdc API).
const quranArabicTafseerBooks = [
  TafseerBook(
    slug: 'ar-tafsir-muyassar',
    nameArabic: 'التفسير الميسر',
  ),
  TafseerBook(
    slug: 'ar-tafsir-ibn-kathir',
    nameArabic: 'تفسير ابن كثير',
  ),
  TafseerBook(
    slug: 'ar-tafsir-al-tabari',
    nameArabic: 'تفسير الطبري',
  ),
  TafseerBook(
    slug: 'ar-tafseer-al-qurtubi',
    nameArabic: 'تفسير القرطبي',
  ),
  TafseerBook(
    slug: 'ar-tafsir-al-baghawi',
    nameArabic: 'تفسير البغوي',
  ),
  TafseerBook(
    slug: 'ar-tafseer-al-saddi',
    nameArabic: 'تفسير السعدي',
  ),
  TafseerBook(
    slug: 'ar-tafsir-al-wasit',
    nameArabic: 'التفسير الوسيط',
  ),
];

TafseerBook tafseerBookBySlug(String slug) {
  return quranArabicTafseerBooks.firstWhere(
    (book) => book.slug == slug,
    orElse: () => quranArabicTafseerBooks.first,
  );
}
