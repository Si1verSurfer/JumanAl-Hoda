import 'package:flutter/material.dart';

enum QuranMushafTheme {
  classic,
  sage,
  sky,
  dusk,
  rose,
  indigo,
  cream,
  kaaba,
}

class QuranMushafThemeSpec {
  const QuranMushafThemeSpec({
    required this.id,
    required this.label,
    required this.pageBackground,
    required this.verseText,
    required this.verseNumber,
    required this.basmala,
    required this.headerText,
    required this.headerFrame,
    required this.swatch,
  });

  final QuranMushafTheme id;
  final String label;
  final Color pageBackground;
  final Color verseText;
  final Color verseNumber;
  final Color basmala;
  final Color headerText;
  final Color headerFrame;
  final Color swatch;

  bool get isDarkBackground => pageBackground.computeLuminance() < 0.45;
}

abstract final class QuranMushafThemes {
  static const classic = QuranMushafThemeSpec(
    id: QuranMushafTheme.classic,
    label: 'كلاسيكي',
    pageBackground: Color(0xFFFBF2E1),
    verseText: Color(0xFF2C0F12),
    verseNumber: Color(0xFF6B1E23),
    basmala: Color(0xFF2C0F12),
    headerText: Color(0xFF6B1E23),
    headerFrame: Color(0xFF9A6B52),
    swatch: Color(0xFFE8D5B0),
  );

  static const sage = QuranMushafThemeSpec(
    id: QuranMushafTheme.sage,
    label: 'زيتوني',
    pageBackground: Color(0xFFF0F5EE),
    verseText: Color(0xFF1A2E24),
    verseNumber: Color(0xFF4F8A66),
    basmala: Color(0xFF1F3D2E),
    headerText: Color(0xFF3D7358),
    headerFrame: Color(0xFF5E8F72),
    swatch: Color(0xFF8FB89A),
  );

  static const sky = QuranMushafThemeSpec(
    id: QuranMushafTheme.sky,
    label: 'سماوي',
    pageBackground: Color(0xFFF3F8FC),
    verseText: Color(0xFF132838),
    verseNumber: Color(0xFF3A7DA6),
    basmala: Color(0xFF1A3347),
    headerText: Color(0xFF2B6F96),
    headerFrame: Color(0xFF4F86A8),
    swatch: Color(0xFF8EC5E8),
  );

  static const dusk = QuranMushafThemeSpec(
    id: QuranMushafTheme.dusk,
    label: 'ليلي',
    pageBackground: Color(0xFF12161D),
    verseText: Color(0xFFE9EDF4),
    verseNumber: Color(0xFFD4A96A),
    basmala: Color(0xFFDCE2EC),
    headerText: Color(0xFFC9A56A),
    headerFrame: Color(0xFFC9A56A),
    swatch: Color(0xFF2A3340),
  );

  static const rose = QuranMushafThemeSpec(
    id: QuranMushafTheme.rose,
    label: 'وردي',
    pageBackground: Color(0xFFFFF6F4),
    verseText: Color(0xFF2A1520),
    verseNumber: Color(0xFFB8456B),
    basmala: Color(0xFF3A1F2C),
    headerText: Color(0xFFA63D5C),
    headerFrame: Color(0xFFC45A78),
    swatch: Color(0xFFE8A4B8),
  );

  static const indigo = QuranMushafThemeSpec(
    id: QuranMushafTheme.indigo,
    label: 'نيلي',
    pageBackground: Color(0xFFF5F4FC),
    verseText: Color(0xFF18152B),
    verseNumber: Color(0xFF5C4FD6),
    basmala: Color(0xFF211E38),
    headerText: Color(0xFF4A3FB8),
    headerFrame: Color(0xFF6B5FD4),
    swatch: Color(0xFFA89CE8),
  );

  static const cream = QuranMushafThemeSpec(
    id: QuranMushafTheme.cream,
    label: 'جمان',
    pageBackground: Color(0xFFFAF0E6),
    verseText: Color(0xFF3A0E14),
    verseNumber: Color(0xFF9A5B4E),
    basmala: Color(0xFF4D1820),
    headerText: Color(0xFF4D1820),
    headerFrame: Color(0xFFB8896A),
    swatch: Color(0xFFE2C9A8),
  );

  static const kaaba = QuranMushafThemeSpec(
    id: QuranMushafTheme.kaaba,
    label: 'كعبي',
    pageBackground: Color(0xFF0A0808),
    verseText: Color(0xFFF2E4C4),
    verseNumber: Color(0xFFD4AF37),
    basmala: Color(0xFFE8D5A8),
    headerText: Color(0xFFC9A227),
    headerFrame: Color(0xFFB8860B),
    swatch: Color(0xFF3D3220),
  );

  static QuranMushafThemeSpec specFor(QuranMushafTheme theme) {
    return switch (theme) {
      QuranMushafTheme.classic => classic,
      QuranMushafTheme.sage => sage,
      QuranMushafTheme.sky => sky,
      QuranMushafTheme.dusk => dusk,
      QuranMushafTheme.rose => rose,
      QuranMushafTheme.indigo => indigo,
      QuranMushafTheme.cream => cream,
      QuranMushafTheme.kaaba => kaaba,
    };
  }

  static const selectable = [
    classic,
    sage,
    sky,
    dusk,
    rose,
    indigo,
    cream,
    kaaba,
  ];
}
