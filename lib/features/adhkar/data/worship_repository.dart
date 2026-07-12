import 'models/worship_category.dart';
import 'models/worship_item.dart';
import 'worship_database.dart';

class WorshipRepository {
  List<WorshipCategory> getCategories() => WorshipDatabase.readCategories();

  WorshipCategory? getCategory(String id) {
    for (final category in getCategories()) {
      if (category.id == id) return category;
    }
    return null;
  }

  List<WorshipItem> getItemsForCategory(String categoryId) {
    if (categoryId == 'my_adhkar') {
      return getFavoriteItems();
    }

    return WorshipDatabase.readItems()
        .where((item) => item.categoryId == categoryId)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  List<WorshipItem> getAllItems() => WorshipDatabase.readItems();

  List<WorshipItem> getFavoriteItems() {
    final favoriteIds = WorshipDatabase.readFavoriteIds().toSet();
    return WorshipDatabase.readItems()
        .where((item) => favoriteIds.contains(item.id))
        .toList()
      ..sort((a, b) => a.title.compareTo(b.title));
  }

  bool isFavorite(String itemId) {
    return WorshipDatabase.readFavoriteIds().contains(itemId);
  }

  Future<bool> toggleFavorite(String itemId) async {
    final favorites = WorshipDatabase.readFavoriteIds();
    final isFavorite = favorites.contains(itemId);
    if (isFavorite) {
      favorites.remove(itemId);
    } else {
      favorites.add(itemId);
    }
    await WorshipDatabase.writeFavoriteIds(favorites);
    return !isFavorite;
  }
}
