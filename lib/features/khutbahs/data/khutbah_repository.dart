import 'khutbah_constants.dart';
import 'khutbah_models.dart';

class KhutbahRepository {
  KhutbahRepository(List<KhutbahIndexEntry> entries)
      : _entries = _filterToAllowedCategories(
          entries.where(
            (entry) =>
                entry.hasPdf &&
                !KhutbahConstants.excludedCategories
                    .contains(entry.categoryText.trim()),
          ),
        );

  final List<KhutbahIndexEntry> _entries;

  static List<KhutbahIndexEntry> _filterToAllowedCategories(
    Iterable<KhutbahIndexEntry> entries,
  ) {
    final eligible = entries.toList(growable: false);
    final allowed = _topCategoryNames(eligible, KhutbahConstants.maxCategories);
    return eligible
        .where((entry) => allowed.contains(entry.categoryText.trim()))
        .toList(growable: false);
  }

  static Set<String> _topCategoryNames(
    List<KhutbahIndexEntry> entries,
    int limit,
  ) {
    final counts = <String, int>{};
    for (final entry in entries) {
      final name = entry.categoryText.trim();
      if (name.isEmpty) continue;
      counts[name] = (counts[name] ?? 0) + 1;
    }

    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(limit).map((e) => e.key).toSet();
  }

  List<KhutbahIndexEntry> get all => _entries;

  List<KhutbahCategory> categories() {
    final counts = <String, int>{};
    for (final entry in _entries) {
      final name = entry.categoryText.trim();
      if (name.isEmpty) continue;
      counts[name] = (counts[name] ?? 0) + 1;
    }
    final list = counts.entries
        .map((e) => KhutbahCategory(name: e.key, count: e.value))
        .toList()
      ..sort((a, b) => b.count.compareTo(a.count));
    return list;
  }

  KhutbahIndexEntry? byId(int id) {
    for (final entry in _entries) {
      if (entry.id == id) return entry;
    }
    return null;
  }

  List<KhutbahIndexEntry> filter({
    String? category,
    String? query,
  }) {
    final normalizedQuery = query?.trim().toLowerCase();
    final hasQuery = normalizedQuery != null && normalizedQuery.isNotEmpty;
    final hasCategory = category != null && category.isNotEmpty;

    Iterable<KhutbahIndexEntry> results = _entries;

    if (hasCategory) {
      results = results.where((e) => e.categoryText == category);
    }

    if (hasQuery) {
      results = results.where((e) {
        return e.title.toLowerCase().contains(normalizedQuery) ||
            e.authorName.toLowerCase().contains(normalizedQuery) ||
            e.categoryText.toLowerCase().contains(normalizedQuery);
      });
    }

    final list = results.toList(growable: false);
    list.sort((a, b) {
      final aDate = a.createdAt ?? '';
      final bDate = b.createdAt ?? '';
      return bDate.compareTo(aDate);
    });
    return list;
  }
}
