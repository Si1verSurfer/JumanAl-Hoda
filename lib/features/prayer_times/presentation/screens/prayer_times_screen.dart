import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_nav_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/platform_utils.dart';
import '../../data/constants/prayer_arabic_labels.dart';
import '../../notifications/prayer_notification_service.dart';
import '../providers/prayer_countdown_provider.dart';
import '../providers/prayer_location_provider.dart';
import '../providers/prayer_schedule_sync_provider.dart';
import '../providers/prayer_times_provider.dart';
import '../theme/prayer_page_style.dart';
import '../widgets/prayer_date_header.dart';
import '../widgets/prayer_location_sheet.dart';
import '../widgets/prayer_next_hero_card.dart';
import '../widgets/prayer_notification_settings_sheet.dart';
import '../widgets/prayer_times_list_card.dart';

class PrayerTimesScreen extends HookConsumerWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locationState = ref.watch(prayerLocationProvider);
    final schedule = ref.watch(prayerScheduleProvider);
    final countdown = ref.watch(prayerCountdownProvider);
    final repository = ref.watch(prayerTimesRepositoryProvider);

    useEffect(() {
      ref.read(prayerCountdownProvider.notifier);
      return null;
    }, const []);

    useEffect(() {
      if (locationState is PrayerLocationReady) {
        Future.microtask(() async {
          await PrayerNotificationService.requestPermissions();
          await ref.read(prayerScheduleSyncProvider.notifier).syncIfStale();
        });
      }
      return null;
    }, [locationState]);

    final bottomPadding = PlatformUtils.isIOS
        ? AppNavConstants.floatingBottomPadding(context)
        : 24.0;

    void openLocationSheet() {
      showPrayerLocationSheet(context, ref);
    }

    return Container(
      color: PrayerPageStyle.background(isDark),
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: PrayerPageStyle.pagePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        tooltip: PrayerArabicLabels.notificationSettingsTitle,
                        onPressed: schedule != null
                            ? () => showPrayerNotificationSettingsSheet(
                                  context,
                                  ref,
                                )
                            : null,
                        icon: Icon(
                          Icons.notifications_outlined,
                          color: isDark
                              ? AppColors.surfaceLight
                              : AppColors.primary,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          PrayerArabicLabels.timesTitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoNaskhArabic(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                            color: isDark
                                ? AppColors.surfaceLight
                                : AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 18),
                  if (locationState is PrayerLocationLoading)
                    _LoadingState(isDark: isDark)
                  else if (locationState is PrayerLocationError)
                    _ErrorState(
                      isDark: isDark,
                      message: locationState.message,
                      onSelectLocation: openLocationSheet,
                      onRetryGps: () => ref
                          .read(prayerLocationProvider.notifier)
                          .refreshFromGps(),
                    )
                  else if (schedule != null) ...[
                    PrayerDateHeader(
                      dateDisplay: schedule.dateDisplay,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 14),
                    PrayerNextHeroCard(
                      prayerName: schedule.nextSalahName(),
                      prayerTimeLabel:
                          repository.formatTime(schedule.nextSalahTime),
                      countdownLabel: countdown.label,
                      locationLabel: schedule.locationLabel,
                      isDark: isDark,
                      onChangeLocation: openLocationSheet,
                    ),
                    const SizedBox(height: 16),
                    PrayerTimesListCard(
                      entries: schedule.entries,
                      isDark: isDark,
                      timeLabelFor: repository.formatTime,
                    ),
                  ],
                  SizedBox(height: bottomPadding),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: BoxDecoration(
        color: AppColors.glassLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow(isDark: isDark),
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 14),
          Text(
            PrayerArabicLabels.loadingLocation,
            style: GoogleFonts.tajawal(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.isDark,
    required this.message,
    required this.onSelectLocation,
    required this.onRetryGps,
  });

  final bool isDark;
  final String message;
  final VoidCallback onSelectLocation;
  final VoidCallback onRetryGps;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.glassLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow(isDark: isDark),
      ),
      child: Column(
        children: [
          Icon(
            Icons.location_off_rounded,
            size: 36,
            color: AppColors.secondary.withValues(alpha: 0.8),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoNaskhArabic(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.surfaceLight : AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onRetryGps,
                  child: Text(
                    AppStrings.prayerUseMyLocation,
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: onSelectLocation,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: AppColors.onPrimary,
                  ),
                  child: Text(
                    AppStrings.prayerChangeLocation,
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
