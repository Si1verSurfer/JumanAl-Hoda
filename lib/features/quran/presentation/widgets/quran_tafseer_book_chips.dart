import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/quran_tafseer_books.dart';

abstract final class QuranTafseerChipStyles {
  static TextStyle label({
    required bool selected,
    required bool isDark,
  }) {
    return GoogleFonts.tajawal(
      fontSize: 13,
      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
      height: 1.25,
      color: selected
          ? (isDark ? AppColors.surfaceLight : AppColors.primary)
          : (isDark ? AppColors.surfaceLight : AppColors.primary)
              .withValues(alpha: 0.5),
    );
  }
}

class QuranTafseerBookChips extends StatelessWidget {
  const QuranTafseerBookChips({
    super.key,
    required this.books,
    required this.selectedSlug,
    required this.isDark,
    required this.onSelected,
  });

  final List<TafseerBook> books;
  final String selectedSlug;
  final bool isDark;
  final ValueChanged<TafseerBook> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceDarkElevated
              : AppColors.primary.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.secondary.withValues(alpha: isDark ? 0.2 : 0.12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: books.length,
              separatorBuilder: (_, index) => const SizedBox(width: 4),
              itemBuilder: (context, index) {
                final book = books[index];
                return _TafseerBookChip(
                  label: book.nameArabic,
                  selected: book.slug == selectedSlug,
                  isDark: isDark,
                  onTap: () => onSelected(book),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _TafseerBookChip extends StatelessWidget {
  const _TafseerBookChip({
    required this.label,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        splashColor: AppColors.secondary.withValues(alpha: 0.12),
        highlightColor: AppColors.secondary.withValues(alpha: 0.06),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? (isDark ? AppColors.secondary : AppColors.surfaceLight)
                    .withValues(alpha: isDark ? 0.28 : 1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? AppColors.secondary.withValues(alpha: 0.22)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: QuranTafseerChipStyles.label(
                selected: selected,
                isDark: isDark,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
