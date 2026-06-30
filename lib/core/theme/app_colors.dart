import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color primary = Color(0xFF2C0F12);
  static const Color secondary = Color(0xFF6B1E23);
  /// Main app background in light mode — near white.
  static const Color surfaceLight = Color(0xFFFFFEFE);
  /// Cards, tiles, and elevated surfaces on the light background.
  static const Color surfaceElevatedLight = Color(0xFFFAFAFA);
  /// Cream paper tone for mushaf pages and ayah cards.
  static const Color mushafPaper = Color(0xFFFBF2E1);
  static const Color surfaceDark = Color(0xFF231919);
  static const Color surfaceDarkElevated = Color(0xFF2E2222);
  /// Frosted nav glass — clean white, separate from [surfaceLight].
  static const Color glassLight = Color(0xFFFFFFFF);
  static const Color onPrimary = mushafPaper;
  static const Color onSurfaceLight = primary;

  static const LinearGradient primaryBrandGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [primary, secondary],
  );

  static List<BoxShadow> cardShadow({bool isDark = false}) => [
        BoxShadow(
          color: primary.withValues(alpha: isDark ? 0.2 : 0.11),
          blurRadius: 22,
          spreadRadius: 0,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: primary.withValues(alpha: isDark ? 0.1 : 0.05),
          blurRadius: 8,
          spreadRadius: 0,
          offset: const Offset(0, 2),
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
