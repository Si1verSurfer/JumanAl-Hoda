import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/app_nav_constants.dart';
import '../theme/app_colors.dart';

/// Frosted capsule that slides behind the active tab.
class GlassSelectionPill extends StatelessWidget {
  const GlassSelectionPill({
    super.key,
    required this.width,
    required this.height,
    required this.isDark,
    this.frosted = true,
  });

  final double width;
  final double height;
  final bool isDark;
  final bool frosted;

  @override
  Widget build(BuildContext context) {
    final radius = height / 2;

    if (!frosted) {
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.secondary.withValues(alpha: 0.16),
              AppColors.secondary.withValues(alpha: 0.08),
            ],
          ),
          border: Border.all(
            color: AppColors.secondary.withValues(alpha: 0.20),
            width: 0.65,
          ),
        ),
        child: SizedBox(width: width, height: height),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                isDark
                    ? Colors.white.withValues(alpha: 0.34)
                    : AppColors.glassLight.withValues(alpha: 0.96),
                isDark
                    ? Colors.white.withValues(alpha: 0.12)
                    : Color.lerp(
                          AppColors.glassLight,
                          AppColors.secondary,
                          0.06,
                        )!
                        .withValues(alpha: 0.62),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: isDark ? 0.42 : 0.82),
              width: 0.9,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: height * 0.48,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(radius),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: isDark ? 0.22 : 0.38),
                        Colors.white.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: width, height: height),
            ],
          ),
        ),
      ),
    );
  }
}

/// Slides the glass pill smoothly between tabs.
class AnimatedGlassSelection extends StatefulWidget {
  const AnimatedGlassSelection({
    super.key,
    required this.currentIndex,
    required this.itemCount,
    required this.itemWidth,
    required this.inset,
    required this.top,
    required this.pillWidth,
    required this.pillHeight,
    required this.isDark,
    required this.frosted,
  });

  final int currentIndex;
  final int itemCount;
  final double itemWidth;
  final double inset;
  final double top;
  final double pillWidth;
  final double pillHeight;
  final bool isDark;
  final bool frosted;

  @override
  State<AnimatedGlassSelection> createState() => _AnimatedGlassSelectionState();
}

class _AnimatedGlassSelectionState extends State<AnimatedGlassSelection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _position;

  double _fromStart = 0;
  double _toStart = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppNavConstants.selectionDuration,
    );
    _toStart = _startForIndex(widget.currentIndex);
    _fromStart = _toStart;
    _bindAnimations();
    _controller.value = 1;
  }

  @override
  void didUpdateWidget(AnimatedGlassSelection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex ||
        widget.itemWidth != oldWidget.itemWidth) {
      _fromStart = _position.value;
      _toStart = _startForIndex(widget.currentIndex);
      _bindAnimations();
      _controller.forward(from: 0);
    }
  }

  double _startForIndex(int index) => index * widget.itemWidth + widget.inset;

  void _bindAnimations() {
    final curve = CurvedAnimation(
      parent: _controller,
      curve: AppNavConstants.selectionCurve,
    );
    _position = Tween<double>(begin: _fromStart, end: _toStart).animate(curve);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return PositionedDirectional(
          start: _position.value,
          top: widget.top,
          width: widget.pillWidth,
          height: widget.pillHeight,
          child: child!,
        );
      },
      child: GlassSelectionPill(
        width: widget.pillWidth,
        height: widget.pillHeight,
        isDark: widget.isDark,
        frosted: widget.frosted,
      ),
    );
  }
}
