import 'package:flutter/material.dart';

import '../../data/models/ayah_highlight.dart';

abstract final class AyahHighlightColors {
  static Color mushaf(AyahHighlightColor color, {required bool isDark}) {
    return switch (color) {
      AyahHighlightColor.yellow => const Color(0xFFFFD54F)
          .withValues(alpha: isDark ? 0.36 : 0.44),
      AyahHighlightColor.red => const Color(0xFFEF5350)
          .withValues(alpha: isDark ? 0.34 : 0.3),
      AyahHighlightColor.green => const Color(0xFF66BB6A)
          .withValues(alpha: isDark ? 0.36 : 0.32),
    };
  }

  static Color chip(AyahHighlightColor color) {
    return switch (color) {
      AyahHighlightColor.yellow => const Color(0xFFFFCA28),
      AyahHighlightColor.red => const Color(0xFFE53935),
      AyahHighlightColor.green => const Color(0xFF43A047),
    };
  }

  static String label(AyahHighlightColor color) {
    return switch (color) {
      AyahHighlightColor.yellow => 'أصفر',
      AyahHighlightColor.red => 'أحمر',
      AyahHighlightColor.green => 'أخضر',
    };
  }
}
