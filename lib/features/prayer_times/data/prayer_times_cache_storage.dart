import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import 'models/cached_prayer_day.dart';

abstract final class PrayerTimesCacheStorage {
  static const _boxName = 'prayer_times_cache_v1';
  static const _metaLastSyncKey = '__last_synced_at__';
  static const _metaTimezoneKey = '__timezone_name__';
  static const _metaLocationLabelKey = '__location_label__';
  static const _metaLatKey = '__location_lat__';
  static const _metaLngKey = '__location_lng__';

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
    await box.put(_metaLastSyncKey, DateTime.now().toIso8601String());
    await box.put(_metaTimezoneKey, timezoneName);
    await box.put(_metaLocationLabelKey, locationLabel);
    await box.put(_metaLatKey, latitude.toString());
    await box.put(_metaLngKey, longitude.toString());
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
        .where((day) => day.dayKey.compareTo(fromKey) >= 0 && day.dayKey.compareTo(toKey) <= 0)
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
}
