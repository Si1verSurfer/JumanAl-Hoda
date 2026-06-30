import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qcf_quran/qcf_quran.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/quran_last_reading.dart';

const _prefsKey = 'quran_last_reading_v1';

final quranLastReadingProvider =
    StateNotifierProvider<QuranLastReadingNotifier, QuranLastReading>(
  (ref) => QuranLastReadingNotifier(),
);

/// Last mushaf page (legacy) — mirrors [quranLastReadingProvider].
final quranLastPageProvider = Provider<int>(
  (ref) => ref.watch(quranLastReadingProvider).page,
);

class QuranLastReadingNotifier extends StateNotifier<QuranLastReading> {
  QuranLastReadingNotifier()
      : super(
          const QuranLastReading(
            page: 1,
            surahNumber: 1,
            verseNumber: 1,
          ),
        ) {
    _restore();
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      state = QuranLastReading.fromJson(json);
    } catch (_) {
      await prefs.remove(_prefsKey);
    }
  }

  Future<void> updateFromPage(int pageNumber) async {
    final page = pageNumber.clamp(1, totalPagesCount);
    final (surah, verse) = getPrimaryAyahForPage(page);
    await _persist(
      QuranLastReading(
        page: page,
        surahNumber: surah,
        verseNumber: verse,
        readAt: DateTime.now(),
      ),
    );
  }

  Future<void> updatePosition({
    required int page,
    required int surahNumber,
    required int verseNumber,
  }) async {
    await _persist(
      QuranLastReading(
        page: page.clamp(1, totalPagesCount),
        surahNumber: surahNumber,
        verseNumber: verseNumber,
        readAt: DateTime.now(),
      ),
    );
  }

  Future<void> _persist(QuranLastReading next) async {
    state = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(next.toJson()));
  }
}
