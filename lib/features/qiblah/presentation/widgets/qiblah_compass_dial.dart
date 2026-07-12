import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../utils/qiblah_bearing.dart';

class QiblahCompassDial extends StatelessWidget {
  const QiblahCompassDial({
    super.key,
    required this.headingDegrees,
    required this.qiblahDegrees,
    required this.isAligned,
    required this.isDark,
  });

  final double? headingDegrees;
  final double qiblahDegrees;
  final bool isAligned;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final heading = headingDegrees ?? 0;
    final qiblahOffset = normalizeDegrees(qiblahDegrees - heading);

    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.maxWidth;
          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: -heading * math.pi / 180,
                child: CustomPaint(
                  size: Size(size, size),
                  painter: _CompassRosePainter(isDark: isDark),
                ),
              ),
              Transform.rotate(
                angle: qiblahOffset * math.pi / 180,
                child: CustomPaint(
                  size: Size(size, size),
                  painter: _QiblahNeedlePainter(isAligned: isAligned),
                ),
              ),
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? AppColors.surfaceLight : AppColors.primary,
                  border: Border.all(
                    color: isAligned
                        ? const Color(0xFF2E7D32)
                        : AppColors.mushafPaper,
                    width: 2,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CompassRosePainter extends CustomPainter {
  const _CompassRosePainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.cardSurface(isDark)
        ..style = PaintingStyle.fill,
    );

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.primary.withValues(alpha: isDark ? 0.22 : 0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final tickPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.35)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 72; i++) {
      final angle = i * 5 * math.pi / 180;
      final isMajor = i % 9 == 0;
      final inner = radius - (isMajor ? 14 : 8);
      canvas.drawLine(
        center + Offset(inner * math.sin(angle), -inner * math.cos(angle)),
        center + Offset(radius * math.sin(angle), -radius * math.cos(angle)),
        tickPaint..strokeWidth = isMajor ? 2 : 1,
      );
    }

    final north = TextPainter(
      text: TextSpan(
        text: 'ش',
        style: GoogleFonts.tajawal(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: AppColors.secondary,
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();

    north.paint(
      canvas,
      center +
          Offset(-north.width / 2, -radius + 18) -
          Offset(0, north.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _CompassRosePainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

class _QiblahNeedlePainter extends CustomPainter {
  const _QiblahNeedlePainter({required this.isAligned});

  final bool isAligned;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final length = size.width / 2 - 28;
    final color = isAligned ? const Color(0xFF2E7D32) : AppColors.secondary;

    final needle = Path()
      ..moveTo(center.dx, center.dy - length)
      ..lineTo(center.dx - 10, center.dy + 8)
      ..lineTo(center.dx, center.dy + 2)
      ..lineTo(center.dx + 10, center.dy + 8)
      ..close();

    canvas.drawShadow(needle, Colors.black.withValues(alpha: 0.2), 4, false);
    canvas.drawPath(needle, Paint()..color = color);

    final tail = Path()
      ..moveTo(center.dx, center.dy + length * 0.35)
      ..lineTo(center.dx - 6, center.dy + 4)
      ..lineTo(center.dx + 6, center.dy + 4)
      ..close();
    canvas.drawPath(
      tail,
      Paint()..color = AppColors.primary.withValues(alpha: 0.35),
    );
  }

  @override
  bool shouldRepaint(covariant _QiblahNeedlePainter oldDelegate) =>
      oldDelegate.isAligned != isAligned;
}
