import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/goman_ink_well.dart';

/// Prominent home-screen entry point for the Qiblah compass.
class QiblahHomeButton extends StatelessWidget {
  const QiblahHomeButton({
    super.key,
    required this.isDark,
    required this.onTap,
  });

  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.adhkarCardShadow(isDark: isDark),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: GomanInkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    AppColors.secondary,
                    AppColors.secondary.withValues(alpha: 0.88),
                    AppColors.primary,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Row(
                  children: [
                    const _CompassGlyph(),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            AppStrings.qiblahTitle,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoNaskhArabic(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                              color: AppColors.onPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppStrings.qiblahSubtitle,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.tajawal(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 1.35,
                              color: AppColors.onPrimary.withValues(alpha: 0.78),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.22),
                        ),
                      ),
                      child: const Icon(
                        Icons.explore_rounded,
                        color: AppColors.onPrimary,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CompassGlyph extends StatelessWidget {
  const _CompassGlyph();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 52,
      height: 52,
      child: CustomPaint(
        painter: _CompassGlyphPainter(),
      ),
    );
  }
}

class _CompassGlyphPainter extends CustomPainter {
  const _CompassGlyphPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    final ring = Paint()
      ..color = Colors.white.withValues(alpha: 0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, ring);

    final tick = Paint()
      ..color = Colors.white.withValues(alpha: 0.55)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      final inner = radius - (i.isEven ? 6 : 3);
      final outer = radius - 1;
      canvas.drawLine(
        center + Offset(inner * math.sin(angle), inner * math.cos(angle)),
        center + Offset(outer * math.sin(angle), outer * math.cos(angle)),
        tick,
      );
    }

    final needle = Path()
      ..moveTo(center.dx, center.dy - radius + 8)
      ..lineTo(center.dx - 5, center.dy + 4)
      ..lineTo(center.dx, center.dy + 1)
      ..lineTo(center.dx + 5, center.dy + 4)
      ..close();
    canvas.drawPath(
      needle,
      Paint()..color = AppColors.mushafPaper,
    );
    canvas.drawPath(
      needle,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );

    canvas.drawCircle(
      center,
      3,
      Paint()..color = AppColors.mushafPaper,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
