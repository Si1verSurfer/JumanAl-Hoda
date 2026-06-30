import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../../core/theme/app_colors.dart';
import '../utils/quran_place_label.dart';

class QuranSurahTile extends StatelessWidget {
  const QuranSurahTile({
    super.key,
    required this.surahNumber,
    required this.onTap,
  });

  final int surahNumber;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nameArabic = getSurahNameArabicWithTashkeel(surahNumber);
    final verseCount = getVerseCount(surahNumber);
    final place = quranPlaceLabelArabic(getPlaceOfRevelation(surahNumber));

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceDarkElevated
                  : AppColors.glassLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(
                  alpha: isDark ? 0.14 : 0.08,
                ),
              ),
              boxShadow: isDark
                  ? null
                  : AppColors.cardShadow(isDark: false),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  _SurahNumberBadge(number: surahNumber),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nameArabic,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.notoNaskhArabic(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                            color: isDark
                                ? AppColors.surfaceLight
                                : AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$place · $verseCount آية',
                          style: GoogleFonts.notoNaskhArabic(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: (isDark
                                    ? AppColors.surfaceLight
                                    : AppColors.primary)
                                .withValues(alpha: 0.55),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.secondary.withValues(alpha: 0.75),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SurahNumberBadge extends StatelessWidget {
  const _SurahNumberBadge({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.secondary.withValues(alpha: 0.22),
            AppColors.secondary.withValues(alpha: 0.10),
          ],
        ),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.28),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: GoogleFonts.notoNaskhArabic(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}
