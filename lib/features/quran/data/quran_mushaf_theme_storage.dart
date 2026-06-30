import 'package:shared_preferences/shared_preferences.dart';

import 'models/quran_mushaf_theme.dart';

const _storageKey = 'quran_mushaf_theme_v1';

class QuranMushafThemeStorage {
  Future<QuranMushafTheme> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) return QuranMushafTheme.classic;
    return QuranMushafTheme.values.firstWhere(
      (theme) => theme.name == raw,
      orElse: () => QuranMushafTheme.classic,
    );
  }

  Future<void> save(QuranMushafTheme theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, theme.name);
  }
}
