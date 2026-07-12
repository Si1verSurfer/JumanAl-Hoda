import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/general_icon_assets.dart';
import '../../../../core/haptics/goman_haptics.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/goman_svg_icon.dart';
import '../../data/models/tasbih_state.dart';
import '../providers/tasbih_provider.dart';

void showTasbihCustomizeSheet({
  required BuildContext context,
  required WidgetRef ref,
  required bool isDark,
  required TasbihState initial,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => TasbihCustomizeSheet(
      isDark: isDark,
      initial: initial,
    ),
  );
}

class ElectronicTasbihPanel extends ConsumerStatefulWidget {
  const ElectronicTasbihPanel({super.key, required this.isDark});

  final bool isDark;

  @override
  ConsumerState<ElectronicTasbihPanel> createState() =>
      _ElectronicTasbihPanelState();
}

class _ElectronicTasbihPanelState extends ConsumerState<ElectronicTasbihPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  bool _wasComplete = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _onTap(TasbihState tasbih) async {
    await ref.read(tasbihProvider.notifier).increment();
    _pulseController.forward(from: 0);

    if (tasbih.hapticsEnabled) {
      await GomanHaptics.tap();
    }

    final next = ref.read(tasbihProvider).valueOrNull;
    if (next != null && next.isComplete && !_wasComplete) {
      _wasComplete = true;
      if (next.hapticsEnabled) {
        await GomanHaptics.success();
      }
    } else if (next != null && !next.isComplete) {
      _wasComplete = false;
    }
  }

  Future<void> _onRepeat(TasbihState tasbih) async {
    await ref.read(tasbihProvider.notifier).resetCount();
    _wasComplete = false;
    if (tasbih.hapticsEnabled) {
      await GomanHaptics.tap();
    }
  }

  Future<void> _onToggleHaptics(TasbihState tasbih) async {
    await ref.read(tasbihProvider.notifier).toggleHaptics();
    final next = ref.read(tasbihProvider).valueOrNull;
    if (next != null && next.hapticsEnabled) {
      await GomanHaptics.tap();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasbihAsync = ref.watch(tasbihProvider);
    final textColor =
        widget.isDark ? AppColors.surfaceLight : AppColors.primary;
    final muted = textColor.withValues(alpha: 0.55);

    return tasbihAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      error: (error, stackTrace) => const SizedBox.shrink(),
      data: (tasbih) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 70),
              Text(
                tasbih.dhikr,
                textAlign: TextAlign.center,
                style: GoogleFonts.notoNaskhArabic(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  height: 1.55,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 80),
              LayoutBuilder(
                builder: (context, constraints) {
                  const sideButtonSize = 48.0;
                  const gap = 12.0;
                  final counterSize = (constraints.maxWidth -
                          (2 * sideButtonSize) -
                          (2 * gap))
                      .clamp(160.0, 200.0);

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _TasbihIconButton(
                        size: sideButtonSize,
                        tooltip: AppStrings.tasbihRepeat,
                        isDark: widget.isDark,
                        enabled: tasbih.count > 0,
                        onTap: () => _onRepeat(tasbih),
                        icon: GomanSvgIcon(
                          asset: GeneralIconAssets.repeat,
                          color: tasbih.count > 0
                              ? AppColors.secondary
                              : muted,
                          size: 22,
                        ),
                      ),
                      SizedBox(width: gap),
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          final scale = 1 - (_pulseController.value * 0.03);
                          return Transform.scale(scale: scale, child: child);
                        },
                        child: GestureDetector(
                          onTap: () => _onTap(tasbih),
                          child: _TasbihCounter(
                            isDark: widget.isDark,
                            count: tasbih.count,
                            target: tasbih.target,
                            progress: tasbih.progress,
                            isComplete: tasbih.isComplete,
                            size: counterSize,
                          ),
                        ),
                      ),
                      SizedBox(width: gap),
                      _TasbihIconButton(
                        size: sideButtonSize,
                        tooltip: AppStrings.tasbihHaptics,
                        isDark: widget.isDark,
                        enabled: true,
                        isSelected: tasbih.hapticsEnabled,
                        onTap: () => _onToggleHaptics(tasbih),
                        icon: GomanSvgIcon(
                          asset: tasbih.hapticsEnabled
                              ? GeneralIconAssets.phoneVibrate
                              : GeneralIconAssets.notificationsAlert,
                          color: tasbih.hapticsEnabled
                              ? AppColors.secondary
                              : muted,
                          size: 22,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),
              Text(
                tasbih.isComplete
                    ? AppStrings.tasbihComplete
                    : AppStrings.tasbihTapHint,
                textAlign: TextAlign.center,
                style: GoogleFonts.tajawal(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: tasbih.isComplete ? AppColors.secondary : muted,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TasbihIconButton extends StatelessWidget {
  const _TasbihIconButton({
    required this.tooltip,
    required this.isDark,
    required this.onTap,
    required this.icon,
    this.size = 48,
    this.enabled = true,
    this.isSelected = false,
  });

  final String tooltip;
  final bool isDark;
  final VoidCallback onTap;
  final Widget icon;
  final double size;
  final bool enabled;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.cardSurface(isDark),
        shape: const CircleBorder(),
        elevation: isDark ? 0 : 1,
        shadowColor: AppColors.primary.withValues(alpha: 0.12),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: enabled ? onTap : null,
          child: Ink(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? AppColors.secondary.withValues(alpha: 0.35)
                    : AppColors.secondary.withValues(alpha: 0.12),
              ),
            ),
            child: Center(child: icon),
          ),
        ),
      ),
    );
  }
}

class _TasbihCounter extends StatelessWidget {
  const _TasbihCounter({
    required this.isDark,
    required this.count,
    required this.target,
    required this.progress,
    required this.isComplete,
    required this.size,
  });

  final bool isDark;
  final int count;
  final int target;
  final double progress;
  final bool isComplete;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _SimpleRingPainter(
              progress: progress,
              isComplete: isComplete,
              isDark: isDark,
            ),
          ),
          Container(
            width: size - 36,
            height: size - 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.cardSurface(isDark),
              boxShadow: AppColors.adhkarCardShadow(isDark: isDark),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$count',
                  style: GoogleFonts.tajawal(
                    fontSize: size * 0.26,
                    fontWeight: FontWeight.w800,
                    height: 1,
                    color: isComplete
                        ? AppColors.secondary
                        : (isDark
                            ? AppColors.surfaceLight
                            : AppColors.primary),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'من $target',
                  style: GoogleFonts.tajawal(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SimpleRingPainter extends CustomPainter {
  _SimpleRingPainter({
    required this.progress,
    required this.isComplete,
    required this.isDark,
  });

  final double progress;
  final bool isComplete;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const stroke = 6.0;

    final track = Paint()
      ..color = AppColors.secondary.withValues(alpha: isDark ? 0.14 : 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    canvas.drawCircle(center, radius, track);

    if (progress <= 0) return;

    final arc = Paint()
      ..color = isComplete ? AppColors.secondary : AppColors.secondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(covariant _SimpleRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isComplete != isComplete;
  }
}

class TasbihCustomizeSheet extends ConsumerStatefulWidget {
  const TasbihCustomizeSheet({
    super.key,
    required this.isDark,
    required this.initial,
  });

  final bool isDark;
  final TasbihState initial;

  @override
  ConsumerState<TasbihCustomizeSheet> createState() =>
      _TasbihCustomizeSheetState();
}

class _TasbihCustomizeSheetState extends ConsumerState<TasbihCustomizeSheet> {
  late final TextEditingController _dhikrController;
  late final TextEditingController _targetController;
  late int _target;

  @override
  void initState() {
    super.initState();
    _dhikrController = TextEditingController(text: widget.initial.dhikr);
    _target = widget.initial.target;
    _targetController = TextEditingController(text: '$_target');
  }

  @override
  void dispose() {
    _dhikrController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final parsed = int.tryParse(_targetController.text.trim());
    final target = parsed != null && parsed > 0 ? parsed : _target;

    await ref.read(tasbihProvider.notifier).updateSettings(
          dhikr: _dhikrController.text,
          target: target,
        );
    if (mounted) Navigator.of(context).pop();
  }

  void _applyPreset(TasbihPreset preset) {
    setState(() {
      _dhikrController.text = preset.dhikr;
      _target = preset.target;
      _targetController.text = '${preset.target}';
    });
  }

  void _setTarget(int value) {
    if (value < 1) return;
    setState(() {
      _target = value;
      _targetController.text = '$value';
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final surface = widget.isDark
        ? AppColors.surfaceDarkElevated
        : AppColors.surfaceLight;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: AppColors.cardShadow(isDark: widget.isDark),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.tasbihCustomize,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tajawal(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: widget.isDark
                        ? AppColors.surfaceLight
                        : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppStrings.tasbihPresets,
                  style: GoogleFonts.tajawal(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final preset in TasbihPresets.list)
                      ActionChip(
                        label: Text(
                          preset.dhikr,
                          style: GoogleFonts.notoNaskhArabic(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () => _applyPreset(preset),
                        backgroundColor: AppColors.secondary
                            .withValues(alpha: widget.isDark ? 0.18 : 0.08),
                        side: BorderSide(
                          color: AppColors.secondary.withValues(alpha: 0.2),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  AppStrings.tasbihDhikrLabel,
                  style: GoogleFonts.tajawal(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _dhikrController,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: GoogleFonts.notoNaskhArabic(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: widget.isDark
                        ? AppColors.surfaceDark
                        : AppColors.surfaceElevatedLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  AppStrings.tasbihTargetLabel,
                  style: GoogleFonts.tajawal(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _TargetStepButton(
                      icon: Icons.remove_rounded,
                      onPressed:
                          _target > 1 ? () => _setTarget(_target - 1) : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: 72,
                        child: TextField(
                          controller: _targetController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            final parsed = int.tryParse(value);
                            if (parsed != null && parsed > 0) {
                              _target = parsed;
                            }
                          },
                          style: GoogleFonts.tajawal(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: widget.isDark
                                ? AppColors.surfaceDark
                                : AppColors.surfaceElevatedLight,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    _TargetStepButton(
                      icon: Icons.add_rounded,
                      onPressed: () => _setTarget(_target + 1),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    AppStrings.tasbihSave,
                    style: GoogleFonts.tajawal(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TargetStepButton extends StatelessWidget {
  const _TargetStepButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.secondary.withValues(alpha: 0.12),
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.secondary),
      ),
    );
  }
}
