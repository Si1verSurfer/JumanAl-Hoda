import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/haptics/goman_haptics.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/khutbah_models.dart';
import '../theme/khutbah_page_style.dart';

class KhutbahCategoryGrid extends StatelessWidget {
  const KhutbahCategoryGrid({
    super.key,
    required this.categories,
    required this.isDark,
    required this.onCategoryTap,
  });

  final List<KhutbahCategory> categories;
  final bool isDark;
  final ValueChanged<KhutbahCategory> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];

    for (var i = 0; i < categories.length; i += 2) {
      final left = categories[i];
      final right = i + 1 < categories.length ? categories[i + 1] : null;

      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Expanded(
                child: KhutbahCategoryTile(
                  category: left,
                  isDark: isDark,
                  onTap: () => onCategoryTap(left),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: right == null
                    ? const SizedBox.shrink()
                    : KhutbahCategoryTile(
                        category: right,
                        isDark: isDark,
                        onTap: () => onCategoryTap(right),
                      ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(children: rows);
  }
}

class KhutbahCategoryTile extends StatelessWidget {
  const KhutbahCategoryTile({
    super.key,
    required this.category,
    required this.isDark,
    required this.onTap,
  });

  final KhutbahCategory category;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? AppColors.surfaceLight : AppColors.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: KhutbahPageStyle.floatShadow(isDark: isDark),
      ),
      child: Material(
        color: AppColors.cardSurface(isDark),
        elevation: 0,
        shadowColor: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            GomanHaptics.tap();
            onTap();
          },
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: KhutbahPageStyle.border(isDark: isDark),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  AppColors.secondary.withValues(alpha: isDark ? 0.10 : 0.05),
                  Colors.transparent,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.tajawal(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary
                          .withValues(alpha: isDark ? 0.16 : 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${category.count} خطبة',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tajawal(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
