import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract final class GomanMotion {
  static const pageDuration = Duration(milliseconds: 340);
  static const pageReverseDuration = Duration(milliseconds: 280);
  static const sheetDuration = Duration(milliseconds: 380);
  static const curve = Curves.easeOutCubic;
  static const reverseCurve = Curves.easeInCubic;
}

abstract final class GomanPageTransitions {
  static CustomTransitionPage<T> push<T>({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      transitionDuration: GomanMotion.pageDuration,
      reverseTransitionDuration: GomanMotion.pageReverseDuration,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: GomanMotion.curve,
          reverseCurve: GomanMotion.reverseCurve,
        );
        final isRtl = Directionality.of(context) == TextDirection.rtl;
        final horizontalOffset = isRtl ? -0.04 : 0.04;

        return FadeTransition(
          opacity: Tween<double>(begin: 0.92, end: 1).animate(curved),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(horizontalOffset, 0.035),
              end: Offset.zero,
            ).animate(curved),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.98, end: 1).animate(curved),
              alignment: Alignment.center,
              child: child,
            ),
          ),
        );
      },
    );
  }

  static CustomTransitionPage<T> reader<T>({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      transitionDuration: GomanMotion.pageDuration,
      reverseTransitionDuration: GomanMotion.pageReverseDuration,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: GomanMotion.curve,
          reverseCurve: GomanMotion.reverseCurve,
        );

        return FadeTransition(
          opacity: Tween<double>(begin: 0.9, end: 1).animate(curved),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
