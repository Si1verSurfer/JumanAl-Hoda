import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_nav_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/frosted_nav_shell.dart';
import '../../../../core/widgets/glass_selection_pill.dart';
import '../../../../core/widgets/goman_nav_icon.dart';
import '../models/goman_nav_item.dart';

/// Floating bottom navigation — frosted pill on iOS, solid pill on Android.
class GomanFloatingNavBar extends StatelessWidget {
  const GomanFloatingNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.isDark,
    this.frosted = true,
  });

  final List<GomanNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isDark;
  final bool frosted;

  @override
  Widget build(BuildContext context) {
    final bar = LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth / items.length;
        const inset = 5.0;
        const top = 5.0;
        final pillHeight = AppNavConstants.barHeight - (top * 2);
        final pillWidth = itemWidth - (inset * 2);

        return SizedBox(
          height: AppNavConstants.barHeight,
          child: Stack(
            clipBehavior: Clip.none,
            textDirection: Directionality.of(context),
            children: [
              AnimatedGlassSelection(
                currentIndex: currentIndex,
                itemCount: items.length,
                itemWidth: itemWidth,
                inset: inset,
                top: top,
                pillWidth: pillWidth,
                pillHeight: pillHeight,
                isDark: isDark,
                frosted: frosted,
              ),
              Row(
                children: List.generate(items.length, (index) {
                  return Expanded(
                    child: _NavTab(
                      key: ValueKey<String>(items[index].label),
                      item: items[index],
                      selected: index == currentIndex,
                      isDark: isDark,
                      onTap: () => onTap(index),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );

    if (!frosted) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceDarkElevated
              : AppColors.glassLight,
          borderRadius: BorderRadius.circular(AppNavConstants.barRadius),
          boxShadow: AppColors.navBarShadow(isDark: isDark),
          border: Border.all(
            color: AppColors.primary.withValues(
              alpha: AppNavConstants.barBorderOpacity,
            ),
            width: AppNavConstants.barBorderWidth,
          ),
        ),
        child: bar,
      );
    }

    return FrostedNavShell(
      height: AppNavConstants.barHeight,
      radius: AppNavConstants.barRadius,
      isDark: isDark,
      child: bar,
    );
  }
}

class _NavTab extends StatelessWidget {
  const _NavTab({
    super.key,
    required this.item,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  final GomanNavItem item;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final inactive = isDark
        ? Colors.white.withValues(alpha: 0.48)
        : AppColors.primary.withValues(alpha: 0.38);
    final active = AppColors.secondary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: selected ? 1.0 : 0.0),
        duration: AppNavConstants.selectionDuration,
        curve: AppNavConstants.selectionCurve,
        builder: (context, t, _) {
          final color = Color.lerp(inactive, active, t)!;
          final scale = lerpDouble(1.0, 1.07, t)!;
          final fontSize = lerpDouble(
            AppNavConstants.labelFontSize,
            AppNavConstants.selectedLabelFontSize,
            t,
          )!;
          final weight = FontWeight.lerp(FontWeight.w500, FontWeight.w700, t)!;
          final labelOpacity = lerpDouble(0.78, 1.0, t)!;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: scale,
                  child: GomanNavIcon(
                    item: item,
                    selected: selected,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Opacity(
                  opacity: labelOpacity,
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.navLabel(
                      fontSize: fontSize,
                      fontWeight: weight,
                      color: color,
                      letterSpacing: selected ? 0.15 : 0,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
