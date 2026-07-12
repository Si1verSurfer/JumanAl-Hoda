import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/goman_scaffold.dart';
import '../../../data/models/worship_item.dart';
import '../../providers/worship_provider.dart';
import '../../theme/worship_page_style.dart';
import '../../widgets/guides/guide_widgets.dart';
import '../../widgets/guides/rawatib_summary_table.dart';

class RawatibScreen extends ConsumerWidget {
  const RawatibScreen({super.key});

  static const categoryId = 'rawatib';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final category = ref.watch(worshipCategoryProvider(categoryId));
    final items = ref.watch(worshipItemsProvider(categoryId));
    final accent = category?.accentColor ?? AppColors.secondary;

    final grouped = <String, List<WorshipItem>>{};
    for (final item in items) {
      final key = item.metaString('prayerKey') ?? 'other';
      grouped.putIfAbsent(key, () => []).add(item);
    }

    const order = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha', 'other'];

    return GomanScaffold(
      title: category?.title ?? 'السنن الرواتب',
      body: Container(
        color: WorshipPageStyle.background(isDark),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          children: [
            RawatibSummaryTable(
              items: items,
              isDark: isDark,
              accentColor: accent,
            ),
            GuideHeroCard(
              isDark: isDark,
              icon: Icons.access_time_filled_rounded,
              title: 'السنن الرواتب',
              subtitle:
                  'السنن المؤكدة قبل وبعد الصلوات المفروضة — من هدي النبي ﷺ',
            ),
            for (final key in order)
              if (grouped.containsKey(key)) ...[
                GuideSectionHeader(
                  label: guidePrayerLabels[key] ?? 'عام',
                  accentColor: accent,
                ),
                for (var i = 0; i < grouped[key]!.length; i++)
                  GuideTimelineRow(
                    item: grouped[key]![i],
                    isDark: isDark,
                    accentColor: accent,
                    isLast: i == grouped[key]!.length - 1,
                  ),
              ],
          ],
        ),
      ),
    );
  }
}
