import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';
import '../constants/app_nav_constants.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(isDark: false);

  static ThemeData get dark => _build(isDark: true);

  static ThemeData _build({required bool isDark}) {
    final colorScheme = isDark
        ? const ColorScheme.dark(
            primary: AppColors.primary,
            onPrimary: AppColors.onPrimary,
            secondary: AppColors.secondary,
            onSecondary: AppColors.onPrimary,
            surface: AppColors.surfaceDarkElevated,
            onSurface: AppColors.surfaceLight,
          )
        : const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: AppColors.onPrimary,
            secondary: AppColors.secondary,
            onSecondary: AppColors.onPrimary,
            surface: AppColors.surfaceLight,
            onSurface: AppColors.onSurfaceLight,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor:
          isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      textTheme: AppTextStyles.textTheme(isDark: isDark),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor:
            isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        foregroundColor:
            isDark ? AppColors.surfaceLight : AppColors.onSurfaceLight,
        titleTextStyle: AppTextStyles.textTheme(isDark: isDark).titleLarge,
      ),
      cardTheme: CardThemeData(
        color: isDark ? AppColors.surfaceDarkElevated : AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: AppNavConstants.barHeight,
        backgroundColor:
            isDark ? AppColors.surfaceDarkElevated : AppColors.surfaceLight,
        indicatorColor: AppColors.secondary.withValues(alpha: 0.18),
        labelPadding: const EdgeInsets.only(top: 2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          final color = selected
              ? AppColors.secondary
              : (isDark
                  ? AppColors.surfaceLight.withValues(alpha: 0.7)
                  : AppColors.primary.withValues(alpha: 0.6));
          return AppTextStyles.navLabel(
            fontSize: selected
                ? AppNavConstants.selectedLabelFontSize
                : AppNavConstants.labelFontSize,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: color,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected
                ? AppColors.secondary
                : (isDark
                    ? AppColors.surfaceLight.withValues(alpha: 0.7)
                    : AppColors.primary.withValues(alpha: 0.6)),
            size: selected
                ? AppNavConstants.selectedIconSize
                : AppNavConstants.iconSize,
          );
        }),
      ),
    );
  }
}
