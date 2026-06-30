import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/quran_tafseer_api.dart';
import '../utils/quran_place_label.dart';

Future<void> showQuranAyahTafseerSheet(
  BuildContext context, {
  required int surahNumber,
  required int verseNumber,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final surahName = getSurahNameArabic(surahNumber);
  final ayahText = getVerse(surahNumber, verseNumber);
  final ayahLabel =
      '${convertToArabicNumber('$surahNumber')}:${convertToArabicNumber('$verseNumber')}';

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return DraggableScrollableSheet(
        initialChildSize: 0.72,
        minChildSize: 0.42,
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
                      Text(
                        'تفسير الآية',
                        style: GoogleFonts.notoNaskhArabic(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
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
                const SizedBox(height: 16),
                Expanded(
                  child: FutureBuilder<AyahTafseer>(
                    future: QuranTafseerApi.fetchAyahTafseer(
                      surahNumber: surahNumber,
                      verseNumber: verseNumber,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.secondary,
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              snapshot.error.toString(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.notoNaskhArabic(
                                fontSize: 15,
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                        );
                      }

                      final tafseer = snapshot.data!;

                      return SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tafseer.resourceName,
                              style: GoogleFonts.notoNaskhArabic(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondary.withValues(alpha: 0.85),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              tafseer.text,
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.notoNaskhArabic(
                                fontSize: 16,
                                height: 1.85,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? AppColors.surfaceLight
                                        .withValues(alpha: 0.92)
                                    : AppColors.primary.withValues(alpha: 0.88),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Future<void> showQuranTafseerSheet(
  BuildContext context, {
  required int surahNumber,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final name = getSurahNameArabic(surahNumber);
  final place = quranPlaceLabelArabic(getPlaceOfRevelation(surahNumber));
  final verses = getVerseCount(surahNumber);
  final info = getSurahInfo(surahNumber);
  final source = getSurahInfoSource(surahNumber);

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
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
                      Text(
                        'التفسير',
                        style: GoogleFonts.notoNaskhArabic(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        name,
                        style: GoogleFonts.notoNaskhArabic(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.surfaceLight
                              : AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$place · $verses آية',
                        style: GoogleFonts.notoNaskhArabic(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: (isDark
                                  ? AppColors.surfaceLight
                                  : AppColors.primary)
                              .withValues(alpha: 0.58),
                        ),
                      ),
                      if (source.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          source,
                          style: GoogleFonts.notoNaskhArabic(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondary.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                    child: Text(
                      info.isNotEmpty
                          ? info
                          : 'لا يتوفر تفسير لهذه السورة حالياً.',
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.notoNaskhArabic(
                        fontSize: 16,
                        height: 1.85,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.surfaceLight.withValues(alpha: 0.92)
                            : AppColors.primary.withValues(alpha: 0.88),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
