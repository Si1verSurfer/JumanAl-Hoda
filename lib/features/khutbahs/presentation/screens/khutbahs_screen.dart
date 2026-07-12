import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/constants/app_nav_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/platform_utils.dart';
import '../providers/khutbah_providers.dart';
import '../widgets/khutbah_back_button.dart';
import '../widgets/khutbah_category_grid.dart';
import '../widgets/khutbah_empty_state.dart';
import '../widgets/khutbah_list_tile.dart';
import '../widgets/khutbah_search_field.dart';

class KhutbahsScreen extends HookConsumerWidget {
  const KhutbahsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final indexAsync = ref.watch(khutbahIndexProvider);
    final categories = ref.watch(khutbahCategoriesProvider);
    final filter = ref.watch(khutbahFilterProvider);
    final entries = ref.watch(khutbahListProvider);
    final searchController = useTextEditingController(text: filter.query);
    final searchFocusNode = useFocusNode();

    final hasQuery = filter.query.trim().isNotEmpty;
    final hasCategory = filter.category != null && filter.category!.isNotEmpty;
    final showCategoryGrid = !hasQuery && !hasCategory;

    useEffect(() {
      if (searchFocusNode.hasFocus) {
        return null;
      }
      if (searchController.text != filter.query) {
        searchController.text = filter.query;
      }
      return null;
    }, [filter.query]);

    void clearFilters() {
      searchFocusNode.unfocus();
      if (searchController.text.isNotEmpty) {
        searchController.clear();
      }
      ref.read(khutbahFilterProvider.notifier).clearFilters();
    }

    final bottomPadding = PlatformUtils.isIOS
        ? AppNavConstants.floatingBottomPadding(context)
        : 24.0;
    final background =
        isDark ? AppColors.surfaceDark : AppColors.surfaceLight;

    return PopScope(
      canPop: showCategoryGrid,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !showCategoryGrid) {
          clearFilters();
        }
      },
      child: ColoredBox(
        color: background,
        child: SafeArea(
          bottom: false,
          child: indexAsync.when(
          loading: () => KhutbahEmptyState(isDark: isDark, loading: true),
          error: (error, stackTrace) => KhutbahEmptyState(isDark: isDark),
          data: (_) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Text(
                      AppStrings.khutbahs,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.notoNaskhArabic(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? AppColors.surfaceLight
                            : AppColors.primary,
                      ),
                    ),
                  ),
                ),
                if (!showCategoryGrid)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: KhutbahBackButton(
                        isDark: isDark,
                        label: AppStrings.khutbahsAllCategories,
                        onPressed: clearFilters,
                      ),
                    ),
                  ),
                if (hasCategory)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                      child: Text(
                        filter.category!,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.tajawal(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      showCategoryGrid ? 14 : 8,
                      20,
                      12,
                    ),
                    child: KhutbahSearchField(
                      controller: searchController,
                      isDark: isDark,
                      focusNode: searchFocusNode,
                      onQueryChanged: (value) => ref
                          .read(khutbahFilterProvider.notifier)
                          .setQuery(value),
                    ),
                  ),
                ),
                if (showCategoryGrid)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                      child: Text(
                        AppStrings.khutbahsBrowseCategories,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.tajawal(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.mutedOnCard(isDark),
                        ),
                      ),
                    ),
                  ),
                if (showCategoryGrid)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                      child: KhutbahCategoryGrid(
                        categories: categories,
                        isDark: isDark,
                        onCategoryTap: (category) {
                          ref
                              .read(khutbahFilterProvider.notifier)
                              .setCategory(category.name);
                        },
                      ),
                    ),
                  )
                else if (entries.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: KhutbahEmptyState(isDark: isDark),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final entry = entries[index];
                        return KhutbahListTile(
                          entry: entry,
                          isDark: isDark,
                          showCategory: !hasCategory,
                          onTap: () => context.push(
                            '${Routes.khutbahs}/pdf/${entry.id}',
                          ),
                        );
                      },
                      childCount: entries.length,
                    ),
                  ),
                SliverToBoxAdapter(child: SizedBox(height: bottomPadding)),
              ],
            );
          },
        ),
      ),
    ),
    );
  }
}
