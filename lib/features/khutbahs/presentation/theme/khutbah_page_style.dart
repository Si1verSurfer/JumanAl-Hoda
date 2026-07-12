import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

abstract final class KhutbahPageStyle {
  /// Soft layered shadow — rendered on an outer wrapper so it is not clipped.
  static List<BoxShadow> floatShadow({required bool isDark}) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.38 : 0.07),
          blurRadius: 28,
          spreadRadius: -6,
          offset: const Offset(0, 12),
        ),
        BoxShadow(
          color: AppColors.secondary.withValues(alpha: isDark ? 0.14 : 0.05),
          blurRadius: 10,
          spreadRadius: 0,
          offset: const Offset(0, 3),
        ),
      ];

  static Border border({required bool isDark, double alphaLight = 0.07}) =>
      Border.all(
        color: AppColors.primary.withValues(alpha: isDark ? 0.14 : alphaLight),
      );
}
