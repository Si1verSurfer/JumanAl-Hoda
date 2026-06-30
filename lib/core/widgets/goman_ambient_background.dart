import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class _OrbData {
  const _OrbData({
    required this.radius,
    required this.centerX,
    required this.centerY,
    required this.orbitRadius,
    required this.color,
  });

  final double radius;
  final double centerX;
  final double centerY;
  final double orbitRadius;
  final Color color;
}

/// Soft warm orbs behind content — gives the nav glass something to refract.
class GomanAmbientBackground extends StatefulWidget {
  const GomanAmbientBackground({super.key, required this.isDark});

  final bool isDark;

  @override
  State<GomanAmbientBackground> createState() => _GomanAmbientBackgroundState();
}

class _GomanAmbientBackgroundState extends State<GomanAmbientBackground>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;
  late final List<_OrbData> _orbs;

  @override
  void initState() {
    super.initState();
    _controllers = [];
    _animations = [];
    _orbs = [];

    final orbColors = widget.isDark
        ? [
            AppColors.secondary.withValues(alpha: 0.22),
            Colors.white.withValues(alpha: 0.08),
            AppColors.primary.withValues(alpha: 0.18),
          ]
        : [
            AppColors.secondary.withValues(alpha: 0.14),
            AppColors.glassLight.withValues(alpha: 0.55),
            AppColors.primary.withValues(alpha: 0.06),
          ];

    for (var i = 0; i < 5; i++) {
      final controller = AnimationController(
        duration: Duration(seconds: 14 + i * 4),
        vsync: this,
      );
      final animation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
        CurvedAnimation(parent: controller, curve: Curves.linear),
      );

      _controllers.add(controller);
      _animations.add(animation);
      _orbs.add(
        _OrbData(
          radius: 48 + (i * 28),
          centerX: 0.15 + (i * 0.17),
          centerY: 0.18 + (i * 0.12),
          orbitRadius: 36 + (i * 22),
          color: orbColors[i % orbColors.length],
        ),
      );
      controller.repeat();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: Listenable.merge(_animations),
        builder: (context, _) {
          return CustomPaint(
            painter: _AmbientOrbsPainter(
              animations: _animations,
              orbs: _orbs,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _AmbientOrbsPainter extends CustomPainter {
  const _AmbientOrbsPainter({
    required this.animations,
    required this.orbs,
  });

  final List<Animation<double>> animations;
  final List<_OrbData> orbs;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28);

    for (var i = 0; i < orbs.length; i++) {
      final orb = orbs[i];
      final centerX = size.width * orb.centerX;
      final centerY = size.height * orb.centerY;
      final x = centerX + orb.orbitRadius * math.cos(animations[i].value);
      final y = centerY + orb.orbitRadius * math.sin(animations[i].value);

      paint.color = orb.color;
      canvas.drawCircle(Offset(x, y), orb.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _AmbientOrbsPainter oldDelegate) => true;
}
