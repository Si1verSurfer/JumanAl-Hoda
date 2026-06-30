import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goman_alhoda/features/prayer_times/data/models/cached_prayer_day.dart';
import 'package:goman_alhoda/features/prayer_times/data/models/daily_prayer_schedule.dart';
import 'package:goman_alhoda/features/prayer_times/data/models/prayer_location.dart';
import 'package:goman_alhoda/features/prayer_times/data/models/prayer_notification_settings.dart';
import 'package:goman_alhoda/features/prayer_times/data/prayer_times_cache_storage.dart';
import 'package:goman_alhoda/features/prayer_times/data/prayer_times_repository.dart';
import 'package:goman_alhoda/features/prayer_times/domain/prayer_schedule_sync_service.dart';
import 'package:goman_alhoda/features/prayer_times/notifications/prayer_notification_ids.dart';
import 'package:goman_alhoda/features/prayer_times/notifications/prayer_notification_scheduler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ar');
  });

  group('PrayerTimesRepository', () {
    final repository = PrayerTimesRepository();
    const riyadh = PrayerLocation(
      latitude: 24.7136,
      longitude: 46.6753,
      label: 'الرياض',
      source: PrayerLocationSource.manual,
    );

    test('computeDayTimes returns all six prayer keys', () {
      final day = repository.computeDayTimes(
        location: riyadh,
        day: DateTime(2026, 3, 15),
      );

      expect(day.dayKey, '2026-03-15');
      expect(day.timesIso.keys, containsAll(CachedPrayerDay.prayerKeys));
      for (final key in CachedPrayerDay.prayerKeys) {
        expect(DateTime.tryParse(day.timesIso[key]!), isNotNull);
      }
    });

    test('computeDays returns requested count', () {
      final days = repository.computeDays(
        location: riyadh,
        start: DateTime(2026, 3, 15),
        count: 30,
      );
      expect(days, hasLength(30));
      expect(days.first.dayKey, '2026-03-15');
      expect(days.last.dayKey, '2026-04-13');
    });

    test('buildScheduleFromCache matches compute path for same day', () {
      final reference = DateTime(2026, 3, 15, 12);
      final cached = repository.computeDayTimes(
        location: riyadh,
        day: reference,
      );
      final fromCache = repository.buildScheduleFromCache(
        cachedDay: cached,
        location: riyadh,
        reference: reference,
      );
      final direct = repository.buildSchedule(
        location: riyadh,
        reference: reference,
      );

      expect(fromCache.entries.length, direct.entries.length);
      for (var i = 0; i < fromCache.entries.length; i++) {
        expect(fromCache.entries[i].kind, direct.entries[i].kind);
        expect(
          fromCache.entries[i].time.hour,
          direct.entries[i].time.hour,
        );
        expect(
          fromCache.entries[i].time.minute,
          direct.entries[i].time.minute,
        );
      }
    });
  });

  group('PrayerTimesCacheStorage', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('prayer_cache_test');
      Hive.init(tempDir.path);
      await PrayerTimesCacheStorage.init(useFlutterPath: false);
    });

    tearDown(() async {
      if (Hive.isBoxOpen('prayer_times_cache_v1')) {
        await Hive.box<String>('prayer_times_cache_v1').clear();
        await Hive.box<String>('prayer_times_cache_v1').close();
      }
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('writeDays round-trips cached days', () async {
      const day = CachedPrayerDay(
        dayKey: '2026-03-15',
        latitude: 24.7136,
        longitude: 46.6753,
        timesIso: {
          'fajr': '2026-03-15T04:30:00.000',
          'sunrise': '2026-03-15T05:45:00.000',
          'dhuhr': '2026-03-15T12:10:00.000',
          'asr': '2026-03-15T15:30:00.000',
          'maghrib': '2026-03-15T18:05:00.000',
          'isha': '2026-03-15T19:35:00.000',
        },
      );

      await PrayerTimesCacheStorage.writeDays(
        days: [day],
        timezoneName: 'Asia/Riyadh',
        locationLabel: 'الرياض',
        latitude: 24.7136,
        longitude: 46.6753,
      );

      final read = PrayerTimesCacheStorage.readDay('2026-03-15');
      expect(read, isNotNull);
      expect(read!.dayKey, day.dayKey);
      expect(read.timesIso['fajr'], day.timesIso['fajr']);
      expect(PrayerTimesCacheStorage.cachedLocationFingerprint(),
          '24.7136|46.6753');
    });
  });

  group('PrayerNotificationIds', () {
    test('IDs are unique per day and prayer kind', () {
      final ids = <int>{};
      for (var day = 0; day < PrayerNotificationIds.maxDays; day++) {
        for (final kind in PrayerTimeKind.values) {
          final id = PrayerNotificationIds.forDayAndKind(day, kind);
          expect(ids.contains(id), isFalse);
          ids.add(id);
        }
      }
      expect(ids.length,
          PrayerNotificationIds.maxDays * PrayerTimeKind.values.length);
    });

    test('allIds covers reserved range', () {
      expect(PrayerNotificationIds.allIds(), hasLength(PrayerNotificationIds.maxId));
      expect(PrayerNotificationIds.allIds().first, 1);
      expect(PrayerNotificationIds.allIds().last, PrayerNotificationIds.maxId);
    });
  });

  group('PrayerScheduleSyncService schedulablePrayerKeys', () {
    test('excludes sunrise by default', () {
      const settings = PrayerNotificationSettings();
      final day = CachedPrayerDay(
        dayKey: '2099-01-01',
        latitude: 24.7136,
        longitude: 46.6753,
        timesIso: {
          for (final key in CachedPrayerDay.prayerKeys)
            key: '2099-01-01T12:00:00.000',
        },
      );

      final keys = PrayerScheduleSyncService.schedulablePrayerKeys(
        days: [day],
        settings: settings,
        reference: DateTime(2098, 12, 31),
      );

      expect(keys, contains('fajr'));
      expect(keys, isNot(contains('sunrise')));
      expect(keys, contains('isha'));
    });

    test('includes sunrise when enabled', () {
      const settings = PrayerNotificationSettings(sunrise: true);
      final day = CachedPrayerDay(
        dayKey: '2099-01-01',
        latitude: 24.7136,
        longitude: 46.6753,
        timesIso: {
          for (final key in CachedPrayerDay.prayerKeys)
            key: '2099-01-01T12:00:00.000',
        },
      );

      final keys = PrayerScheduleSyncService.schedulablePrayerKeys(
        days: [day],
        settings: settings,
        reference: DateTime(2098, 12, 31),
      );

      expect(keys, contains('sunrise'));
    });
  });

  group('PrayerNotificationScheduler', () {
    test('caps iOS schedules at 64 notifications', () {
      const settings = PrayerNotificationSettings();
      final template = CachedPrayerDay(
        dayKey: '2099-01-01',
        latitude: 24.7136,
        longitude: 46.6753,
        timesIso: {
          for (final key in CachedPrayerDay.prayerKeys)
            key: '2099-01-01T12:00:00.000',
        },
      );
      final days = List.generate(
        30,
        (index) => CachedPrayerDay(
          dayKey: '2099-01-${(index + 1).toString().padLeft(2, '0')}',
          latitude: 24.7136,
          longitude: 46.6753,
          timesIso: template.timesIso,
        ),
      );

      final count = PrayerNotificationScheduler.countFutureNotifications(
        days: days,
        settings: settings,
        reference: DateTime(2098, 12, 31),
        maxCount: PrayerNotificationScheduler.maxSchedulableNotifications(
          platform: TargetPlatform.iOS,
          settings: settings,
        ),
      );

      expect(count, 64);
    });

    test('should refresh when pending count is low', () {
      const settings = PrayerNotificationSettings();
      expect(
        PrayerNotificationScheduler.shouldRefreshPending(
          pendingCount: 10,
          settings: settings,
          platform: TargetPlatform.iOS,
        ),
        isTrue,
      );
      expect(
        PrayerNotificationScheduler.shouldRefreshPending(
          pendingCount: 30,
          settings: settings,
          platform: TargetPlatform.iOS,
        ),
        isFalse,
      );
    });
  });
}
