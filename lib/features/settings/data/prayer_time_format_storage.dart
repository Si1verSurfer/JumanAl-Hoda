import 'package:shared_preferences/shared_preferences.dart';

const _prayerTimeFormatKey = 'prayer_time_format_24h_v1';

class PrayerTimeFormatStorage {
  /// `true` = 24-hour clock, `false` = 12-hour clock (default).
  Future<bool> loadIs24Hour() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prayerTimeFormatKey) ?? false;
  }

  Future<void> saveIs24Hour(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prayerTimeFormatKey, value);
  }
}
