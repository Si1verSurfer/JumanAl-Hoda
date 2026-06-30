import 'package:flutter/material.dart';

class GomanNavItem {
  const GomanNavItem({
    this.iconAsset,
    this.icon,
    this.selectedIcon,
    required this.label,
  }) : assert(
          iconAsset != null || (icon != null && selectedIcon != null),
          'Provide iconAsset or both icon and selectedIcon.',
        );

  final String? iconAsset;
  final IconData? icon;
  final IconData? selectedIcon;
  final String label;
}
