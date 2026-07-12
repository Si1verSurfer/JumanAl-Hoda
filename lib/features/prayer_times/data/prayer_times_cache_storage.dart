import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../domain/prayer_location_timezone.dart';
import 'models/cached_prayer_day.dart';
import 'models/prayer_location.dart';

abstract final class PrayerTimesCacheStorage {
  static const _boxName = 'prayer_times_cache_v1';
  static const _metaLastSyncKey = '__last_synced_at__';
  static const _metaTimezoneKey = '__timezone_name__';
  static const _metaLocationLabelKey = '__location_label__';
  static const _metaLatKey = '__location_lat__';
  static const _metaLngKey = '__location_lng__';
  static const _metaCacheVersionKey = '__cache_version__';
  static const _metaTodayKey = '__cached_today_key__';

  /// Matches Rafiq-Al-Dhikr: refresh after 18 hours even on the same day.
  static const cacheMaxAge = Duration(hours: 18);
  static const cacheVersion = 1;

  static Box<String>? _box;

  static Future<void> init({bool useFlutterPath = true}) async {
    if (!Hive.isBoxOpen(_boxName)) {
      if (useFlutterPath) {
        await Hive.initFlutter();
      }
      _box ??= await Hive.openBox<String>(_boxName);
    }
  }

  static Future<void> writeDays({
    required List<CachedPrayerDay> days,
    required String timezoneName,
    required String locationLabel,
    required double latitude,
    required double longitude,
    String? todayKey,
  }) async {
    await init();
    final box = _box!;
    final dayKeys = days.map((day) => day.dayKey).toSet();
    final staleKeys = box.keys
        .where((key) => key is String && !key.startsWith('__') && !dayKeys.contains(key))
        .toList();
    for (final key in staleKeys) {
      await box.delete(key);
    }
    for (final day in days) {
      await box.put(day.dayKey, jsonEncode(day.toJson()));
    }
    final now = DateTime.now();
    await box.put(_metaLastSyncKey, now.toIso8601String());
    await box.put(_metaTimezoneKey, timezoneName);
    await box.put(_metaLocationLabelKey, locationLabel);
    await box.put(_metaLatKey, latitude.toString());
    await box.put(_metaLngKey, longitude.toString());
    await box.put(_metaCacheVersionKey, cacheVersion.toString());
    if (todayKey != null) {
      await box.put(_metaTodayKey, todayKey);
    }
  }

  static CachedPrayerDay? readDay(String dayKey) {
    final raw = _box?.get(dayKey);
    if (raw == null) return null;
    try {
      return CachedPrayerDay.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static List<CachedPrayerDay> readRange(String fromKey, String toKey) {
    return readAllDays()
        .where((day) =>
            day.dayKey.compareTo(fromKey) >= 0 && day.dayKey.compareTo(toKey) <= 0)
        .toList();
  }

  static List<CachedPrayerDay> readAllDays() {
    final box = _box;
    if (box == null) return [];
    final days = <CachedPrayerDay>[];
    for (final key in box.keys) {
      if (key is! String || key.startsWith('__')) continue;
      final day = readDay(key);
      if (day != null) days.add(day);
    }
    days.sort((a, b) => a.dayKey.compareTo(b.dayKey));
    return days;
  }

  static DateTime? get lastSyncedAt {
    final raw = _box?.get(_metaLastSyncKey);
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  static String? get timezoneName => _box?.get(_metaTimezoneKey);

  static String? get locationLabel => _box?.get(_metaLocationLabelKey);

  static String? cachedLocationFingerprint() {
    final lat = _box?.get(_metaLatKey);
    final lng = _box?.get(_metaLngKey);
    if (lat == null || lng == null) return null;
    return '$lat|$lng';
  }

  static String todayKeyFor(PrayerLocation location) {
    final timezoneId = PrayerLocationTimezone.forLocation(location);
    final now = PrayerLocationTimezone.nowIn(timezoneId);
    return CachedPrayerDay.dayKeyFor(now);
  }

  static bool hasValidToday(PrayerLocation location, {bool allowOld = false}) {
    final todayKey = todayKeyFor(location);
    final cached = readDay(todayKey);
    if (cached == null || !_isComplete(cached)) return false;

    final fingerprint = cachedLocationFingerprint();
    final current = '${location.latitude}|${location.longitude}';
    if (fingerprint != current) return false;

    if (allowOld) return true;

    final storedToday = _box?.get(_metaTodayKey);
    if (storedToday != null && storedToday != todayKey) return false;

    final syncedAt = lastSyncedAt;
    if (syncedAt == null) return false;
    if (DateTime.now().difference(syncedAt) > cacheMaxAge) return false;

    final version = int.tryParse(_box?.get(_metaCacheVersionKey) ?? '') ?? 0;
    return version == cacheVersion;
  }

  static bool _isComplete(CachedPrayerDay day) {
    for (final key in CachedPrayerDay.prayerKeys) {
      final raw = day.timesIso[key];
      if (raw == null || DateTime.tryParse(raw) == null) return false;
    }
    return true;
  }
}
