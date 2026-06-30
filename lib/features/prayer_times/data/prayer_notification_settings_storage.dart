import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models/prayer_notification_settings.dart';

const _settingsKey = 'prayer_notification_settings_v1';

class PrayerNotificationSettingsStorage {
  Future<PrayerNotificationSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_settingsKey);
    if (raw == null) return const PrayerNotificationSettings();
    try {
      return PrayerNotificationSettings.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return const PrayerNotificationSettings();
    }
  }

  Future<void> save(PrayerNotificationSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
  }
}
