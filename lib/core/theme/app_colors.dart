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
  /// Lighter chip/card surface in dark mode — stands out from [surfaceDark].
  static const Color surfaceDarkChip = Color(0xFF3D3234);
  /// Frosted nav glass — clean white, separate from [surfaceLight].
  static const Color glassLight = Color(0xFFFFFFFF);
  static const Color onPrimary = mushafPaper;
  static const Color onSurfaceLight = primary;

  /// Elevated card/chip surface — white in light mode, elevated dark in dark mode.
  static Color cardSurface(bool isDark) =>
      isDark ? surfaceDarkElevated : glassLight;

  /// Home worship chips — slightly lighter in dark mode for readability.
  static Color chipSurface(bool isDark, {Color? accent}) {
    if (!isDark) return glassLight;
    if (accent == null) return surfaceDarkChip;
    return Color.alphaBlend(
      accent.withValues(alpha: 0.12),
      surfaceDarkChip,
    );
  }

  /// Accent text on chips — lightened in dark mode.
  static Color accentOnSurface(Color accent, bool isDark) {
    if (!isDark) return accent;
    return Color.lerp(accent, surfaceLight, 0.52)!;
  }

  /// Chip border — visible but soft in dark mode.
  static Color chipBorder(Color accent, bool isDark) =>
      accent.withValues(alpha: isDark ? 0.48 : 0.22);

  /// Home feature cards (tasbih, etc.) — warm in light, lifted tint in dark.
  static List<Color> featureCardGradient(bool isDark, {Color? accent}) {
    final tint = accent ?? secondary;
    if (!isDark) {
      return [mushafPaper, glassLight];
    }
    return [
      Color.alphaBlend(tint.withValues(alpha: 0.16), surfaceDarkChip),
      Color.alphaBlend(tint.withValues(alpha: 0.08), surfaceDarkElevated),
    ];
  }

  static Color featureCardBorder(bool isDark, {Color? accent}) {
    final tint = accent ?? secondary;
    return tint.withValues(alpha: isDark ? 0.44 : 0.18);
  }

  /// Softer card surface (settings, list tiles).
  static Color subtleCardSurface(bool isDark) =>
      isDark ? surfaceDarkElevated : surfaceElevatedLight;

  /// Primary text on [cardSurface] / [subtleCardSurface].
  static Color onCard(bool isDark) =>
      isDark ? surfaceLight.withValues(alpha: 0.94) : onSurfaceLight;

  /// Secondary/muted text on cards.
  static Color mutedOnCard(bool isDark) =>
      onCard(isDark).withValues(alpha: isDark ? 0.72 : 0.55);

  /// Divider color inside cards.
  static Color dividerOnCard(bool isDark) =>
      primary.withValues(alpha: isDark ? 0.14 : 0.06);

  /// Border color for outlined cards and chips.
  static Color borderOnCard(bool isDark, {double alphaLight = 0.22}) =>
      primary.withValues(alpha: isDark ? 0.22 : alphaLight);

  static List<BoxShadow> allahNameCardShadow({bool isDark = false}) =>
      isDark ? adhkarCardShadow(isDark: true) : [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.10),
          blurRadius: 10,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 2,
          spreadRadius: 0,
          offset: const Offset(0, 1),
        ),
      ];

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

  /// Drop shadow for adhkar / worship item cards — primary-tinted.
  static List<BoxShadow> adhkarCardShadow({bool isDark = false}) => [
        BoxShadow(
          color: primary.withValues(alpha: isDark ? 0.26 : 0.14),
          blurRadius: 14,
          spreadRadius: 0,
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: primary.withValues(alpha: isDark ? 0.12 : 0.07),
          blurRadius: 4,
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
