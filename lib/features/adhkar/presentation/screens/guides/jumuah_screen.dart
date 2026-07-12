import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/goman_scaffold.dart';
import '../../providers/worship_provider.dart';
import '../../theme/worship_page_style.dart';
import '../../widgets/guides/guide_widgets.dart';

class JumuahScreen extends ConsumerWidget {
  const JumuahScreen({super.key});

  static const categoryId = 'jumuah';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final category = ref.watch(worshipCategoryProvider(categoryId));
    final items = ref.watch(worshipItemsProvider(categoryId));
    final accent = category?.accentColor ?? AppColors.secondary;

    final checklists =
        items.where((e) => e.kind == 'checklist' || e.kind == 'virtue');
    final duas = items.where((e) => e.kind == 'dua');

    return GomanScaffold(
      title: category?.title ?? 'الجمعة',
      body: Container(
        color: WorshipPageStyle.background(isDark),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          children: [
            GuideHeroCard(
              isDark: isDark,
              icon: Icons.mosque_rounded,
              title: 'يوم الجمعة',
              subtitle: 'فضائل يوم الجمعة وسننه وأعماله المستحبة',
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  AppColors.secondary,
                  AppColors.secondary.withValues(alpha: 0.85),
                  const Color(0xFF1B5E20),
                ],
              ),
            ),
            GuideSectionHeader(label: 'سنن وأعمال الجمعة', accentColor: accent),
            for (final item in checklists)
              GuideChecklistTile(
                item: item,
                isDark: isDark,
                accentColor: accent,
              ),
            if (duas.isNotEmpty) ...[
              GuideSectionHeader(label: 'أدعية الجمعة', accentColor: accent),
              for (final item in duas)
                GuideDuaCard(
                  item: item,
                  isDark: isDark,
                  accentColor: accent,
                ),
            ],
          ],
        ),
      ),
    );
  }
}
