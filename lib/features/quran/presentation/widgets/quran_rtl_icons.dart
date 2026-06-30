import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Forward-pointing navigation chevron for Arabic RTL layouts.
abstract final class QuranRtlIcons {
  static const IconData forward = Icons.arrow_forward_ios_rounded;
  static const IconData chevron = Icons.chevron_right_rounded;

  static Widget forwardIcon({
    double size = 16,
    Color? color,
    double opacity = 0.75,
  }) {
    return Icon(
      forward,
      size: size,
      color: (color ?? AppColors.secondary).withValues(alpha: opacity),
    );
  }
}
