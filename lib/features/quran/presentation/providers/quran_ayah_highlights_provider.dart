import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/ayah_highlight.dart';
import '../../data/quran_ayah_library_storage.dart';

final quranAyahHighlightsProvider =
    StateNotifierProvider<QuranAyahHighlightsNotifier, List<SavedAyahHighlight>>(
  (ref) => QuranAyahHighlightsNotifier(),
);

class QuranAyahHighlightsNotifier extends StateNotifier<List<SavedAyahHighlight>> {
  QuranAyahHighlightsNotifier() : super(const []) {
    _restore();
  }

  Future<void> _restore() async {
    state = await QuranAyahLibraryStorage.readHighlights();
  }

  SavedAyahHighlight? highlightFor(int surahNumber, int verseNumber) {
    final key = '$surahNumber:$verseNumber';
    for (final entry in state) {
      if (entry.key == key) return entry;
    }
    return null;
  }

  Future<void> setHighlight({
    required int surahNumber,
    required int verseNumber,
    required AyahHighlightColor color,
  }) async {
    final key = '$surahNumber:$verseNumber';
    final next = [
      ...state.where((entry) => entry.key != key),
      SavedAyahHighlight(
        surahNumber: surahNumber,
        verseNumber: verseNumber,
        color: color,
        savedAt: DateTime.now().millisecondsSinceEpoch,
      ),
    ]..sort((a, b) => b.savedAt.compareTo(a.savedAt));

    state = next;
    await QuranAyahLibraryStorage.writeHighlights(next);
  }

  Future<void> removeHighlight({
    required int surahNumber,
    required int verseNumber,
  }) async {
    final key = '$surahNumber:$verseNumber';
    final next = state.where((entry) => entry.key != key).toList();
    state = next;
    await QuranAyahLibraryStorage.writeHighlights(next);
  }

  Future<void> toggleHighlight({
    required int surahNumber,
    required int verseNumber,
    required AyahHighlightColor color,
  }) async {
    final existing = highlightFor(surahNumber, verseNumber);
    if (existing?.color == color) {
      await removeHighlight(surahNumber: surahNumber, verseNumber: verseNumber);
      return;
    }

    await setHighlight(
      surahNumber: surahNumber,
      verseNumber: verseNumber,
      color: color,
    );
  }
}
