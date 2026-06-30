import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/prayer_schedule_sync_service.dart';
import '../../notifications/prayer_timezone.dart';
import 'prayer_location_provider.dart';
import 'prayer_notification_settings_provider.dart';

final prayerScheduleSyncServiceProvider = Provider<PrayerScheduleSyncService>(
  (ref) => PrayerScheduleSyncService(),
);

final prayerScheduleSyncProvider =
    AsyncNotifierProvider<PrayerScheduleSyncNotifier, void>(
  PrayerScheduleSyncNotifier.new,
);

class PrayerScheduleSyncNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    ref.listen<PrayerLocationState>(prayerLocationProvider, (previous, next) {
      if (next is PrayerLocationReady &&
          (previous is! PrayerLocationReady ||
              previous.location.latitude != next.location.latitude ||
              previous.location.longitude != next.location.longitude ||
              previous.location.label != next.location.label)) {
        Future.microtask(syncAll);
      }
    }, fireImmediately: true);
  }

  Future<void> syncAll() async {
    final locationState = ref.read(prayerLocationProvider);
    if (locationState is! PrayerLocationReady) return;

    final settings = ref.read(prayerNotificationSettingsProvider);
    final service = ref.read(prayerScheduleSyncServiceProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await service.syncAll(
        location: locationState.location,
        settings: settings,
      );
    });
  }

  Future<void> syncIfStale() async {
    final locationState = ref.read(prayerLocationProvider);
    if (locationState is! PrayerLocationReady) return;

    await PrayerTimezone.configure();
    final service = ref.read(prayerScheduleSyncServiceProvider);
    final settings = ref.read(prayerNotificationSettingsProvider);

    final cacheStale =
        service.isCacheStaleForLocation(locationState.location);
    final notificationsStale = await service.needsNotificationRefresh(settings);

    if (cacheStale || notificationsStale) {
      await syncAll();
    }
  }
}
