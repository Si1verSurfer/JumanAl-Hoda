import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AnimatedEntrance extends HookConsumerWidget {
  const AnimatedEntrance({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration delay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );
    final animation = useMemoized(
      () => CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
      [controller],
    );

    useEffect(() {
      var cancelled = false;

      void start() {
        if (cancelled) return;
        controller.forward();
      }

      Timer? timer;
      if (delay == Duration.zero) {
        WidgetsBinding.instance.addPostFrameCallback((_) => start());
      } else {
        timer = Timer(delay, start);
      }

      return () {
        cancelled = true;
        timer?.cancel();
      };
    }, [controller, delay]);

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}
