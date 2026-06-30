import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models/prayer_location.dart';

const _locationKey = 'prayer_location_v1';

class PrayerLocationStorage {
  Future<PrayerLocation?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_locationKey);
    if (raw == null) return null;

    try {
      return PrayerLocation.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      await prefs.remove(_locationKey);
      return null;
    }
  }

  Future<void> save(PrayerLocation location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_locationKey, jsonEncode(location.toJson()));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_locationKey);
  }
}
