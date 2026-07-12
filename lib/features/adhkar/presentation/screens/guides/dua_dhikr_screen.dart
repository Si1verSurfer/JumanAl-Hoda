import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/goman_scaffold.dart';
import '../../../../../core/widgets/goman_search_field.dart';
import '../../../data/models/worship_item.dart';
import '../../providers/worship_provider.dart';
import '../../theme/worship_page_style.dart';
import '../../widgets/guides/guide_widgets.dart';

class DuaDhikrScreen extends HookConsumerWidget {
  const DuaDhikrScreen({super.key});

  static const categoryId = 'dua_dhikr';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final category = ref.watch(worshipCategoryProvider(categoryId));
    final allItems = ref.watch(worshipItemsProvider(categoryId));
    final accent = category?.accentColor ?? AppColors.secondary;
    final tabController = useTabController(initialLength: 2);
    final searchController = useTextEditingController();
    final query = useState('');

    useEffect(() {
      void listener() => query.value = searchController.text;
      searchController.addListener(listener);
      return () => searchController.removeListener(listener);
    }, [searchController]);

    List<WorshipItem> filtered(String tab) {
      final q = query.value.trim();
      return allItems.where((item) {
        if (item.metaString('tab') != tab) return false;
        if (q.isEmpty) return true;
        return item.title.contains(q) ||
            item.body.contains(q) ||
            (item.reference?.contains(q) ?? false);
      }).toList();
    }

    final duas = filtered('dua');
    final adhkar = filtered('dhikr');

    return GomanScaffold(
      title: category?.title ?? 'الدعاء والذكر',
      body: Container(
        color: WorshipPageStyle.background(isDark),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: GomanSearchField(
                controller: searchController,
                isDark: isDark,
                hintText: 'ابحث في الأدعية والأذكار...',
              ),
            ),
            TabBar(
              controller: tabController,
              labelStyle: GoogleFonts.tajawal(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              tabs: [
                Tab(text: 'أدعية (${duas.length})'),
                Tab(text: 'أذكار (${adhkar.length})'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  _TabList(
                    items: duas,
                    isDark: isDark,
                    accent: accent,
                    emptyLabel: 'لا توجد أدعية',
                  ),
                  _TabList(
                    items: adhkar,
                    isDark: isDark,
                    accent: accent,
                    emptyLabel: 'لا توجد أذكار',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabList extends ConsumerWidget {
  const _TabList({
    required this.items,
    required this.isDark,
    required this.accent,
    required this.emptyLabel,
  });

  final List<WorshipItem> items;
  final bool isDark;
  final Color accent;
  final String emptyLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          emptyLabel,
          style: GoogleFonts.tajawal(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.secondary.withValues(alpha: 0.6),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      itemCount: items.length,
      itemBuilder: (context, index) => GuideDuaCard(
        item: items[index],
        isDark: isDark,
        accentColor: accent,
      ),
    );
  }
}
