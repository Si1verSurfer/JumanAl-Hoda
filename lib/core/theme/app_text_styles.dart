import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static TextTheme textTheme({required bool isDark}) {
    final base = GoogleFonts.notoNaskhArabicTextTheme();
    final onSurface = isDark ? AppColors.surfaceLight : AppColors.onSurfaceLight;

    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        color: onSurface,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: base.displayMedium?.copyWith(
        color: onSurface,
        fontWeight: FontWeight.w700,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        color: onSurface,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        color: onSurface,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: base.titleLarge?.copyWith(
        color: onSurface,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: base.titleMedium?.copyWith(
        color: onSurface,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: base.bodyLarge?.copyWith(color: onSurface),
      bodyMedium: base.bodyMedium?.copyWith(color: onSurface),
      bodySmall: base.bodySmall?.copyWith(
        color: onSurface.withValues(alpha: 0.7),
      ),
      labelLarge: base.labelLarge?.copyWith(
        color: onSurface,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static TextStyle navLabel({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? letterSpacing,
  }) {
    return GoogleFonts.notoNaskhArabic(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: 1.1,
      color: color,
      letterSpacing: letterSpacing,
    );
  }
}
