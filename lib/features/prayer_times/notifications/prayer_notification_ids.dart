import '../data/models/daily_prayer_schedule.dart';

/// Stable notification IDs for scheduled prayer alerts.
abstract final class PrayerNotificationIds {
  static const int maxDays = 30;
  static const int idsPerDay = 10;
  static const int maxId = maxDays * idsPerDay;

  static const int azkarEvening = 301;
  static const int azkarMorning = 302;
  static const int kahfFriday = 303;

  static const reminderIds = [azkarEvening, azkarMorning, kahfFriday];

  static int forDayAndKind(int dayIndex, PrayerTimeKind kind) {
    return (dayIndex * idsPerDay) + kind.index + 1;
  }

  static List<int> allIds() {
    return List<int>.generate(maxId, (index) => index + 1);
  }
}
