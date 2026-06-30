import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class GomanCard extends StatelessWidget {
  const GomanCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.width,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDarkElevated : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow(isDark: isDark),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.06),
        ),
      ),
      child: child,
    );
  }
}
