import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/widgets/goman_scaffold.dart';
import '../../providers/worship_provider.dart';
import '../../theme/worship_page_style.dart';
import '../../widgets/qada_ramadan_widgets.dart';

class QadaRamadanScreen extends ConsumerWidget {
  const QadaRamadanScreen({super.key});

  static const categoryId = 'qada_ramadan';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final category = ref.watch(worshipCategoryProvider(categoryId));
    final items = ref.watch(worshipItemsProvider(categoryId));

    return GomanScaffold(
      title: category?.title ?? 'قضاء رمضان',
      body: Container(
        color: WorshipPageStyle.background(isDark),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          children: [
            QadaRamadanHeroCard(isDark: isDark),
            for (var i = 0; i < items.length; i++)
              QadaRamadanRuleTile(
                title: items[i].title,
                body: items[i].body,
                isDark: isDark,
                index: i,
              ),
          ],
        ),
      ),
    );
  }
}
