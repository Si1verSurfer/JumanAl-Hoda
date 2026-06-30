import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

abstract final class PrayerPageStyle {
  static Color background(bool isDark) =>
      isDark ? AppColors.surfaceDark : AppColors.surfaceLight;

  static EdgeInsets pagePadding(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    return EdgeInsets.fromLTRB(20, topInset + 24, 20, 0);
  }
}
