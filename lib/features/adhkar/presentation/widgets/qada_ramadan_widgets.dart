import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';

/// Branded animated hero for the قضاء رمضان guide screen.
class QadaRamadanHeroCard extends StatefulWidget {
  const QadaRamadanHeroCard({super.key, required this.isDark});

  final bool isDark;

  @override
  State<QadaRamadanHeroCard> createState() => _QadaRamadanHeroCardState();
}

class _QadaRamadanHeroCardState extends State<QadaRamadanHeroCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
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
      builder: (context, _) {
        final glow = 0.12 + (_controller.value * 0.1);

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.lerp(
                  AppColors.secondary,
                  const Color(0xFF8B2A32),
                  _controller.value * 0.35,
                )!,
                AppColors.primary,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withValues(alpha: glow),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
            child: Column(
              children: [
                _HeroIconBadge(progress: _controller.value),
                const SizedBox(height: 14),
                Text(
                  'قضاء رمضان',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoNaskhArabic(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'أحكام قضاء الصيام الفائت من رمضان والفدية',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tajawal(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    color: AppColors.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeroIconBadge extends StatelessWidget {
  const _HeroIconBadge({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1 + (progress * 0.04),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.onPrimary.withValues(alpha: 0.14),
          border: Border.all(
            color: AppColors.onPrimary.withValues(alpha: 0.28),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.onPrimary.withValues(alpha: 0.12 + progress * 0.08),
              blurRadius: 16,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(
          Icons.nights_stay_rounded,
          color: AppColors.onPrimary.withValues(alpha: 0.92),
          size: 28,
        ),
      ),
    );
  }
}

/// Animated expandable rule card for قضاء رمضان content.
class QadaRamadanRuleTile extends StatefulWidget {
  const QadaRamadanRuleTile({
    super.key,
    required this.title,
    required this.body,
    required this.isDark,
    required this.index,
  });

  final String title;
  final String body;
  final bool isDark;
  final int index;

  @override
  State<QadaRamadanRuleTile> createState() => _QadaRamadanRuleTileState();
}

class _QadaRamadanRuleTileState extends State<QadaRamadanRuleTile>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late final AnimationController _controller;
  late final Animation<double> _expand;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _expand = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _open = !_open);
    if (_open) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleColor =
        widget.isDark ? AppColors.surfaceLight : AppColors.primary;
    const accent = AppColors.secondary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: AppColors.adhkarCardShadow(isDark: widget.isDark),
          border: Border.all(
            color: _open
                ? accent.withValues(alpha: 0.32)
                : AppColors.primary.withValues(alpha: widget.isDark ? 0.12 : 0.06),
          ),
        ),
        child: Material(
          color: AppColors.cardSurface(widget.isDark),
          borderRadius: BorderRadius.circular(18),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _toggle,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 240),
                        curve: Curves.easeOutCubic,
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: _open
                              ? const LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    AppColors.secondary,
                                    AppColors.primary,
                                  ],
                                )
                              : LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    accent.withValues(alpha: 0.16),
                                    accent.withValues(alpha: 0.08),
                                  ],
                                ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${widget.index + 1}',
                          style: GoogleFonts.tajawal(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: _open
                                ? AppColors.onPrimary
                                : accent.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoNaskhArabic(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: titleColor,
                          ),
                        ),
                      ),
                      RotationTransition(
                        turns: Tween<double>(begin: 0, end: 0.5).animate(_expand),
                        child: Icon(
                          Icons.expand_more_rounded,
                          color: _open
                              ? accent
                              : titleColor.withValues(alpha: 0.45),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizeTransition(
                sizeFactor: _expand,
                axisAlignment: -1,
                child: FadeTransition(
                  opacity: _expand,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: accent.withValues(
                          alpha: widget.isDark ? 0.1 : 0.06,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: accent.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Text(
                          widget.body,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.tajawal(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            height: 1.65,
                            color: titleColor.withValues(alpha: 0.86),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
