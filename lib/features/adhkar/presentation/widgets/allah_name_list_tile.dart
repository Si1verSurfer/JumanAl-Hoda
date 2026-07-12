import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/goman_ink_well.dart';
import '../../data/models/worship_item.dart';

class AllahNameListTile extends StatelessWidget {
  const AllahNameListTile({
    super.key,
    required this.item,
    required this.index,
    required this.isDark,
    required this.onTap,
  });

  final WorshipItem item;
  final int index;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? AppColors.surfaceLight : AppColors.primary;
    final metaColor = titleColor.withValues(alpha: 0.55);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.allahNameCardShadow(isDark: isDark),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
        color: AppColors.cardSurface(isDark),
            child: GomanInkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Ink(
                decoration: BoxDecoration(
              color: AppColors.cardSurface(isDark),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withValues(
                      alpha: isDark ? 0.12 : 0.04,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
                  child: Row(
                    children: [
                      _IndexBadge(
                        label: item.repeatHint ?? '${index + 1}',
                        isDark: isDark,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              item.title,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.notoNaskhArabic(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                                color: titleColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.body,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.tajawal(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                height: 1.35,
                                color: metaColor,
                              ),
                            ),
                            if (item.quranReference != null) ...[
                              const SizedBox(height: 6),
                              Center(
                                child: _MetaChip(
                                  icon: Icons.menu_book_rounded,
                                  label: 'من القرآن',
                                  isDark: isDark,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _TrailingIcon(isDark: isDark),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TrailingIcon extends StatelessWidget {
  const _TrailingIcon({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: isDark ? 0.22 : 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.auto_stories_rounded,
        size: 17,
        color: AppColors.secondary.withValues(alpha: 0.9),
      ),
    );
  }
}

class _IndexBadge extends StatelessWidget {
  const _IndexBadge({
    required this.label,
    required this.isDark,
  });

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: AppColors.primaryBrandGradient,
        borderRadius: BorderRadius.circular(11),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: GoogleFonts.tajawal(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: AppColors.onPrimary,
          height: 1,
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: isDark ? 0.22 : 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.secondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.tajawal(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
