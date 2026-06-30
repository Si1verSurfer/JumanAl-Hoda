import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/ayah_card.dart';
import '../../data/quran_ayah_card_image_service.dart';
import '../../data/quran_ayah_library_storage.dart';

final quranAyahCardsProvider =
    StateNotifierProvider<QuranAyahCardsNotifier, List<SavedAyahCard>>(
  (ref) => QuranAyahCardsNotifier(),
);

class QuranAyahCardsNotifier extends StateNotifier<List<SavedAyahCard>> {
  QuranAyahCardsNotifier() : super(const []) {
    _restore();
  }

  final Set<String> _generatingIds = {};

  Future<void> _restore() async {
    final cards = await QuranAyahLibraryStorage.readCards();
    var migrated = false;

    state = cards.map((card) {
      final path = card.imagePath;
      if (path != null && !path.contains('_v3.png')) {
        migrated = true;
        QuranAyahCardImageService.deleteIfExists(path);
        return card.copyWith(clearImagePath: true);
      }
      return card;
    }).toList();

    if (migrated) {
      await QuranAyahLibraryStorage.writeCards(state);
    }
  }

  SavedAyahCard? cardContainingVerse(int surahNumber, int verseNumber) {
    for (final card in state) {
      if (card.surahNumber == surahNumber && card.containsVerse(verseNumber)) {
        return card;
      }
    }
    return null;
  }

  SavedAyahCard? latestIncompleteCard(int surahNumber) {
    for (final card in state) {
      if (card.surahNumber == surahNumber && !card.isFull) {
        return card;
      }
    }
    return null;
  }

  bool isGenerating(String cardId) => _generatingIds.contains(cardId);

  Future<void> toggleVerseInCard({
    required BuildContext context,
    required int surahNumber,
    required int verseNumber,
  }) async {
    final existing = cardContainingVerse(surahNumber, verseNumber);
    if (existing != null) {
      await _removeVerseFromCard(context, existing, verseNumber);
      return;
    }

    final target = latestIncompleteCard(surahNumber);
    if (target != null) {
      final verses = [...target.verseNumbers, verseNumber]..sort();
      await _updateCardVerses(context, target, verses);
      return;
    }

    await _createCard(context, surahNumber, [verseNumber]);
  }

  Future<void> _createCard(
    BuildContext context,
    int surahNumber,
    List<int> verseNumbers,
  ) async {
    final card = SavedAyahCard(
      id: '${DateTime.now().millisecondsSinceEpoch}_$surahNumber',
      surahNumber: surahNumber,
      verseNumbers: verseNumbers,
      savedAt: DateTime.now().millisecondsSinceEpoch,
    );

    final next = [card, ...state];
    state = next;
    await QuranAyahLibraryStorage.writeCards(next);

    if (!context.mounted) return;
    await generateImageForCard(context: context, card: card);
  }

  Future<void> _updateCardVerses(
    BuildContext context,
    SavedAyahCard card,
    List<int> verseNumbers,
  ) async {
    if (card.imagePath != null) {
      await QuranAyahCardImageService.deleteIfExists(card.imagePath);
    }

    final updated = card.copyWith(
      verseNumbers: verseNumbers,
      clearImagePath: true,
    );
    final next =
        state.map((entry) => entry.id == card.id ? updated : entry).toList();
    state = next;
    await QuranAyahLibraryStorage.writeCards(next);

    if (!context.mounted) return;
    await generateImageForCard(context: context, card: updated);
  }

  Future<void> _removeVerseFromCard(
    BuildContext context,
    SavedAyahCard card,
    int verseNumber,
  ) async {
    final verses = card.verseNumbers.where((v) => v != verseNumber).toList();
    if (verses.isEmpty) {
      await removeCard(card.id);
      return;
    }
    await _updateCardVerses(context, card, verses);
  }

  Future<void> generateImageForCard({
    required BuildContext context,
    required SavedAyahCard card,
  }) async {
    if (_generatingIds.contains(card.id)) return;

    _generatingIds.add(card.id);
    state = [...state];

    try {
      final imagePath = await QuranAyahCardImageService.captureAndSave(
        context: context,
        card: card,
      );
      if (imagePath == null) return;

      SavedAyahCard? existing;
      for (final entry in state) {
        if (entry.id == card.id) {
          existing = entry;
          break;
        }
      }
      if (existing == null) return;

      if (existing.imagePath != null && existing.imagePath != imagePath) {
        await QuranAyahCardImageService.deleteIfExists(existing.imagePath);
      }

      final updated = existing.copyWith(imagePath: imagePath);
      final next =
          state.map((entry) => entry.id == card.id ? updated : entry).toList();
      state = next;
      await QuranAyahLibraryStorage.writeCards(next);
    } finally {
      _generatingIds.remove(card.id);
      state = [...state];
    }
  }

  Future<void> removeCard(String cardId) async {
    SavedAyahCard? removed;
    for (final entry in state) {
      if (entry.id == cardId) {
        removed = entry;
        break;
      }
    }
    final next = state.where((entry) => entry.id != cardId).toList();
    state = next;
    await QuranAyahLibraryStorage.writeCards(next);
    await QuranAyahCardImageService.deleteIfExists(removed?.imagePath);
  }
}
