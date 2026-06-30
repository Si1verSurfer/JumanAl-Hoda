import 'quran_tafseer_api.dart';
import 'quran_tafseer_cache.dart';

/// Fetches ayah tafseer once per book/ayah and reuses memory + local storage.
class QuranTafseerRepository {
  QuranTafseerRepository();

  final Map<String, AyahTafseer> _memory = {};

  String _key({
    required String tafsirSlug,
    required int surahNumber,
    required int verseNumber,
  }) {
    return QuranTafseerCache.cacheKey(
      bookSlug: tafsirSlug,
      surahNumber: surahNumber,
      verseNumber: verseNumber,
    );
  }

  /// Returns a cached entry synchronously when available (memory or disk).
  AyahTafseer? peekCached({
    required int surahNumber,
    required int verseNumber,
    required String tafsirSlug,
  }) {
    final key = _key(
      tafsirSlug: tafsirSlug,
      surahNumber: surahNumber,
      verseNumber: verseNumber,
    );

    final inMemory = _memory[key];
    if (inMemory != null) return inMemory;

    final onDisk = QuranTafseerCache.read(
      key,
      expectedBookSlug: tafsirSlug,
    );
    if (onDisk != null) {
      _memory[key] = onDisk;
      return onDisk;
    }

    return null;
  }

  Future<AyahTafseer> getAyahTafseer({
    required int surahNumber,
    required int verseNumber,
    required String tafsirSlug,
    bool forceRefresh = false,
  }) async {
    final key = _key(
      tafsirSlug: tafsirSlug,
      surahNumber: surahNumber,
      verseNumber: verseNumber,
    );

    if (!forceRefresh) {
      final cached = peekCached(
        surahNumber: surahNumber,
        verseNumber: verseNumber,
        tafsirSlug: tafsirSlug,
      );
      if (cached != null) return cached;
    }

    final remote = await QuranTafseerApi.fetchAyahTafseer(
      surahNumber: surahNumber,
      verseNumber: verseNumber,
      tafsirSlug: tafsirSlug,
    );

    final stored = remote.copyWith(cachedAt: DateTime.now().millisecondsSinceEpoch);
    _memory[key] = stored;
    await QuranTafseerCache.write(key, stored);
    return stored;
  }
}
