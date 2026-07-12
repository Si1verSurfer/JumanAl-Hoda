import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/goman_scaffold.dart';
import '../../providers/worship_provider.dart';
import '../../theme/worship_page_style.dart';
import '../../widgets/guides/guide_widgets.dart';

class DuaEtiquetteScreen extends ConsumerWidget {
  const DuaEtiquetteScreen({super.key});

  static const categoryId = 'dua_etiquette';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final category = ref.watch(worshipCategoryProvider(categoryId));
    final items = ref.watch(worshipItemsProvider(categoryId));
    final accent = category?.accentColor ?? AppColors.secondary;

    final sorted = [...items]
      ..sort(
        (a, b) =>
            (a.metaInt('stepNumber') ?? a.sortOrder)
                .compareTo(b.metaInt('stepNumber') ?? b.sortOrder),
      );

    return GomanScaffold(
      title: category?.title ?? 'آداب الدعاء',
      body: Container(
        color: WorshipPageStyle.background(isDark),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          children: [
            GuideHeroCard(
              isDark: isDark,
              icon: Icons.back_hand_rounded,
              title: 'آداب الدعاء',
              subtitle: 'كيف تدعو الله تعالى على الوجه الأكمل',
            ),
            Text(
              '${sorted.length} آداب من حصن المسلم',
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: accent.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 12),
            for (final item in sorted)
              GuideEtiquetteStepCard(
                item: item,
                isDark: isDark,
                accentColor: accent,
              ),
          ],
        ),
      ),
    );
  }
}
