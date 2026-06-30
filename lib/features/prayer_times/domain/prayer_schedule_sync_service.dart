import 'package:timezone/timezone.dart' as tz;

import '../data/models/cached_prayer_day.dart';
import '../data/models/prayer_location.dart';
import '../data/models/prayer_notification_settings.dart';
import '../data/prayer_times_cache_storage.dart';
import '../data/prayer_times_repository.dart';
import '../background/prayer_background_tasks.dart';
import '../notifications/prayer_notification_service.dart';
import '../notifications/prayer_timezone.dart';

class PrayerScheduleSyncService {
  PrayerScheduleSyncService({PrayerTimesRepository? repository})
      : _repository = repository ?? PrayerTimesRepository();

  final PrayerTimesRepository _repository;

  static const int cacheDays = 30;

  /// Days of cache coverage before a refresh is required.
  static const int minCacheHorizonDays = 2;

  Future<int> syncAll({
    required PrayerLocation location,
    required PrayerNotificationSettings settings,
    bool registerMidnight = true,
  }) async {
    await PrayerTimesCacheStorage.init();
    await PrayerTimezone.configure();

    final now = DateTime.now();
    final days = _repository.computeDays(
      location: location,
      start: now,
      count: cacheDays,
    );

    final timezoneName = await PrayerTimezone.localTimezoneName();
    await PrayerTimesCacheStorage.writeDays(
      days: days,
      timezoneName: timezoneName,
      locationLabel: location.label,
      latitude: location.latitude,
      longitude: location.longitude,
    );

    final scheduled = await PrayerNotificationService.schedulePrayerNotifications(
      days: days,
      settings: settings,
      locationLabel: location.label,
    );

    if (registerMidnight) {
      await PrayerBackgroundTasks.registerMidnightRefresh();
    }

    return scheduled;
  }

  bool isCacheStaleForLocation(PrayerLocation location) {
    final todayKey = CachedPrayerDay.dayKeyFor(DateTime.now());
    final cached = PrayerTimesCacheStorage.readDay(todayKey);
    if (cached == null) return true;

    final fingerprint = PrayerTimesCacheStorage.cachedLocationFingerprint();
    final current = '${location.latitude}|${location.longitude}';
    if (fingerprint != current) return true;

    final cachedTimezone = PrayerTimesCacheStorage.timezoneName;
    if (cachedTimezone != null && cachedTimezone != tz.local.name) {
      return true;
    }

    final allDays = PrayerTimesCacheStorage.readAllDays();
    if (allDays.isEmpty) return true;

    final lastDayKey = allDays.last.dayKey;
    final lastDate = DateTime.tryParse(lastDayKey);
    if (lastDate == null) return true;

    final today = DateTime.now();
    final daysLeft = DateTime(lastDate.year, lastDate.month, lastDate.day)
        .difference(DateTime(today.year, today.month, today.day))
        .inDays;
    if (daysLeft < minCacheHorizonDays) return true;

    return false;
  }

  Future<bool> needsNotificationRefresh(
    PrayerNotificationSettings settings,
  ) {
    return PrayerNotificationService.shouldRefreshPendingNotifications(settings);
  }

  /// Returns prayer keys that would be scheduled (for tests).
  static List<String> schedulablePrayerKeys({
    required List<CachedPrayerDay> days,
    required PrayerNotificationSettings settings,
    DateTime? reference,
  }) {
    if (!settings.masterEnabled) return [];

    final now = reference ?? DateTime.now();
    final keys = <String>{};
    for (final day in days) {
      for (final key in CachedPrayerDay.prayerKeys) {
        if (!settings.isEnabledFor(key)) continue;
        final time = day.timesIso[key];
        if (time == null) continue;
        final parsed = DateTime.tryParse(time);
        if (parsed == null || !parsed.isAfter(now)) continue;
        keys.add(key);
      }
    }
    return keys.toList()..sort();
  }
}
