import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/goman_navigation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/goman_scaffold.dart';
import '../../../../core/widgets/goman_search_field.dart';
import '../../data/models/worship_item.dart';
import '../providers/worship_provider.dart';
import '../screens/allah_name_detail_screen.dart';
import '../widgets/allah_name_list_tile.dart';

class AllahNamesScreen extends ConsumerStatefulWidget {
  const AllahNamesScreen({super.key});

  static const categoryId = 'allah_names';
  static const nameCount = 99;

  static String get route => '/adhkar/category/$categoryId';

  @override
  ConsumerState<AllahNamesScreen> createState() => _AllahNamesScreenState();
}

class _AllahNamesScreenState extends ConsumerState<AllahNamesScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<WorshipItem> _filter(List<WorshipItem> items) {
    final q = _query.trim();
    if (q.isEmpty) return items;
    return items.where((item) {
      return item.title.contains(q) ||
          item.body.contains(q) ||
          (item.repeatHint?.contains(q) ?? false) ||
          (item.quranReference?.contains(q) ?? false) ||
          (item.benefit?.contains(q) ?? false) ||
          (item.invocation?.contains(q) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageColor = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final allItems = ref.watch(worshipItemsProvider(AllahNamesScreen.categoryId));
    final items = _filter(allItems);

    return GomanScaffold(
      title: 'أسماء الله الحسنى',
      body: Container(
        color: pageColor,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                child: _IntroCard(isDark: isDark),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickySearchDelegate(
                backgroundColor: pageColor,
                child: GomanSearchField(
                  controller: _searchController,
                  isDark: isDark,
                  onChanged: (value) => setState(() => _query = value),
                  hintText: 'ابحث بالاسم أو المعنى أو الآية...',
                ),
              ),
            ),
            if (items.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    'لا توجد نتائج لـ «$_query»',
                    style: GoogleFonts.tajawal(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = items[index];
                      final originalIndex = allItems.indexOf(item);
                      return AllahNameListTile(
                        item: item,
                        index: originalIndex >= 0 ? originalIndex : index,
                        isDark: isDark,
                        onTap: () => context.pushAnimated(
                          AllahNameDetailScreen.routeFor(item.id),
                          haptic: null,
                        ),
                      );
                    },
                    childCount: items.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StickySearchDelegate extends SliverPersistentHeaderDelegate {
  const _StickySearchDelegate({
    required this.backgroundColor,
    required this.child,
  });

  final Color backgroundColor;
  final Widget child;

  static const _height = 60.0;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _StickySearchDelegate oldDelegate) {
    return backgroundColor != oldDelegate.backgroundColor ||
        child != oldDelegate.child;
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryBrandGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.cardShadow(isDark: isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _StatPill(label: '${AllahNamesScreen.nameCount} اسماً'),
              const Spacer(),
              _StatPill(label: 'من القرآن والسنة'),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'مَنْ أَحْصَاهَا دَخَلَ الْجَنَّةَ',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoNaskhArabic(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 1.5,
              color: AppColors.onPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'لكل اسم معنى، وآية من القرآن، وفضل، ودعاء — اضغط على أي اسم لعرض التفاصيل.',
            textAlign: TextAlign.center,
            style: GoogleFonts.tajawal(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.45,
              color: AppColors.onPrimary.withValues(alpha: 0.78),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: GoogleFonts.tajawal(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.onPrimary,
        ),
      ),
    );
  }
}
