import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/quran_tafseer_books.dart';

const _selectedBookSlugKey = 'quran_tafseer_book_slug';

final quranTafseerBookProvider =
    StateNotifierProvider<QuranTafseerBookNotifier, TafseerBook>(
  (ref) => QuranTafseerBookNotifier(),
);

class QuranTafseerBookNotifier extends StateNotifier<TafseerBook> {
  QuranTafseerBookNotifier() : super(quranArabicTafseerBooks.first) {
    _restoreSelection();
  }

  Future<void> _restoreSelection() async {
    final prefs = await SharedPreferences.getInstance();
    final slug = prefs.getString(_selectedBookSlugKey);
    if (slug == null) return;

    state = tafseerBookBySlug(slug);
  }

  Future<void> select(TafseerBook book) async {
    state = book;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedBookSlugKey, book.slug);
  }
}
