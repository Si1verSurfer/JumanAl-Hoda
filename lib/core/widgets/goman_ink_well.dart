import 'package:flutter/material.dart';

import '../haptics/goman_haptics.dart';

/// Tappable surface with light scale animation and haptic feedback.
class GomanInkWell extends StatefulWidget {
  const GomanInkWell({
    super.key,
    required this.onTap,
    required this.child,
    this.borderRadius,
    this.haptic = GomanHapticKind.confirm,
    this.enableScale = true,
  });

  final VoidCallback? onTap;
  final Widget child;
  final BorderRadius? borderRadius;
  final GomanHapticKind haptic;
  final bool enableScale;

  @override
  State<GomanInkWell> createState() => _GomanInkWellState();
}

class _GomanInkWellState extends State<GomanInkWell> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (!widget.enableScale || widget.onTap == null) return;
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.enableScale
        ? AnimatedScale(
            scale: _pressed ? 0.975 : 1,
            duration: const Duration(milliseconds: 110),
            curve: Curves.easeOutCubic,
            child: widget.child,
          )
        : widget.child;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: widget.borderRadius,
        onHighlightChanged: _setPressed,
        onTap: widget.onTap == null
            ? null
            : () {
                widget.haptic.fire();
                widget.onTap!();
              },
        child: child,
      ),
    );
  }
}
