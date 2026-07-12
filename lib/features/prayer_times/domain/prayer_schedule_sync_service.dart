import 'package:timezone/timezone.dart' as tz;

import '../data/models/cached_prayer_day.dart';
import '../data/models/prayer_location.dart';
import '../data/models/prayer_notification_settings.dart';
import '../data/prayer_times_cache_storage.dart';
import '../data/prayer_times_repository.dart';
import '../background/prayer_background_tasks.dart';
import '../domain/prayer_location_timezone.dart';
import '../notifications/prayer_notification_service.dart';
import '../notifications/prayer_timezone.dart';

class PrayerScheduleSyncService {
  PrayerScheduleSyncService({PrayerTimesRepository? repository})
      : _repository = repository ?? PrayerTimesRepository();

  final PrayerTimesRepository _repository;

  static const int cacheDays = 30;

  /// Days of cache coverage before a refresh is required.
  static const int minCacheHorizonDays = 2;

  /// Offline-first sync: local cache immediately, merge API when available,
  /// always reschedule notifications from the best available data.
  Future<int> syncAll({
    required PrayerLocation location,
    required PrayerNotificationSettings settings,
    bool registerMidnight = true,
    bool networkRefresh = true,
  }) async {
    await PrayerTimesCacheStorage.init();
    await PrayerTimezone.configure();

    final now = _repository.cityNow(location);
    final startDay = DateTime(now.year, now.month, now.day);
    final todayKey = CachedPrayerDay.dayKeyFor(startDay);
    final timezoneName = PrayerLocationTimezone.forLocation(location);

    // Step 1 — instant offline baseline (local adhan calculation).
    final localDays = _repository.computeDays(
      location: location,
      start: startDay,
      count: cacheDays,
    );
    await PrayerTimesCacheStorage.writeDays(
      days: localDays,
      timezoneName: timezoneName,
      locationLabel: location.label,
      latitude: location.latitude,
      longitude: location.longitude,
      todayKey: todayKey,
    );

    var days = localDays;

    // Step 2 — merge Aladhan calendar API (1–2 requests, with retry).
    if (networkRefresh) {
      try {
        final apiDays = await _repository.fetchDaysFromApi(
          location: location,
          start: startDay,
          count: cacheDays,
        );
        if (apiDays.isNotEmpty) {
          days = _mergeDays(localDays, apiDays);
          await PrayerTimesCacheStorage.writeDays(
            days: days,
            timezoneName: timezoneName,
            locationLabel: location.label,
            latitude: location.latitude,
            longitude: location.longitude,
            todayKey: todayKey,
          );
        }
      } catch (error) {
        // Keep local cache — notifications still work offline.
        assert(() {
          // ignore: avoid_print
          print('Prayer API merge skipped, using local cache: $error');
          return true;
        }());
      }
    }

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

  /// Reschedule from existing Hive cache without network (for background/lock).
  Future<int> rescheduleFromCache({
    required PrayerLocation location,
    required PrayerNotificationSettings settings,
  }) async {
    await PrayerTimesCacheStorage.init();
    await PrayerTimezone.configure();

    final days = PrayerTimesCacheStorage.readAllDays();
    if (days.isEmpty) return 0;

    return PrayerNotificationService.schedulePrayerNotifications(
      days: days,
      settings: settings,
      locationLabel:
          PrayerTimesCacheStorage.locationLabel ?? location.label,
    );
  }

  List<CachedPrayerDay> _mergeDays(
    List<CachedPrayerDay> local,
    Map<String, CachedPrayerDay> apiByKey,
  ) {
    return local.map((day) => apiByKey[day.dayKey] ?? day).toList();
  }

  bool isCacheStaleForLocation(PrayerLocation location) {
    if (!PrayerTimesCacheStorage.hasValidToday(location)) {
      return true;
    }

    final fingerprint = PrayerTimesCacheStorage.cachedLocationFingerprint();
    final current = '${location.latitude}|${location.longitude}';
    if (fingerprint != current) return true;

    final timezoneId = PrayerLocationTimezone.forLocation(location);
    PrayerLocationTimezone.ensureInitialized();
    final cityTz = tz.getLocation(timezoneId);
    if (PrayerTimesCacheStorage.timezoneName != null &&
        PrayerTimesCacheStorage.timezoneName != cityTz.name) {
      return true;
    }

    final allDays = PrayerTimesCacheStorage.readAllDays();
    if (allDays.isEmpty) return true;

    final todayKey = PrayerTimesCacheStorage.todayKeyFor(location);
    final lastDayKey = allDays.last.dayKey;
    final lastDate = DateTime.tryParse('${lastDayKey}T00:00:00');
    final todayDate = DateTime.tryParse('${todayKey}T00:00:00');
    if (lastDate == null || todayDate == null) return true;

    final daysLeft = DateTime(lastDate.year, lastDate.month, lastDate.day)
        .difference(DateTime(todayDate.year, todayDate.month, todayDate.day))
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
