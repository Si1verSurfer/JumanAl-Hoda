import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Mirrors [QuranSurahGridTileStyle] for prayer names (Noto Naskh + tashkeel).
abstract final class PrayerTimeTileStyle {
  static const double tileHeight = 124;
  static const double nameGlyphSize = 32;
  static const double nameGlyphSizeCompact = 26;

  static TextStyle prayerGlyph(Color color) => GoogleFonts.notoNaskhArabic(
        fontSize: nameGlyphSize,
        fontWeight: FontWeight.w700,
        height: 1.05,
        color: color,
      );

  static TextStyle meta(Color color) => GoogleFonts.tajawal(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: color.withValues(alpha: 0.55),
      );

  static TextStyle timeLabel(Color color) => GoogleFonts.tajawal(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        height: 1.2,
        color: color.withValues(alpha: 0.72),
      );
}
