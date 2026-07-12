import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';

import '../data/prayer_location_storage.dart';
import '../data/prayer_notification_settings_storage.dart';
import '../data/prayer_times_cache_storage.dart';
import '../domain/prayer_schedule_sync_service.dart';
import '../notifications/prayer_notification_service.dart';
import '../notifications/prayer_timezone.dart';
import 'prayer_background_tasks.dart';

@pragma('vm:entry-point')
void prayerBackgroundCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      switch (task) {
        case PrayerBackgroundTasks.midnightTask:
        case PrayerBackgroundTasks.bootTask:
          await runPrayerBackgroundSync();
          return true;
      }
    } catch (error, stackTrace) {
      debugPrint('Prayer background task failed ($task): $error');
      debugPrint('$stackTrace');
      return false;
    }
    return false;
  });
}

Future<void> runPrayerBackgroundSync() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await PrayerTimesCacheStorage.init();
  await PrayerNotificationService.init();
  await PrayerTimezone.configure();

  final location = await PrayerLocationStorage().load();
  if (location == null) {
    debugPrint('Prayer background sync skipped: no saved location.');
    return;
  }

  final settings = await PrayerNotificationSettingsStorage().load();
  final service = PrayerScheduleSyncService();

  // Offline-first: reschedule from cache immediately (works when device is locked).
  await service.rescheduleFromCache(
    location: location,
    settings: settings,
  );

  if (service.isCacheStaleForLocation(location) ||
      await service.needsNotificationRefresh(settings)) {
    await service.syncAll(
      location: location,
      settings: settings,
    );
  } else {
    await PrayerBackgroundTasks.registerMidnightRefresh();
  }
}
