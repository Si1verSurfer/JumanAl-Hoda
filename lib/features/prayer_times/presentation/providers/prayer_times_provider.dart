import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/daily_prayer_schedule.dart';
import '../../data/models/cached_prayer_day.dart';
import '../../data/models/prayer_location.dart';
import '../../data/prayer_times_cache_storage.dart';
import '../../data/prayer_times_repository.dart';
import '../../domain/prayer_location_timezone.dart';
import 'prayer_location_provider.dart';

final prayerTimesRepositoryProvider = Provider<PrayerTimesRepository>(
  (ref) => PrayerTimesRepository(),
);

final prayerScheduleProvider = Provider<DailyPrayerSchedule?>((ref) {
  final locationState = ref.watch(prayerLocationProvider);
  if (locationState is! PrayerLocationReady) return null;

  final repository = ref.watch(prayerTimesRepositoryProvider);
  final location = locationState.location;
  final now = repository.cityNow(location);
  final todayKey = CachedPrayerDay.dayKeyFor(now);
  final cached = PrayerTimesCacheStorage.readDay(todayKey);
  final fingerprint =
      '${location.latitude}|${location.longitude}';
  final cachedFingerprint = PrayerTimesCacheStorage.cachedLocationFingerprint();

  if (cached != null && cachedFingerprint == fingerprint) {
    return repository.buildScheduleFromCache(
      cachedDay: cached,
      location: location,
      reference: now,
    );
  }

  final schedule = repository.buildSchedule(
    location: location,
    reference: now,
  );
  _persistTodayIfMissing(location, repository, now);
  return schedule;
});

void _persistTodayIfMissing(
  PrayerLocation location,
  PrayerTimesRepository repository,
  DateTime now,
) {
  final todayKey = CachedPrayerDay.dayKeyFor(now);
  if (PrayerTimesCacheStorage.readDay(todayKey) != null) return;

  final day = repository.computeDayTimes(location: location, day: now);
  final existing = PrayerTimesCacheStorage.readAllDays();
  final merged = [...existing.where((d) => d.dayKey != todayKey), day]
    ..sort((a, b) => a.dayKey.compareTo(b.dayKey));

  Future.microtask(() {
    PrayerTimesCacheStorage.writeDays(
      days: merged,
      timezoneName: PrayerLocationTimezone.forLocation(location),
      locationLabel: location.label,
      latitude: location.latitude,
      longitude: location.longitude,
      todayKey: todayKey,
    );
  });
}
