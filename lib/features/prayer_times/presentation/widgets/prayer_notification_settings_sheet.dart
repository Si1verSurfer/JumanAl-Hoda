import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/haptics/goman_haptics.dart';
import '../../../../core/constants/app_nav_constants.dart';
import '../../../../core/navigation/goman_navigation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/platform_utils.dart';
import '../../data/constants/prayer_arabic_labels.dart';
import '../../data/models/daily_prayer_schedule.dart';
import '../../notifications/prayer_notification_service.dart';
import '../providers/prayer_notification_settings_provider.dart';

void showPrayerNotificationSettingsSheet(BuildContext context, WidgetRef ref) {
  showGomanModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const PrayerNotificationSettingsSheet(),
  );
}

Future<void> _handleMasterToggle(
  BuildContext context,
  PrayerNotificationSettingsNotifier notifier,
  bool value,
) async {
  GomanHaptics.tap();
  if (value) {
    final granted = await PrayerNotificationService.requestPermissions();
    if (!granted) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              PrayerArabicLabels.notificationPermissionDenied,
              style: GoogleFonts.tajawal(fontWeight: FontWeight.w600),
            ),
          ),
        );
      }
      return;
    }

    if (Platform.isAndroid) {
      final status = await PrayerNotificationService.permissionStatus();
      if (status.needsExactAlarmSettings && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              PrayerArabicLabels.notificationExactAlarmHint,
              style: GoogleFonts.tajawal(fontWeight: FontWeight.w600),
            ),
            action: SnackBarAction(
              label: 'الإعدادات',
              onPressed: PrayerNotificationService.openExactAlarmSettings,
            ),
          ),
        );
      }
    }
  }

  await notifier.setMasterEnabled(value);
}

class PrayerNotificationSettingsSheet extends ConsumerWidget {
  const PrayerNotificationSettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settings = ref.watch(prayerNotificationSettingsProvider);
    final notifier = ref.read(prayerNotificationSettingsProvider.notifier);
    final titleColor = isDark ? AppColors.surfaceLight : AppColors.primary;
    final sheetColor =
        isDark ? AppColors.surfaceDarkElevated : AppColors.glassLight;
    final bottomMargin = PlatformUtils.isIOS
        ? AppNavConstants.floatingBottomPadding(context)
        : 24.0;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.78,
          ),
          margin: EdgeInsets.fromLTRB(12, 0, 12, bottomMargin),
          decoration: BoxDecoration(
            color: sheetColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppColors.cardShadow(isDark: isDark),
          ),
          child: SwitchTheme(
            data: SwitchThemeData(
              thumbColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.onPrimary;
                }
                return isDark ? AppColors.surfaceLight : Colors.white;
              }),
              trackColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.secondary;
                }
                return titleColor.withValues(alpha: 0.14);
              }),
              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: titleColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              AppColors.secondary.withValues(alpha: 0.22),
                              AppColors.primary.withValues(alpha: 0.12),
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.notifications_active_rounded,
                          color: AppColors.secondary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          PrayerArabicLabels.notificationSettingsTitle,
                          style: GoogleFonts.notoNaskhArabic(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                            color: titleColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      children: [
                        _MasterToggleCard(
                          titleColor: titleColor,
                          isDark: isDark,
                          value: settings.masterEnabled,
                          onChanged: (value) =>
                              _handleMasterToggle(context, notifier, value),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.surfaceDark
                                : AppColors.surfaceElevatedLight,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.06),
                            ),
                          ),
                          child: Column(
                            children: [
                              for (var i = 0;
                                  i < PrayerTimeKind.values.length;
                                  i++) ...[
                                if (i > 0)
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: AppColors.primary
                                        .withValues(alpha: 0.06),
                                    indent: 16,
                                    endIndent: 16,
                                  ),
                                _PrayerToggleRow(
                                  label: PrayerArabicLabels.prayerDisplayName(
                                    PrayerTimeKind.values[i],
                                  ),
                                  titleColor: titleColor,
                                  value: settings.isEnabledFor(
                                    PrayerTimeKind.values[i].name,
                                  ),
                                  enabled: settings.masterEnabled,
                                  onChanged: (value) {
                                    GomanHaptics.tap();
                                    notifier.setPrayerEnabled(
                                      PrayerTimeKind.values[i].name,
                                      value,
                                    );
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
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

class _MasterToggleCard extends StatelessWidget {
  const _MasterToggleCard({
    required this.titleColor,
    required this.isDark,
    required this.value,
    required this.onChanged,
  });

  final Color titleColor;
  final bool isDark;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.secondary.withValues(alpha: isDark ? 0.2 : 0.12),
            AppColors.primary.withValues(alpha: isDark ? 0.14 : 0.05),
          ],
        ),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.16),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  PrayerArabicLabels.notificationMaster,
                  style: GoogleFonts.notoNaskhArabic(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  PrayerArabicLabels.notificationMasterSubtitle,
                  style: GoogleFonts.tajawal(
                    fontSize: 13,
                    height: 1.35,
                    color: titleColor.withValues(alpha: 0.62),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _PrayerToggleRow extends StatelessWidget {
  const _PrayerToggleRow({
    required this.label,
    required this.titleColor,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final String label;
  final Color titleColor;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final muted = !enabled;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.notoNaskhArabic(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: muted
                    ? titleColor.withValues(alpha: 0.38)
                    : titleColor,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: enabled ? onChanged : null,
          ),
        ],
      ),
    );
  }
}
