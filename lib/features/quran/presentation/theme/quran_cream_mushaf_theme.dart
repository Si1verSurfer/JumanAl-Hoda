import 'package:flutter/material.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../data/models/quran_mushaf_theme.dart';

/// Premium Kareemi-style mushaf rendering tuned for the جمان theme.
abstract final class QuranCreamMushafTheme {
  static QcfThemeData build(QuranMushafThemeSpec spec) {
    final baseTheme = buildBase(spec);
    return baseTheme.copyWith(
      customHeaderBuilder: (surahNumber) => _CreamSurahHeader(
        surahNumber: surahNumber,
        theme: baseTheme,
      ),
    );
  }

  static QcfThemeData buildBase(QuranMushafThemeSpec spec) {
    return QcfThemeData(
      verseTextColor: spec.verseText,
      verseNumberColor: spec.verseNumber,
      basmalaColor: spec.basmala,
      headerTextColor: spec.headerText,
      pageBackgroundColor: spec.pageBackground,
      headerFrameColor: spec.headerFrame,
      headerFrameCenterColor: spec.pageBackground,
      headerFrameBlendMode: BlendMode.modulate,
      letterSpacing: 0.15,
      wordSpacing: 0.8,
      verseHeight: 2.28,
    );
  }

  /// Warm parchment vignette layered over the reader viewport.
  static const pageAmbiance = BoxDecoration(
    gradient: RadialGradient(
      center: Alignment(0, -0.15),
      radius: 1.35,
      colors: [
        Color(0x00C9A87A),
        Color(0x18B8896A),
        Color(0x28A67B5B),
      ],
      stops: [0.45, 0.82, 1.0],
    ),
  );

  static const topEdgeGlow = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0x33E8D4BC),
        Color(0x00FAF0E6),
      ],
      stops: [0.0, 0.35],
    ),
  );
}

class _CreamSurahHeader extends StatelessWidget {
  const _CreamSurahHeader({
    required this.surahNumber,
    required this.theme,
  });

  final int surahNumber;
  final QcfThemeData theme;

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final frameWidth = isPortrait
        ? getScreenType(context) == ScreenType.large
            ? theme.headerWidthLarge
            : theme.headerWidthSmall
        : MediaQuery.of(context).size.width * 0.8;
    final frameHeight = frameWidth / QcfHeaderFrameImage.aspectRatio;
    final fontSize = isPortrait
        ? getScreenType(context) == ScreenType.large
            ? theme.headerFontSizeLarge
            : theme.headerFontSizeSmall
        : MediaQuery.of(context).size.width * 0.05;

    return SizedBox(
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
            text: SurahFontHelper.surahNameSpan(
              surahNumber,
              style: TextStyle(
                fontSize: fontSize,
                height: 1.0,
                color: theme.headerTextColor,
                shadows: const [
                  Shadow(
                    color: Color(0x22FFFFFF),
                    offset: Offset(0, 0.5),
                    blurRadius: 0,
                  ),
                ],
              ),
              package: 'qcf_quran',
            ),
          ),
        ],
      ),
    );
  }
}
