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

  static List<Color> swatchGradient(AyahHighlightColor color) {
    return switch (color) {
      AyahHighlightColor.yellow => const [
          Color(0xFFFFE082),
          Color(0xFFFFCA28),
          Color(0xFFFFB300),
        ],
      AyahHighlightColor.red => const [
          Color(0xFFEF9A9A),
          Color(0xFFE53935),
          Color(0xFFC62828),
        ],
      AyahHighlightColor.green => const [
          Color(0xFFA5D6A7),
          Color(0xFF43A047),
          Color(0xFF2E7D32),
        ],
    };
  }

  static List<Color> surfaceGradient(
    AyahHighlightColor color, {
    required bool isDark,
    required bool selected,
  }) {
    if (selected) {
      return switch (color) {
        AyahHighlightColor.yellow => isDark
            ? const [Color(0xFF4A3D12), Color(0xFF3A2F0C)]
            : const [Color(0xFFFFF8E1), Color(0xFFFFECB3)],
        AyahHighlightColor.red => isDark
            ? const [Color(0xFF4A1716), Color(0xFF3A1211)]
            : const [Color(0xFFFFEBEE), Color(0xFFFFCDD2)],
        AyahHighlightColor.green => isDark
            ? const [Color(0xFF16361A), Color(0xFF102A14)]
            : const [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
      };
    }

    return isDark
        ? const [Color(0xFF1E1E22), Color(0xFF18181C)]
        : const [Color(0xFFFAFAFA), Color(0xFFF3F3F5)];
  }

  static Color labelOnSurface(
    AyahHighlightColor color, {
    required bool isDark,
    required bool selected,
  }) {
    if (!selected) {
      return isDark ? const Color(0xFFF5F5F5) : const Color(0xFF1A1A1A);
    }

    return switch (color) {
      AyahHighlightColor.yellow =>
        isDark ? const Color(0xFFFFE082) : const Color(0xFF8D6E00),
      AyahHighlightColor.red =>
        isDark ? const Color(0xFFEF9A9A) : const Color(0xFFB71C1C),
      AyahHighlightColor.green =>
        isDark ? const Color(0xFFA5D6A7) : const Color(0xFF1B5E20),
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
