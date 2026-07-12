import 'package:flutter/widgets.dart';

/// Helper to map surah numbers or "surahXXX" strings to font glyphs.
class SurahFontHelper {
  /// The font family name used for surah names.
  static const String fontFamily = 'surahname';

  static const _ligatureFeatures = [
    FontFeature.enable('liga'),
    FontFeature.enable('clig'),
  ];

  /// OpenType ligature code for [surahNumber] (e.g. `surah001`).
  static String ligatureFor(int surahNumber) {
    if (surahNumber < 1 || surahNumber > 114) return '';
    return 'surah${surahNumber.toString().padLeft(3, '0')}';
  }

  static TextStyle _surahNameStyle(TextStyle? style, String? package) {
    return (style ?? const TextStyle()).copyWith(
      fontFamily: fontFamily,
      package: package,
      fontFeatures: _ligatureFeatures,
    );
  }

  /// Builds a [TextSpan] for a single surah decorative name glyph.
  static TextSpan surahNameSpan(
    int surahNumber, {
    TextStyle? style,
    String? package,
  }) {
    final ligature = ligatureFor(surahNumber);
    if (ligature.isEmpty) {
      return TextSpan(text: '', style: style);
    }

    return TextSpan(
      text: ligature,
      style: _surahNameStyle(style, package),
    );
  }

  /// Processes a string to replace "surahXXX" patterns with ligature spans.
  static TextSpan formatSurahText(
    String text, {
    TextStyle? style,
    String? package,
  }) {
    final regExp = RegExp(r'surah(\d{3})');
    final children = <InlineSpan>[];
    var lastMatchEnd = 0;

    for (final match in regExp.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        children.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }

      final surahNumber = int.parse(match.group(1)!);
      children.add(
        TextSpan(
          text: ligatureFor(surahNumber),
          style: _surahNameStyle(style, package),
        ),
      );

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      children.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return TextSpan(children: children, style: style);
  }
}
