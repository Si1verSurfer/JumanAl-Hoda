import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../../core/theme/app_colors.dart';
import '../constants/quran_app_assets.dart';
import '../../data/models/quran_mushaf_theme.dart';
import '../theme/quran_qcf_theme.dart';

/// Mushaf-style ayah card using QCF page fonts — same rendering as the reader.
class QuranAyahCardPreview extends StatelessWidget {
  const QuranAyahCardPreview({
    super.key,
    required this.surahNumber,
    required this.verseNumbers,
    this.width = 300,
    this.contentPadding = const EdgeInsets.fromLTRB(18, 6, 18, 14),
  });

  final int surahNumber;
  final List<int> verseNumbers;
  final double width;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    final ayahLabel = verseNumbers
        .map(
          (verse) =>
              '${convertToArabicNumber('$surahNumber')}:${convertToArabicNumber('$verse')}',
        )
        .join('  ·  ');
    final baseTheme = QuranQcfTheme.forMushafTheme(QuranMushafTheme.classic).copyWith(
      verseTextColor: AppColors.primary,
      verseNumberColor: AppColors.secondary,
      pageBackgroundColor: AppColors.mushafPaper,
      headerTextColor: AppColors.secondary,
      headerBackgroundColor: Colors.transparent,
      headerWidthSmall: width * 0.82,
      headerWidthLarge: width * 0.72,
      headerFontSizeSmall: width * 0.062,
      headerFontSizeLarge: width * 0.048,
    );
    final theme = baseTheme.copyWith(
      customHeaderBuilder: (suraNumber) => _AyahCardSurahHeader(
        surahNumber: suraNumber,
        width: width,
        theme: baseTheme,
      ),
    );

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: AppColors.mushafPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.12),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeaderWidget(
              suraNumber: surahNumber,
              theme: theme,
            ),
            Padding(
              padding: contentPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    ayahLabel,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.tajawal(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary.withValues(alpha: 0.45),
                    ),
                  ),
                  const SizedBox(height: 10),
                  for (var i = 0; i < verseNumbers.length; i++) ...[
                    if (i > 0) const SizedBox(height: 10),
                    QcfVerses(
                      surahNumber: surahNumber,
                      firstVerse: verseNumbers[i],
                      lastVerse: verseNumbers[i],
                      theme: theme,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
            const AyahCardBrandingFooter(),
          ],
        ),
      ),
    );
  }
}

class AyahCardBrandingFooter extends StatelessWidget {
  const AyahCardBrandingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 2, 18, 12),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset(
                  QuranAppAssets.logo,
                  width: 16,
                  height: 16,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.mosque_rounded,
                    size: 14,
                    color: AppColors.secondary.withValues(alpha: 0.72),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'جمان الهدى',
                style: GoogleFonts.tajawal(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  color: AppColors.secondary.withValues(alpha: 0.72),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AyahCardSurahHeader extends StatelessWidget {
  const _AyahCardSurahHeader({
    required this.surahNumber,
    required this.width,
    required this.theme,
  });

  final int surahNumber;
  final double width;
  final QcfThemeData theme;

  @override
  Widget build(BuildContext context) {
    final frameWidth = width * 0.8;
    final frameHeight = frameWidth / QcfHeaderFrameImage.aspectRatio;

    return Container(
      width: double.infinity,
      color: theme.headerBackgroundColor,
      padding: const EdgeInsets.only(top: 4, bottom: 2),
      child: Center(
        child: SizedBox(
          width: frameWidth,
          height: frameHeight,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              QcfHeaderFrameImage(
                width: frameWidth,
                theme: theme,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'surah${surahNumber.toString().padLeft(3, '0')}',
                  style: TextStyle(
                    fontFamily: SurahFontHelper.fontFamily,
                    package: 'qcf_quran',
                    fontSize: width * 0.058,
                    color: QcfHeaderFrameImage.surahNameColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
