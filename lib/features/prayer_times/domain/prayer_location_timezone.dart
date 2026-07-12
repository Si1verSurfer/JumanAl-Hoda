import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../data/models/prayer_location.dart';

/// Resolves city timezone and local "now" for prayer calculations.
abstract final class PrayerLocationTimezone {
  static bool _initialized = false;

  static void ensureInitialized() {
    if (_initialized) return;
    tz.initializeTimeZones();
    _initialized = true;
  }

  static String forLocation(PrayerLocation location) {
    if (location.timezoneId != null && location.timezoneId!.isNotEmpty) {
      return location.timezoneId!;
    }
    return forCoordinates(location.latitude, location.longitude);
  }

  static String forCoordinates(double latitude, double longitude) {
    if (latitude >= 29 && latitude <= 35 && longitude >= 24 && longitude <= 37) {
      return 'Africa/Cairo';
    }
    if (latitude >= 24.5 && latitude <= 26.5 && longitude >= 54 && longitude <= 56.5) {
      return 'Asia/Dubai';
    }
    if (latitude >= 28.5 && latitude <= 30.5 && longitude >= 46 && longitude <= 49) {
      return 'Asia/Kuwait';
    }
    if (latitude >= 24 && latitude <= 32 && longitude >= 34 && longitude <= 56) {
      return 'Asia/Riyadh';
    }
    return 'Asia/Riyadh';
  }

  static Duration utcOffsetFor(String timezoneId, DateTime day) {
    ensureInitialized();
    final location = tz.getLocation(timezoneId);
    final local = tz.TZDateTime(location, day.year, day.month, day.day, 12);
    return local.timeZoneOffset;
  }

  static DateTime nowIn(String timezoneId) {
    ensureInitialized();
    final location = tz.getLocation(timezoneId);
    final now = tz.TZDateTime.now(location);
    return DateTime.utc(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second,
    );
  }

  /// Normalizes adhan UTC-offset times and city-local instants for comparison.
  static DateTime wallClock(DateTime time) {
    if (time.isUtc) return time;
    return DateTime.utc(
      time.year,
      time.month,
      time.day,
      time.hour,
      time.minute,
      time.second,
    );
  }
}
