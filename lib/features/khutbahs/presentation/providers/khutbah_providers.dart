import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/khutbah_index_loader.dart';
import '../../data/khutbah_models.dart';
import '../../data/khutbah_pdf_cache.dart';
import '../../data/khutbah_repository.dart';

final khutbahPdfCacheProvider = Provider<KhutbahPdfCache>((ref) {
  final cache = KhutbahPdfCache();
  ref.onDispose(cache.dispose);
  return cache;
});

final khutbahIndexProvider =
    FutureProvider<List<KhutbahIndexEntry>>((ref) async {
  return KhutbahIndexLoader.loadIndex();
});

final khutbahRepositoryProvider = Provider<KhutbahRepository?>((ref) {
  final index = ref.watch(khutbahIndexProvider).valueOrNull;
  if (index == null) return null;
  return KhutbahRepository(index);
});

final khutbahCategoriesProvider = Provider<List<KhutbahCategory>>((ref) {
  final repo = ref.watch(khutbahRepositoryProvider);
  if (repo == null) return const [];
  return repo.categories();
});

class KhutbahFilter {
  const KhutbahFilter({
    this.category,
    this.query = '',
  });

  final String? category;
  final String query;

  KhutbahFilter copyWith({
    String? category,
    bool clearCategory = false,
    String? query,
  }) {
    return KhutbahFilter(
      category: clearCategory ? null : (category ?? this.category),
      query: query ?? this.query,
    );
  }
}

class KhutbahFilterNotifier extends Notifier<KhutbahFilter> {
  @override
  KhutbahFilter build() => const KhutbahFilter();

  void setCategory(String? category) {
    state = state.copyWith(
      category: category,
      clearCategory: category == null,
    );
  }

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void clearFilters() {
    state = const KhutbahFilter();
  }
}

final khutbahFilterProvider =
    NotifierProvider<KhutbahFilterNotifier, KhutbahFilter>(
  KhutbahFilterNotifier.new,
);

final khutbahListProvider = Provider<List<KhutbahIndexEntry>>((ref) {
  final repo = ref.watch(khutbahRepositoryProvider);
  final filter = ref.watch(khutbahFilterProvider);
  if (repo == null) return const [];
  return repo.filter(category: filter.category, query: filter.query);
});
