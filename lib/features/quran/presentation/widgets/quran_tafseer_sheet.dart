import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../../core/navigation/goman_navigation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/quran_tafseer_api.dart';
import '../../data/quran_tafseer_books.dart';
import '../providers/quran_ayah_tafseer_provider.dart';
import '../providers/quran_tafseer_book_provider.dart';
import '../providers/quran_tafseer_repository_provider.dart';
import 'quran_tafseer_book_chips.dart';
import 'quran_tafseer_scroll_content.dart';

Future<void> showQuranAyahTafseerSheet(
  BuildContext context, {
  required int surahNumber,
  required int verseNumber,
}) {
  return showGomanModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return _QuranAyahTafseerSheet(
        surahNumber: surahNumber,
        verseNumber: verseNumber,
      );
    },
  );
}

class _QuranAyahTafseerSheet extends ConsumerWidget {
  const _QuranAyahTafseerSheet({
    required this.surahNumber,
    required this.verseNumber,
  });

  final int surahNumber;
  final int verseNumber;

  AyahTafseerRequest _request(TafseerBook book) {
    return AyahTafseerRequest(
      surahNumber: surahNumber,
      verseNumber: verseNumber,
      bookSlug: book.slug,
    );
  }

  void _selectBook(WidgetRef ref, TafseerBook book) {
    ref.read(quranTafseerBookProvider.notifier).select(book);
  }

  Future<void> _refresh(WidgetRef ref, AyahTafseerRequest request) async {
    final repository = ref.read(quranTafseerRepositoryProvider);
    try {
      await repository.getAyahTafseer(
        surahNumber: request.surahNumber,
        verseNumber: request.verseNumber,
        tafsirSlug: request.bookSlug,
        forceRefresh: true,
      );
    } finally {
      ref.invalidate(ayahTafseerProvider(request));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedBook = ref.watch(quranTafseerBookProvider);
    final request = _request(selectedBook);
    final tafseerAsync = ref.watch(ayahTafseerProvider(request));
    final repository = ref.read(quranTafseerRepositoryProvider);
    final cachedForBook = repository.peekCached(
      surahNumber: surahNumber,
      verseNumber: verseNumber,
      tafsirSlug: selectedBook.slug,
    );
    final visibleTafseer = _resolveVisibleTafseer(
      tafseerAsync: tafseerAsync,
      cachedForBook: cachedForBook,
      selectedBookSlug: selectedBook.slug,
    );

    final surahName = getSurahNameArabic(surahNumber);
    final ayahText = getVerse(surahNumber, verseNumber);
    final ayahLabel =
        '${convertToArabicNumber('$surahNumber')}:${convertToArabicNumber('$verseNumber')}';

    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      minChildSize: 0.45,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: isDark ? 0.18 : 0.08),
            ),
            boxShadow: AppColors.cardShadow(isDark: isDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'تفسير الآية',
                            style: GoogleFonts.notoNaskhArabic(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: visibleTafseer != null
                              ? IconButton(
                                  tooltip: 'تحديث التفسير',
                                  onPressed: () => _refresh(ref, request),
                                  icon: Icon(
                                    Icons.refresh_rounded,
                                    size: 20,
                                    color: AppColors.secondary
                                        .withValues(alpha: 0.8),
                                  ),
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                )
                              : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$surahName · $ayahLabel',
                      style: GoogleFonts.notoNaskhArabic(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.surfaceLight
                            : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      ayahText,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoNaskhArabic(
                        fontSize: 22,
                        height: 1.9,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.surfaceLight.withValues(alpha: 0.95)
                            : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              QuranTafseerBookChips(
                books: quranArabicTafseerBooks,
                selectedSlug: selectedBook.slug,
                isDark: isDark,
                onSelected: (book) => _selectBook(ref, book),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _TafseerBody(
                  scrollController: scrollController,
                  isDark: isDark,
                  tafseerAsync: tafseerAsync,
                  visibleTafseer: visibleTafseer,
                  onRetry: () => _refresh(ref, request),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

AyahTafseer? _resolveVisibleTafseer({
  required AsyncValue<AyahTafseer> tafseerAsync,
  required AyahTafseer? cachedForBook,
  required String selectedBookSlug,
}) {
  final data = tafseerAsync.valueOrNull;
  if (data != null && data.bookSlug == selectedBookSlug) return data;
  if (cachedForBook != null && cachedForBook.bookSlug == selectedBookSlug) {
    return cachedForBook;
  }
  return null;
}

class _TafseerBody extends StatelessWidget {
  const _TafseerBody({
    required this.scrollController,
    required this.isDark,
    required this.tafseerAsync,
    required this.visibleTafseer,
    required this.onRetry,
  });

  final ScrollController scrollController;
  final bool isDark;
  final AsyncValue<AyahTafseer> tafseerAsync;
  final AyahTafseer? visibleTafseer;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (tafseerAsync.hasError && visibleTafseer == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tafseerAsync.error is QuranTafseerException
                    ? tafseerAsync.error.toString()
                    : 'تعذّر تحميل التفسير. تحقق من الاتصال بالإنترنت.',
                textAlign: TextAlign.center,
                style: GoogleFonts.notoNaskhArabic(
                  fontSize: 15,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(
                  'إعادة المحاولة',
                  style: GoogleFonts.notoNaskhArabic(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final isLoading =
        visibleTafseer == null && tafseerAsync.isLoading;

    return QuranTafseerScrollContent(
      tafseer: visibleTafseer,
      isLoading: isLoading,
      isDark: isDark,
      scrollController: scrollController,
    );
  }
}
