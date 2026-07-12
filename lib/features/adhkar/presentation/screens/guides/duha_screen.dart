import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/goman_scaffold.dart';
import '../../providers/worship_provider.dart';
import '../../theme/worship_page_style.dart';
import '../../widgets/guides/guide_widgets.dart';

class DuhaScreen extends ConsumerWidget {
  const DuhaScreen({super.key});

  static const categoryId = 'duha';

  static IconData _iconFor(String? kind) => switch (kind) {
        'guide' => Icons.wb_twilight_rounded,
        'ritual' => Icons.self_improvement_rounded,
        'virtue' => Icons.auto_awesome_rounded,
        _ => Icons.nightlight_round,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final category = ref.watch(worshipCategoryProvider(categoryId));
    final items = ref.watch(worshipItemsProvider(categoryId));
    final accent = category?.accentColor ?? AppColors.secondary;

    return GomanScaffold(
      title: category?.title ?? 'صلاة الضحى',
      body: Container(
        color: WorshipPageStyle.background(isDark),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          children: [
            GuideHeroCard(
              isDark: isDark,
              icon: Icons.wb_sunny_rounded,
              title: 'صلاة الضحى',
              subtitle: 'صلاة الأوابين حين ترمض الفصال',
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFFF9A825), Color(0xFFE65100)],
              ),
            ),
            for (final item in items)
              GuideStepCard(
                item: item,
                isDark: isDark,
                accentColor: accent,
                icon: _iconFor(item.kind),
              ),
          ],
        ),
      ),
    );
  }
}
