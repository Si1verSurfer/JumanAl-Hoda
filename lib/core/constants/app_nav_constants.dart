import 'package:flutter/material.dart';

abstract final class AppNavConstants {
  static const double horizontalMargin = 20;

  /// Space above the physical bottom edge (no safe-area inset).
  static const double bottomMargin = 28;

  static const double barHeight = 68;
  static const double barRadius = 34;
  static const double barBorderOpacity = 0.4;
  static const double barBorderWidth = 1.0;

  static const double iconSize = 21;
  static const double selectedIconSize = 23;
  static const double labelFontSize = 10.5;
  static const double selectedLabelFontSize = 11;

  /// Shared timing — nav pill and page enter stay in sync.
  static const Duration selectionDuration = Duration(milliseconds: 420);
  static const Curve selectionCurve = Cubic(0.33, 1.0, 0.38, 1.0);

  static const Duration pageTransitionDuration = selectionDuration;
  static const Curve pageTransitionCurve = Cubic(0.25, 0.1, 0.25, 1.0);
  static const double pageTransitionSlideDistance = 0.026;
  static const double pageTransitionVerticalSlide = 0.006;
  static const double pageTransitionScaleBegin = 0.978;
  static const double pageTransitionFadeBegin = 0.0;

  static double floatingBottomPadding(BuildContext context) {
    return barHeight + bottomMargin + 12;
  }

  /// Bottom inset for modal sheets above the floating nav bar.
  static double modalSheetBottomInset(BuildContext context) {
    return floatingBottomPadding(context) + MediaQuery.paddingOf(context).bottom;
  }
}
