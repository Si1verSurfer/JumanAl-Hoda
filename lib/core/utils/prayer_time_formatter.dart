import '../../features/prayer_times/domain/prayer_location_timezone.dart';

/// Formats prayer [DateTime] values for display in 12h or 24h with Arabic digits.
abstract final class PrayerTimeFormatter {
  static String format(DateTime time, {required bool is24Hour}) {
    final wall = PrayerLocationTimezone.wallClock(time);
    final minute = wall.minute.toString().padLeft(2, '0');

    if (is24Hour) {
      final hour = wall.hour.toString().padLeft(2, '0');
      return _toArabicDigits('$hour:$minute');
    }

    final hour12 = wall.hour % 12 == 0 ? 12 : wall.hour % 12;
    final period = wall.hour < 12 ? 'ص' : 'م';
    return _toArabicDigits(
      '${hour12.toString().padLeft(2, '0')}:$minute $period',
    );
  }

  static String _toArabicDigits(String input) {
    const arabics = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return input.replaceAllMapped(RegExp('[0-9]'), (match) {
      return arabics[int.parse(match.group(0)!)];
    });
  }
}
