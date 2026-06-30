import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/quran_tafseer_api.dart';
import 'quran_tafseer_repository_provider.dart';

@immutable
class AyahTafseerRequest {
  const AyahTafseerRequest({
    required this.surahNumber,
    required this.verseNumber,
    required this.bookSlug,
  });

  final int surahNumber;
  final int verseNumber;
  final String bookSlug;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AyahTafseerRequest &&
            surahNumber == other.surahNumber &&
            verseNumber == other.verseNumber &&
            bookSlug == other.bookSlug;
  }

  @override
  int get hashCode => Object.hash(surahNumber, verseNumber, bookSlug);
}

/// Loads ayah tafseer for a specific book. Each [bookSlug] is cached separately.
final ayahTafseerProvider = FutureProvider.autoDispose
    .family<AyahTafseer, AyahTafseerRequest>((ref, request) {
  return ref.read(quranTafseerRepositoryProvider).getAyahTafseer(
        surahNumber: request.surahNumber,
        verseNumber: request.verseNumber,
        tafsirSlug: request.bookSlug,
      );
});
