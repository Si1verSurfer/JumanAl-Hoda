import 'package:flutter/foundation.dart';

import '../data/models/cached_prayer_day.dart';
import '../data/models/daily_prayer_schedule.dart';
import '../data/models/prayer_notification_settings.dart';
import 'prayer_notification_ids.dart';

/// Pure scheduling limits and counting (testable without plugins).
abstract final class PrayerNotificationScheduler {
  /// iOS allows at most 64 pending local notifications.
  static const int iosPendingLimit = 64;

  /// Keep at least this many days of notifications buffered on iOS.
  static const int iosMinBufferedDays = 3;

  static int enabledPrayersPerDay(PrayerNotificationSettings settings) {
    var count = 0;
    for (final kind in PrayerTimeKind.values) {
      if (settings.isEnabledFor(kind.name)) count++;
    }
    return count;
  }

  static int maxSchedulableNotifications({
    TargetPlatform? platform,
    PrayerNotificationSettings? settings,
  }) {
    final resolvedPlatform = platform ?? defaultTargetPlatform;
    if (resolvedPlatform == TargetPlatform.iOS) {
      return iosPendingLimit;
    }
    return PrayerNotificationIds.maxDays *
        (settings == null ? PrayerTimeKind.values.length : enabledPrayersPerDay(settings));
  }

  static int countFutureNotifications({
    required List<CachedPrayerDay> days,
    required PrayerNotificationSettings settings,
    DateTime? reference,
    int? maxCount,
  }) {
    if (!settings.masterEnabled) return 0;

    final now = reference ?? DateTime.now();
    final limit = maxCount ?? maxSchedulableNotifications(settings: settings);
    var count = 0;

    for (final day in days) {
      for (final kind in PrayerTimeKind.values) {
        if (!settings.isEnabledFor(kind.name)) continue;
        final time = day.timeFor(kind);
        if (time == null || !time.isAfter(now)) continue;
        count++;
        if (count >= limit) return limit;
      }
    }
    return count;
  }

  static bool shouldRefreshPending({
    required int pendingCount,
    required PrayerNotificationSettings settings,
    TargetPlatform? platform,
  }) {
    final resolvedPlatform = platform ?? defaultTargetPlatform;
    if (!settings.masterEnabled) return false;
    final perDay = enabledPrayersPerDay(settings);
    if (perDay == 0) return false;
    final minDesired = perDay * iosMinBufferedDays;
    if (resolvedPlatform == TargetPlatform.iOS) {
      return pendingCount < minDesired;
    }
    return pendingCount < minDesired;
  }
}

