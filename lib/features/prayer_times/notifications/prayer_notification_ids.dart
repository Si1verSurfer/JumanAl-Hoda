import '../data/models/daily_prayer_schedule.dart';

/// Stable notification IDs for scheduled prayer alerts.
abstract final class PrayerNotificationIds {
  static const int maxDays = 30;
  static const int idsPerDay = 10;
  static const int maxId = maxDays * idsPerDay;

  static int forDayAndKind(int dayIndex, PrayerTimeKind kind) {
    return (dayIndex * idsPerDay) + kind.index + 1;
  }

  static List<int> allIds() {
    return List<int>.generate(maxId, (index) => index + 1);
  }
}
