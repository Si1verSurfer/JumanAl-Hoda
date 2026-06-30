import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/app_nav_constants.dart';
import '../theme/app_colors.dart';

/// Frosted floating shell for the bottom navigation bar.
class FrostedNavShell extends StatelessWidget {
  const FrostedNavShell({
    super.key,
    required this.height,
    required this.radius,
    required this.isDark,
    required this.child,
  });

  final double height;
  final double radius;
  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);
    final borderColor = AppColors.primary.withValues(
      alpha: AppNavConstants.barBorderOpacity,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: AppColors.navBarShadow(isDark: isDark),
        border: Border.all(
          color: borderColor,
          width: AppNavConstants.barBorderWidth,
        ),
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.11)
                  : AppColors.glassLight.withValues(alpha: 0.78),
              borderRadius: borderRadius,
            ),
            child: SizedBox(height: height, child: child),
          ),
        ),
      ),
    );
  }
}
