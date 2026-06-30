import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/cached_prayer_day.dart';
import '../../data/models/daily_prayer_schedule.dart';
import '../../data/prayer_times_cache_storage.dart';
import '../../data/prayer_times_repository.dart';
import 'prayer_location_provider.dart';

final prayerTimesRepositoryProvider = Provider<PrayerTimesRepository>(
  (ref) => PrayerTimesRepository(),
);

final prayerScheduleProvider = Provider<DailyPrayerSchedule?>((ref) {
  final locationState = ref.watch(prayerLocationProvider);
  if (locationState is! PrayerLocationReady) return null;

  final repository = ref.watch(prayerTimesRepositoryProvider);
  final now = DateTime.now();
  final todayKey = CachedPrayerDay.dayKeyFor(now);
  final cached = PrayerTimesCacheStorage.readDay(todayKey);
  final fingerprint =
      '${locationState.location.latitude}|${locationState.location.longitude}';
  final cachedFingerprint = PrayerTimesCacheStorage.cachedLocationFingerprint();

  if (cached != null && cachedFingerprint == fingerprint) {
    return repository.buildScheduleFromCache(
      cachedDay: cached,
      location: locationState.location,
      reference: now,
    );
  }

  return repository.buildSchedule(location: locationState.location);
});
