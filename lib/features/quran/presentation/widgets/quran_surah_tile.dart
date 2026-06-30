import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../../core/haptics/goman_haptics.dart';
import '../../../../core/theme/app_colors.dart';
import '../utils/quran_place_label.dart';
import 'quran_rtl_icons.dart';

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
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap.withHaptic(),
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceDarkElevated
                  : AppColors.surfaceElevatedLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(
                  alpha: isDark ? 0.12 : 0.05,
                ),
              ),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  _SurahNumberBadge(number: surahNumber),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nameArabic,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.notoNaskhArabic(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                            color: isDark
                                ? AppColors.surfaceLight
                                : AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '$place · ${convertToArabicNumber('$verseCount')} آية',
                          style: GoogleFonts.tajawal(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: (isDark
                                    ? AppColors.surfaceLight
                                    : AppColors.primary)
                                .withValues(alpha: 0.52),
                          ),
                        ),
                      ],
                    ),
                  ),
                  QuranRtlIcons.forwardIcon(size: 15, opacity: 0.65),
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
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.secondary.withValues(alpha: 0.2),
            AppColors.secondary.withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.22),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        convertToArabicNumber('$number'),
        style: GoogleFonts.tajawal(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}

class QuranSurahListHeader extends StatelessWidget {
  const QuranSurahListHeader({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 22,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'فهرس السور',
            style: GoogleFonts.notoNaskhArabic(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.surfaceLight : AppColors.primary,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: 0.16),
              ),
            ),
            child: Text(
              '${convertToArabicNumber('$totalSurahCount')} سورة',
              style: GoogleFonts.tajawal(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
