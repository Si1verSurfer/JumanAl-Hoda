import 'package:flutter/material.dart';

import '../../../../core/constants/app_nav_constants.dart';

/// Keeps every branch navigator mounted and replays a polished enter transition
/// whenever [currentIndex] changes.
class AnimatedBranchContainer extends StatefulWidget {
  const AnimatedBranchContainer({
    super.key,
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;
  final List<Widget> children;

  @override
  State<AnimatedBranchContainer> createState() => _AnimatedBranchContainerState();
}

class _AnimatedBranchContainerState extends State<AnimatedBranchContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppNavConstants.pageTransitionDuration,
    );
    _bindAnimations(fromIndex: widget.currentIndex, toIndex: widget.currentIndex);
    _controller.value = 1;
  }

  @override
  void didUpdateWidget(AnimatedBranchContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _bindAnimations(
        fromIndex: oldWidget.currentIndex,
        toIndex: widget.currentIndex,
      );
      _controller.forward(from: 0);
    }
  }

  void _bindAnimations({required int fromIndex, required int toIndex}) {
    final curve = CurvedAnimation(
      parent: _controller,
      curve: AppNavConstants.pageTransitionCurve,
      reverseCurve: AppNavConstants.pageTransitionCurve,
    );

    _fade = Tween<double>(
      begin: AppNavConstants.pageTransitionFadeBegin,
      end: 1.0,
    ).animate(curve);
    _scale = Tween<double>(
      begin: AppNavConstants.pageTransitionScaleBegin,
      end: 1.0,
    ).animate(curve);
    _slide = Tween<Offset>(
      begin: _slideBegin(fromIndex: fromIndex, toIndex: toIndex),
      end: Offset.zero,
    ).animate(curve);
  }

  Offset _slideBegin({required int fromIndex, required int toIndex}) {
    final delta = toIndex - fromIndex;
    if (delta == 0) {
      return Offset.zero;
    }
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final direction = (isRtl ? -delta.sign : delta.sign).toDouble();
    return Offset(
      AppNavConstants.pageTransitionSlideDistance * direction,
      AppNavConstants.pageTransitionVerticalSlide,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        alignment: Alignment.center,
        child: SlideTransition(
          position: _slide,
          child: IndexedStack(
            index: widget.currentIndex,
            sizing: StackFit.expand,
            children: [
              for (var index = 0; index < widget.children.length; index++)
                TickerMode(
                  enabled: index == widget.currentIndex,
                  child: widget.children[index],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
