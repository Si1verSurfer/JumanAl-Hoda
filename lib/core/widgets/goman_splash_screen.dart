import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_brand_assets.dart';
import '../constants/app_strings.dart';
import '../theme/app_colors.dart';

/// Full-screen branded splash with logo reveal and smooth handoff to the app.
class GomanSplashScreen extends StatefulWidget {
  const GomanSplashScreen({
    super.key,
    required this.onFinished,
  });

  final VoidCallback onFinished;

  @override
  State<GomanSplashScreen> createState() => _GomanSplashScreenState();
}

class _GomanSplashScreenState extends State<GomanSplashScreen>
    with TickerProviderStateMixin {
  static const _totalDuration = Duration(milliseconds: 4000);

  late final AnimationController _intro;
  late final AnimationController _glow;
  late final AnimationController _shimmer;
  late final AnimationController _drift;

  late final Animation<double> _backdropOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _haloScale;
  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _taglineOpacity;
  late final Animation<double> _taglineScale;
  late final Animation<double> _progress;
  late final Animation<double> _exitOpacity;
  late final Animation<double> _blur;

  @override
  void initState() {
    super.initState();

    _intro = AnimationController(vsync: this, duration: _totalDuration);
    _glow = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    )..repeat();
    _drift = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 9000),
    )..repeat();

    _backdropOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0, 0.22, curve: Curves.easeOutCubic),
      ),
    );
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.06, 0.38, curve: Curves.easeOutCubic),
      ),
    );
    _logoScale = Tween<double>(begin: 0.86, end: 1).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.06, 0.44, curve: Curves.easeOutCubic),
      ),
    );
    _haloScale = Tween<double>(begin: 0.78, end: 1).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.1, 0.5, curve: Curves.easeOutCubic),
      ),
    );
    _titleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.3, 0.56, curve: Curves.easeOutCubic),
      ),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.3, 0.56, curve: Curves.easeOutCubic),
      ),
    );
    _taglineOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.44, 0.66, curve: Curves.easeOutCubic),
      ),
    );
    _taglineScale = Tween<double>(begin: 0.96, end: 1).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.44, 0.66, curve: Curves.easeOutCubic),
      ),
    );
    _progress = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.12, 0.82, curve: Curves.easeInOutCubic),
      ),
    );
    _exitOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.82, 1, curve: Curves.easeInOutCubic),
      ),
    );
    _blur = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.84, 1, curve: Curves.easeInCubic),
      ),
    );

    _intro.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onFinished();
      }
    });

    _intro.forward();
  }

  @override
  void dispose() {
    _intro.dispose();
    _glow.dispose();
    _shimmer.dispose();
    _drift.dispose();
    super.dispose();
  }

  double get _floatOffset => math.sin(_drift.value * math.pi * 2) * 6;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_intro, _glow, _shimmer, _drift]),
      builder: (context, child) {
        return Opacity(
          opacity: _exitOpacity.value,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: _blur.value,
              sigmaY: _blur.value,
            ),
            child: child,
          ),
        );
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Material(
          color: AppColors.mushafPaper,
          child: Stack(
            fit: StackFit.expand,
            children: [
              FadeTransition(
                opacity: _backdropOpacity,
                child: _SplashBackdrop(
                  drift: _drift.value,
                  glow: _glow.value,
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    const Spacer(flex: 3),
                    Transform.translate(
                      offset: Offset(0, _floatOffset),
                      child: FadeTransition(
                        opacity: _logoOpacity,
                        child: ScaleTransition(
                          scale: _logoScale,
                          child: _SplashLogo(
                            haloScale: _haloScale.value,
                            glow: _glow.value,
                            shimmer: _shimmer.value,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    FadeTransition(
                      opacity: _titleOpacity,
                      child: SlideTransition(
                        position: _titleSlide,
                        child: _SplashTitle(glow: _glow.value),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeTransition(
                      opacity: _taglineOpacity,
                      child: Transform.scale(
                        scale: _taglineScale.value,
                        child: const _SplashTagline(),
                      ),
                    ),
                    const Spacer(flex: 4),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(52, 0, 52, 40),
                      child: _SplashProgressBar(
                        progress: _progress.value,
                        pulse: _glow.value,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplashBackdrop extends StatelessWidget {
  const _SplashBackdrop({
    required this.drift,
    required this.glow,
  });

  final double drift;
  final double glow;

  @override
  Widget build(BuildContext context) {
    final orbShift = math.sin(drift * math.pi * 2);

    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.18 + orbShift * 0.04),
              radius: 1.2,
              colors: [
                const Color(0xFFFFF9F2),
                AppColors.mushafPaper,
                const Color(0xFFF3E4D2),
                AppColors.secondary.withValues(alpha: 0.08),
              ],
              stops: const [0.2, 0.48, 0.76, 1],
            ),
          ),
        ),
        Positioned(
          top: -80 + orbShift * 24,
          right: -40,
          child: _SoftOrb(
            size: 220,
            color: AppColors.secondary.withValues(alpha: 0.07 + glow * 0.04),
          ),
        ),
        Positioned(
          bottom: 40 - orbShift * 18,
          left: -60,
          child: _SoftOrb(
            size: 180,
            color: AppColors.primary.withValues(alpha: 0.05 + glow * 0.03),
          ),
        ),
        Positioned(
          top: 120,
          left: 40 + orbShift * 20,
          child: _SoftOrb(
            size: 100,
            color: AppColors.secondary.withValues(alpha: 0.04),
          ),
        ),
        CustomPaint(
          painter: _SplashPatternPainter(opacity: 0.55 + glow * 0.2),
          size: Size.infinite,
        ),
      ],
    );
  }
}

class _SoftOrb extends StatelessWidget {
  const _SoftOrb({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}

class _SplashLogo extends StatelessWidget {
  const _SplashLogo({
    required this.haloScale,
    required this.glow,
    required this.shimmer,
  });

  final double haloScale;
  final double glow;
  final double shimmer;

  @override
  Widget build(BuildContext context) {
    const logoSize = 132.0;
    final ringAlpha = 0.1 + glow * 0.1;
    final haloSize = logoSize + 52 + glow * 12;
    final breathe = 1 + glow * 0.018;

    return SizedBox(
      width: haloSize + 32,
      height: haloSize + 32,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.scale(
            scale: haloScale * breathe,
            child: Container(
              width: haloSize,
              height: haloSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: ringAlpha),
                    AppColors.secondary.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          Transform.scale(
            scale: haloScale,
            child: Container(
              width: logoSize + 32,
              height: logoSize + 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.16 + glow * 0.08),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.12),
                    blurRadius: 36 + glow * 10,
                    spreadRadius: 4,
                  ),
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: logoSize,
            height: logoSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipOval(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    AppBrandAssets.splashLogo,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (context, error, stackTrace) => ColoredBox(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.mosque_rounded,
                        color: AppColors.secondary.withValues(alpha: 0.75),
                        size: 52,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Transform.translate(
                      offset: Offset(
                        -logoSize + (shimmer * logoSize * 2.6),
                        0,
                      ),
                      child: Container(
                        width: logoSize * 0.5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0),
                              Colors.white.withValues(alpha: 0.14),
                              Colors.white.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashTitle extends StatelessWidget {
  const _SplashTitle({required this.glow});

  final double glow;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppStrings.appName,
          style: GoogleFonts.notoNaskhArabic(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            height: 1.2,
            color: AppColors.primary,
            shadows: [
              Shadow(
                color: AppColors.secondary.withValues(alpha: 0.08 + glow * 0.06),
                blurRadius: 18,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Container(
              width: 48 + value * 36,
              height: 2.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99),
                gradient: LinearGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0),
                    AppColors.secondary.withValues(alpha: 0.55 + glow * 0.15),
                    AppColors.secondary.withValues(alpha: 0),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SplashTagline extends StatelessWidget {
  const _SplashTagline();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        AppStrings.splashTagline,
        textAlign: TextAlign.center,
        style: GoogleFonts.tajawal(
          fontSize: 14.5,
          fontWeight: FontWeight.w500,
          height: 1.6,
          letterSpacing: 0.2,
          color: AppColors.primary.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

class _SplashProgressBar extends StatelessWidget {
  const _SplashProgressBar({
    required this.progress,
    required this.pulse,
  });

  final double progress;
  final double pulse;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: SizedBox(
        height: 2.5,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(
              color: AppColors.primary.withValues(alpha: 0.06),
            ),
            FractionallySizedBox(
              alignment: Alignment.centerRight,
              widthFactor: progress.clamp(0, 1),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.secondary.withValues(alpha: 0.45),
                      AppColors.secondary.withValues(alpha: 0.85 + pulse * 0.1),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.25 + pulse * 0.1),
                      blurRadius: 8,
                      spreadRadius: 0.5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplashPatternPainter extends CustomPainter {
  _SplashPatternPainter({required this.opacity});

  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.42);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    for (var i = 1; i <= 5; i++) {
      paint.color = AppColors.secondary
          .withValues(alpha: (0.02 + i * 0.005) * opacity);
      canvas.drawCircle(center, 58.0 * i, paint);
    }

    paint.color = AppColors.secondary.withValues(alpha: 0.03 * opacity);
    for (var i = 0; i < 8; i++) {
      final angle = (math.pi / 4) * i - math.pi / 2;
      final end = Offset(
        center.dx + math.cos(angle) * size.width * 0.48,
        center.dy + math.sin(angle) * size.width * 0.48,
      );
      canvas.drawLine(center, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SplashPatternPainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}

/// Overlays [child] with an animated splash until the intro sequence completes.
class GomanSplashGate extends StatefulWidget {
  const GomanSplashGate({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<GomanSplashGate> createState() => _GomanSplashGateState();
}

class _GomanSplashGateState extends State<GomanSplashGate> {
  var _showSplash = true;

  void _finishSplash() {
    if (!mounted) return;
    setState(() => _showSplash = false);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        fit: StackFit.expand,
        children: [
          widget.child,
          if (_showSplash)
            Positioned.fill(
              child: GomanSplashScreen(onFinished: _finishSplash),
            ),
        ],
      ),
    );
  }
}
