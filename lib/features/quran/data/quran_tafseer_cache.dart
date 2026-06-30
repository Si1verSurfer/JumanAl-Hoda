import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import 'models/ayah_tafseer.dart';

/// Persistent on-disk cache for ayah tafseer entries.
abstract final class QuranTafseerCache {
  static const _boxName = 'quran_ayah_tafseer_v1';

  static Box<String>? _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box ??= await Hive.openBox<String>(_boxName);
  }

  static String cacheKey({
    required String bookSlug,
    required int surahNumber,
    required int verseNumber,
  }) {
    return '$bookSlug|$surahNumber:$verseNumber';
  }

  static AyahTafseer? read(
    String key, {
    String? expectedBookSlug,
  }) {
    final raw = _box?.get(key);
    if (raw == null) return null;

    try {
      final parsed = AyahTafseer.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      if (expectedBookSlug != null && parsed.bookSlug != expectedBookSlug) {
        return null;
      }
      return parsed;
    } catch (_) {
      _box?.delete(key);
      return null;
    }
  }

  static Future<void> write(String key, AyahTafseer tafseer) async {
    await _box?.put(key, jsonEncode(tafseer.toJson()));
  }
}
