import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../data/models/quran_mushaf_theme.dart';
import '../../data/quran_mushaf_theme_storage.dart';
import '../theme/quran_qcf_theme.dart';

final quranMushafThemeStorageProvider = Provider<QuranMushafThemeStorage>(
  (ref) => QuranMushafThemeStorage(),
);

final quranMushafThemeProvider =
    StateNotifierProvider<QuranMushafThemeNotifier, QuranMushafTheme>(
  (ref) => QuranMushafThemeNotifier(ref),
);

final quranMushafQcfThemeProvider = Provider<QcfThemeData>((ref) {
  final theme = ref.watch(quranMushafThemeProvider);
  return QuranQcfTheme.forMushafTheme(theme);
});

class QuranMushafThemeNotifier extends StateNotifier<QuranMushafTheme> {
  QuranMushafThemeNotifier(this._ref) : super(QuranMushafTheme.classic) {
    _load();
  }

  final Ref _ref;

  Future<void> _load() async {
    final storage = _ref.read(quranMushafThemeStorageProvider);
    state = await storage.load();
  }

  Future<void> setTheme(QuranMushafTheme theme) async {
    state = theme;
    await _ref.read(quranMushafThemeStorageProvider).save(theme);
  }
}
