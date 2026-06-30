import 'package:flutter/material.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../../core/theme/app_colors.dart';

abstract final class QuranQcfTheme {
  /// App colors only — all layout/spacing values stay at package defaults.
  static QcfThemeData forBrightness(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return QcfThemeData.dark().copyWith(
        verseTextColor: AppColors.surfaceLight,
        verseNumberColor: const Color(0xFFD4848A),
        basmalaColor: AppColors.surfaceLight.withValues(alpha: 0.92),
        headerTextColor: AppColors.secondary,
        pageBackgroundColor: AppColors.surfaceDark,
      );
    }

    return const QcfThemeData().copyWith(
      verseTextColor: AppColors.primary,
      verseNumberColor: AppColors.secondary,
      basmalaColor: AppColors.primary,
      headerTextColor: AppColors.secondary,
      pageBackgroundColor: AppColors.surfaceLight,
    );
  }
}
