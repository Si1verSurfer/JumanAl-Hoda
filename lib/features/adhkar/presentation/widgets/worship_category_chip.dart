import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/haptics/goman_haptics.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/goman_ink_well.dart';
import '../../data/models/worship_category.dart';

class WorshipCategoryChip extends StatelessWidget {
  const WorshipCategoryChip({
    super.key,
    required this.category,
    required this.isDark,
    required this.onTap,
    this.expanded = true,
  });

  final WorshipCategory category;
  final bool isDark;
  final VoidCallback onTap;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final accent = category.accentColor;
    final chip = GomanInkWell(
      onTap: onTap,
      haptic: GomanHapticKind.tap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.chipSurface(isDark, accent: accent),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.chipBorder(accent, isDark),
            width: 1.1,
          ),
          boxShadow: AppColors.cardShadow(isDark: isDark),
        ),
        alignment: Alignment.center,
        child: Text(
          category.title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.tajawal(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            height: 1.2,
            color: AppColors.accentOnSurface(accent, isDark),
          ),
        ),
      ),
    );

    if (!expanded) return chip;
    return Expanded(child: chip);
  }
}

class WorshipCategoryGrid extends StatelessWidget {
  const WorshipCategoryGrid({
    super.key,
    required this.categories,
    required this.isDark,
    required this.onCategoryTap,
  });

  final List<WorshipCategory> categories;
  final bool isDark;
  final ValueChanged<WorshipCategory> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];

    for (var i = 0; i < categories.length; i++) {
      final category = categories[i];
      if (category.fullWidth) {
        rows.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: WorshipCategoryChip(
              category: category,
              isDark: isDark,
              expanded: false,
              onTap: () => onCategoryTap(category),
            ),
          ),
        );
        continue;
      }

      final next = i + 1 < categories.length ? categories[i + 1] : null;
      if (next != null && !next.fullWidth) {
        rows.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                WorshipCategoryChip(
                  category: category,
                  isDark: isDark,
                  onTap: () => onCategoryTap(category),
                ),
                const SizedBox(width: 10),
                WorshipCategoryChip(
                  category: next,
                  isDark: isDark,
                  onTap: () => onCategoryTap(next),
                ),
              ],
            ),
          ),
        );
        i++;
      } else {
        rows.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: WorshipCategoryChip(
              category: category,
              isDark: isDark,
              expanded: false,
              onTap: () => onCategoryTap(category),
            ),
          ),
        );
      }
    }

    return Column(children: rows);
  }
}

/// Home guide block — same layout as [WorshipCategoryGrid] for `guides` group.
class WorshipGuidesGrid extends StatelessWidget {
  const WorshipGuidesGrid({
    super.key,
    required this.categories,
    required this.isDark,
    required this.onCategoryTap,
  });

  final List<WorshipCategory> categories;
  final bool isDark;
  final ValueChanged<WorshipCategory> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return WorshipCategoryGrid(
      categories: categories,
      isDark: isDark,
      onCategoryTap: onCategoryTap,
    );
  }
}
