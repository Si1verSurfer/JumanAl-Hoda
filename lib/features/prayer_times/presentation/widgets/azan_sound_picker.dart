import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/haptics/goman_haptics.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/constants/prayer_arabic_labels.dart';
import '../../notifications/azan_preview_service.dart';

class AzanOption {
  const AzanOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
}

const azanOptions = [
  AzanOption(
    id: 'azano',
    title: PrayerArabicLabels.notificationAzanOption1,
    subtitle: PrayerArabicLabels.notificationAzanOption1Hint,
    icon: Icons.mosque_rounded,
  ),
  AzanOption(
    id: 'azant',
    title: PrayerArabicLabels.notificationAzanOption2,
    subtitle: PrayerArabicLabels.notificationAzanOption2Hint,
    icon: Icons.record_voice_over_rounded,
  ),
  AzanOption(
    id: 'azanc',
    title: PrayerArabicLabels.notificationAzanOption3,
    subtitle: PrayerArabicLabels.notificationAzanOption3Hint,
    icon: Icons.nights_stay_rounded,
  ),
  AzanOption(
    id: 'azand',
    title: PrayerArabicLabels.notificationAzanOption4,
    subtitle: PrayerArabicLabels.notificationAzanOption4Hint,
    icon: Icons.wb_twilight_rounded,
  ),
];

class AzanSoundPicker extends HookConsumerWidget {
  const AzanSoundPicker({
    super.key,
    required this.selected,
    required this.enabled,
    required this.onChanged,
    required this.titleColor,
    required this.isDark,
  });

  final String selected;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final Color titleColor;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playingId = useState<String?>(null);
    final subscription = useRef<StreamSubscription<PlayerState>?>(null);

    useEffect(() {
      return () {
        subscription.value?.cancel();
        AzanPreviewService.stop();
      };
    }, const []);

    Future<void> selectOption(String id) async {
      if (!enabled) return;
      GomanHaptics.tap();
      onChanged(id);

      subscription.value?.cancel();
      playingId.value = id;

      final started = await AzanPreviewService.play(id);
      if (!context.mounted) return;

      if (!started) {
        playingId.value = null;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              PrayerArabicLabels.notificationAzanPreviewUnavailable,
              style: GoogleFonts.tajawal(fontWeight: FontWeight.w600),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      if (AzanPreviewService.playerStateStream case final stream?) {
        subscription.value = stream.listen((state) {
          if (state.processingState == ProcessingState.completed ||
              (!state.playing &&
                  state.processingState == ProcessingState.ready &&
                  AzanPreviewService.currentSound == null)) {
            playingId.value = null;
          } else if (state.playing) {
            playingId.value = AzanPreviewService.currentSound;
          }
        });
      }
    }

    final muted = !enabled;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.secondary.withValues(alpha: isDark ? 0.2 : 0.1),
            AppColors.primary.withValues(alpha: isDark ? 0.14 : 0.04),
          ],
        ),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: isDark ? 0.32 : 0.16),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: isDark ? 0.14 : 0.08),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [AppColors.secondary, AppColors.primary],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.28),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.graphic_eq_rounded,
                  size: 24,
                  color: muted
                      ? AppColors.onPrimary.withValues(alpha: 0.45)
                      : AppColors.onPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      PrayerArabicLabels.notificationAzanSound,
                      style: GoogleFonts.notoNaskhArabic(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: muted
                            ? titleColor.withValues(alpha: 0.38)
                            : titleColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      PrayerArabicLabels.notificationAzanSubtitle,
                      style: GoogleFonts.tajawal(
                        fontSize: 12.5,
                        height: 1.35,
                        color: muted
                            ? titleColor.withValues(alpha: 0.28)
                            : titleColor.withValues(alpha: 0.58),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              for (var row = 0; row < azanOptions.length; row += 2) ...[
                if (row > 0) const SizedBox(height: 12),
                Row(
                  children: [
                    for (var col = 0; col < 2; col++) ...[
                      if (col > 0) const SizedBox(width: 12),
                      Expanded(
                        child: row + col < azanOptions.length
                            ? _AzanOptionCard(
                                option: azanOptions[row + col],
                                isSelected:
                                    selected == azanOptions[row + col].id,
                                isPlaying: playingId.value ==
                                    azanOptions[row + col].id,
                                enabled: enabled,
                                isDark: isDark,
                                titleColor: titleColor,
                                onTap: () =>
                                    selectOption(azanOptions[row + col].id),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _AzanOptionCard extends StatelessWidget {
  const _AzanOptionCard({
    required this.option,
    required this.isSelected,
    required this.isPlaying,
    required this.enabled,
    required this.isDark,
    required this.titleColor,
    required this.onTap,
  });

  final AzanOption option;
  final bool isSelected;
  final bool isPlaying;
  final bool enabled;
  final bool isDark;
  final Color titleColor;
  final VoidCallback onTap;

  static const _selectedGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Color(0xFF8B2A32),
      AppColors.secondary,
      AppColors.primary,
    ],
    stops: [0.0, 0.48, 1.0],
  );

  @override
  Widget build(BuildContext context) {
    final muted = !enabled;
    final labelColor = isSelected
        ? AppColors.onPrimary
        : (muted ? titleColor.withValues(alpha: 0.38) : titleColor);
    final hintColor = isSelected
        ? AppColors.onPrimary.withValues(alpha: 0.82)
        : (muted
            ? titleColor.withValues(alpha: 0.28)
            : titleColor.withValues(alpha: 0.52));
    final waveformColor =
        isSelected ? AppColors.onPrimary : AppColors.secondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(18),
        splashColor: isSelected
            ? AppColors.onPrimary.withValues(alpha: 0.12)
            : AppColors.secondary.withValues(alpha: 0.12),
        highlightColor: isSelected
            ? AppColors.onPrimary.withValues(alpha: 0.06)
            : AppColors.secondary.withValues(alpha: 0.06),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: isSelected
                ? _selectedGradient
                : LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      isDark
                          ? AppColors.surfaceDarkElevated
                          : AppColors.surfaceElevatedLight,
                      isDark ? AppColors.surfaceDark : AppColors.glassLight,
                    ],
                  ),
            border: Border.all(
              color: isSelected
                  ? AppColors.onPrimary.withValues(alpha: 0.28)
                  : AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.08),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.38),
                      blurRadius: 18,
                      spreadRadius: -2,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.22),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppColors.onPrimary.withValues(alpha: 0.16)
                          : AppColors.secondary.withValues(alpha: 0.1),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.onPrimary.withValues(alpha: 0.35)
                            : AppColors.secondary.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause_rounded : option.icon,
                      size: 21,
                      color: isSelected ? AppColors.onPrimary : AppColors.secondary,
                    ),
                  ),
                  const Spacer(),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.onPrimary.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.onPrimary.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 14,
                            color: AppColors.onPrimary.withValues(alpha: 0.95),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'مُختار',
                            style: GoogleFonts.tajawal(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                option.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.notoNaskhArabic(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  color: labelColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                option.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.tajawal(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: hintColor,
                ),
              ),
              const SizedBox(height: 12),
              _AzanWaveform(
                active: isPlaying,
                color: muted
                    ? titleColor.withValues(alpha: 0.2)
                    : waveformColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AzanWaveform extends StatefulWidget {
  const _AzanWaveform({required this.active, required this.color});

  final bool active;
  final Color color;

  @override
  State<_AzanWaveform> createState() => _AzanWaveformState();
}

class _AzanWaveformState extends State<_AzanWaveform>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant _AzanWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.active != widget.active) {
      _syncAnimation();
    }
  }

  void _syncAnimation() {
    if (widget.active) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const barCount = 5;
    return SizedBox(
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(barCount, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final phase = (index / barCount) + _controller.value;
              final heightFactor = widget.active
                  ? 0.35 + (0.65 * (0.5 + 0.5 * _wave(phase)))
                  : 0.2;
              return Padding(
                padding: EdgeInsetsDirectional.only(
                  start: index == 0 ? 0 : 4,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 4.5,
                  height: 20 * heightFactor,
                  decoration: BoxDecoration(
                    color: widget.color.withValues(
                      alpha: widget.active ? 0.95 : 0.32,
                    ),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  double _wave(double t) {
    final wrapped = t - t.floorToDouble();
    return (wrapped < 0.5 ? wrapped * 2 : (1 - wrapped) * 2);
  }
}
