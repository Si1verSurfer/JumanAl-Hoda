import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color primary = Color(0xFF2C0F12);
  static const Color secondary = Color(0xFF6B1E23);
  static const Color surfaceLight = Color(0xFFFBF2E1);
  static const Color surfaceDark = Color(0xFF231919);
  static const Color surfaceDarkElevated = Color(0xFF2E2222);
  /// Frosted nav glass — clean white, separate from cream [surfaceLight].
  static const Color glassLight = Color(0xFFFFFFFF);
  static const Color onPrimary = surfaceLight;
  static const Color onSurfaceLight = primary;

  static List<BoxShadow> cardShadow({bool isDark = false}) => [
        BoxShadow(
          color: primary.withValues(alpha: isDark ? 0.25 : 0.10),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> navBarShadow({bool isDark = false}) => [
        BoxShadow(
          color: primary.withValues(alpha: isDark ? 0.32 : 0.12),
          blurRadius: 28,
          offset: const Offset(0, 10),
        ),
        BoxShadow(
          color: primary.withValues(alpha: isDark ? 0.16 : 0.05),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];
}
