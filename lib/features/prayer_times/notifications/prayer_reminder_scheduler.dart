import '../data/models/cached_prayer_day.dart';
import '../data/models/daily_prayer_schedule.dart';

/// Payload values for azkar reminder notification taps.
abstract final class PrayerReminderPayloads {
  static const morning = 'morning';
  static const evening = 'evening';
}

/// Pure scheduling helpers for azkar and Kahf reminders (testable).
abstract final class PrayerReminderScheduler {
  static const Duration azkarOffsetFromPrayer = Duration(minutes: 45);

  static DateTime? nextEveningAzkarTime({
    required CachedPrayerDay today,
    CachedPrayerDay? tomorrow,
    required DateTime now,
  }) {
    final tNext = tomorrow ?? today;
    final t0 = _prayerOnDateWithOffset(
      today,
      PrayerTimeKind.maghrib,
      now,
      offset: -azkarOffsetFromPrayer,
    );
    if (t0 != null && t0.isAfter(now)) return t0;

    final nextDay = DateTime(now.year, now.month, now.day + 1);
    return _prayerOnDateWithOffset(
      tNext,
      PrayerTimeKind.maghrib,
      nextDay,
      offset: -azkarOffsetFromPrayer,
    );
  }

  static DateTime? nextMorningAzkarTime({
    required CachedPrayerDay today,
    CachedPrayerDay? tomorrow,
    required DateTime now,
  }) {
    final tNext = tomorrow ?? today;
    final t0 = _prayerOnDateWithOffset(
      today,
      PrayerTimeKind.fajr,
      now,
      offset: azkarOffsetFromPrayer,
    );
    if (t0 != null && t0.isAfter(now)) return t0;

    final nextDay = DateTime(now.year, now.month, now.day + 1);
    return _prayerOnDateWithOffset(
      tNext,
      PrayerTimeKind.fajr,
      nextDay,
      offset: azkarOffsetFromPrayer,
    );
  }

  static DateTime? nextFridayDhuhr({
    required DateTime now,
    CachedPrayerDay? fridayDay,
  }) {
    const fridayWeekday = DateTime.friday;
    var days = fridayWeekday - now.weekday;
    if (days < 0) days += 7;

    if (days == 0) {
      final todayDhuhr = fridayDay?.timeFor(PrayerTimeKind.dhuhr);
      if (todayDhuhr != null && todayDhuhr.isAfter(now)) {
        return todayDhuhr;
      }
      days = 7;
    }

    final fridayDate = DateTime(now.year, now.month, now.day + days);
    if (fridayDay != null) {
      final dhuhr = fridayDay.timeFor(PrayerTimeKind.dhuhr);
      if (dhuhr != null) {
        return DateTime(
          fridayDate.year,
          fridayDate.month,
          fridayDate.day,
          dhuhr.hour,
          dhuhr.minute,
        );
      }
    }

    return DateTime(fridayDate.year, fridayDate.month, fridayDate.day, 14, 0);
  }

  static DateTime? _prayerOnDateWithOffset(
    CachedPrayerDay day,
    PrayerTimeKind kind,
    DateTime date, {
    required Duration offset,
  }) {
    final time = day.timeFor(kind);
    if (time == null) return null;
    final base = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    return base.add(offset);
  }
}
