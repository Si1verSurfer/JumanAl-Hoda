import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/worship_category.dart';
import '../../data/models/worship_item.dart';
import '../../data/worship_database.dart';
import '../../data/worship_repository.dart';

final worshipRepositoryProvider = Provider<WorshipRepository>(
  (ref) => WorshipRepository(),
);

final worshipCategoriesProvider = Provider<List<WorshipCategory>>((ref) {
  return ref.watch(worshipRepositoryProvider).getCategories();
});

final worshipGuideCategoriesProvider = Provider<List<WorshipCategory>>((ref) {
  return ref
      .watch(worshipCategoriesProvider)
      .where((c) => c.isGuide)
      .toList();
});

final worshipMainCategoriesProvider = Provider<List<WorshipCategory>>((ref) {
  return ref
      .watch(worshipCategoriesProvider)
      .where((c) => !c.isGuide)
      .toList();
});

final worshipFavoritesProvider =
    StateNotifierProvider<WorshipFavoritesNotifier, Set<String>>(
  (ref) => WorshipFavoritesNotifier(ref),
);

class WorshipFavoritesNotifier extends StateNotifier<Set<String>> {
  WorshipFavoritesNotifier(this._ref)
      : super(WorshipDatabase.readFavoriteIds().toSet());

  final Ref _ref;

  WorshipRepository get _repository => _ref.read(worshipRepositoryProvider);

  Future<void> toggle(String itemId) async {
    await _repository.toggleFavorite(itemId);
    state = _repository.getFavoriteItems().map((e) => e.id).toSet();
  }

  bool contains(String itemId) => state.contains(itemId);
}

final worshipCategoryProvider =
    Provider.family<WorshipCategory?, String>((ref, id) {
  return ref.watch(worshipRepositoryProvider).getCategory(id);
});

final worshipItemsProvider =
    Provider.family<List<WorshipItem>, String>((ref, categoryId) {
  ref.watch(worshipFavoritesProvider);
  return ref.watch(worshipRepositoryProvider).getItemsForCategory(categoryId);
});
