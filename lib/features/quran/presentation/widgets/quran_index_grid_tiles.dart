import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../../core/haptics/goman_haptics.dart';
import '../../../../core/theme/app_colors.dart';
import '../utils/quran_place_label.dart';

abstract final class QuranSurahGridTileStyle {
  static const double surahGlyphSize = 32;
  static const double appBarSurahGlyphSize = 26;

  static TextStyle surahGlyph(Color color) => TextStyle(
        fontFamily: SurahFontHelper.fontFamily,
        package: 'qcf_quran',
        fontSize: surahGlyphSize,
        height: 1.05,
        color: color,
      );

  static TextStyle appBarSurahGlyph(Color color) => surahGlyph(color).copyWith(
        fontSize: appBarSurahGlyphSize,
      );

  static TextStyle meta(Color color) => GoogleFonts.tajawal(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: color.withValues(alpha: 0.55),
      );
}

class QuranSurahGridTile extends StatelessWidget {
  const QuranSurahGridTile({
    super.key,
    required this.surahNumber,
    required this.isDark,
    required this.onTap,
    this.badgeOnRight = true,
  });

  final int surahNumber;
  final bool isDark;
  final VoidCallback onTap;
  final bool badgeOnRight;

  @override
  Widget build(BuildContext context) {
    final place = quranPlaceLabelArabic(getPlaceOfRevelation(surahNumber));
    final verseCount = getVerseCount(surahNumber);
    final titleColor = isDark ? AppColors.surfaceLight : AppColors.primary;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow(isDark: isDark),
      ),
      child: Material(
        color: AppColors.cardSurface(isDark),
        elevation: 0,
        shadowColor: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap.withHaptic(),
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 14, 12, 36),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: SurahFontHelper.surahNameSpan(
                        surahNumber,
                        style: QuranSurahGridTileStyle.surahGlyph(titleColor),
                        package: 'qcf_quran',
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      place,
                      textAlign: TextAlign.center,
                      style: QuranSurahGridTileStyle.meta(titleColor),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'آياتها: ${convertToArabicNumber('$verseCount')}',
                      textAlign: TextAlign.center,
                      style: QuranSurahGridTileStyle.meta(titleColor),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: badgeOnRight ? 8 : null,
                left: badgeOnRight ? null : 8,
                child: _IndexBadge(
                  label: convertToArabicNumber('$surahNumber'),
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IndexBadge extends StatelessWidget {
  const _IndexBadge({
    required this.label,
    required this.isDark,
  });

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: isDark ? 0.35 : 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.tajawal(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}
