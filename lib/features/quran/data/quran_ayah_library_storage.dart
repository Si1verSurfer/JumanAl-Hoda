import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import 'models/ayah_card.dart';
import 'models/ayah_highlight.dart';

abstract final class QuranAyahLibraryStorage {
  static const _boxName = 'quran_ayah_library_v1';
  static const _highlightsKey = 'highlights';
  static const _cardsKey = 'cards';

  static Box<String>? _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box ??= await Hive.openBox<String>(_boxName);
  }

  static Future<List<SavedAyahHighlight>> readHighlights() async {
    return _readList(
      _highlightsKey,
      SavedAyahHighlight.fromJson,
    );
  }

  static Future<void> writeHighlights(List<SavedAyahHighlight> highlights) {
    return _writeList(_highlightsKey, highlights.map((e) => e.toJson()).toList());
  }

  static Future<List<SavedAyahCard>> readCards() async {
    return _readList(_cardsKey, SavedAyahCard.fromJson);
  }

  static Future<void> writeCards(List<SavedAyahCard> cards) {
    return _writeList(_cardsKey, cards.map((e) => e.toJson()).toList());
  }

  static List<T> _readList<T>(
    String key,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    final raw = _box?.get(key);
    if (raw == null) return [];

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((item) => fromJson(item as Map<String, dynamic>))
          .where((item) {
            if (item is SavedAyahHighlight) {
              return item.surahNumber > 0 && item.verseNumber > 0;
            }
            if (item is SavedAyahCard) {
              return item.surahNumber > 0 && item.verseNumbers.isNotEmpty;
            }
            return true;
          })
          .toList();
    } catch (_) {
      _box?.delete(key);
      return [];
    }
  }

  static Future<void> _writeList(String key, List<Map<String, dynamic>> data) {
    return _box?.put(key, jsonEncode(data)) ?? Future.value();
  }
}
