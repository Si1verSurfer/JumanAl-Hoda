import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../../core/haptics/goman_haptics.dart';
import '../../../../core/theme/app_colors.dart';
import '../utils/quran_index_filter.dart';

class QuranDivisionFilterBar extends StatelessWidget {
  static const double modeRowHeight = 36;
  static const double modeToPickerGap = 10;
  static const double numberPickerRowHeight = 34;

  static double preferredHeight(QuranDivisionFilter division) {
    var height = modeRowHeight;
    if (division != QuranDivisionFilter.all) {
      height += modeToPickerGap + numberPickerRowHeight;
    }
    return height;
  }

  const QuranDivisionFilterBar({
    super.key,
    required this.isDark,
    required this.division,
    required this.juzNumber,
    required this.hizbNumber,
    required this.onDivisionChanged,
    required this.onJuzChanged,
    required this.onHizbChanged,
  });

  final bool isDark;
  final QuranDivisionFilter division;
  final int juzNumber;
  final int hizbNumber;
  final ValueChanged<QuranDivisionFilter> onDivisionChanged;
  final ValueChanged<int> onJuzChanged;
  final ValueChanged<int> onHizbChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _ModeChip(
              label: 'الكل',
              selected: division == QuranDivisionFilter.all,
              isDark: isDark,
              onTap: (() => onDivisionChanged(QuranDivisionFilter.all))
                  .withHaptic(GomanHapticKind.tap),
            ),
            const SizedBox(width: 8),
            _ModeChip(
              label: 'جزء',
              selected: division == QuranDivisionFilter.juz,
              isDark: isDark,
              onTap: (() => onDivisionChanged(QuranDivisionFilter.juz))
                  .withHaptic(GomanHapticKind.tap),
            ),
            const SizedBox(width: 8),
            _ModeChip(
              label: 'حزب',
              selected: division == QuranDivisionFilter.hizb,
              isDark: isDark,
              onTap: (() => onDivisionChanged(QuranDivisionFilter.hizb))
                  .withHaptic(GomanHapticKind.tap),
            ),
          ],
        ),
        if (division == QuranDivisionFilter.juz) ...[
          const SizedBox(height: modeToPickerGap),
          SizedBox(
            height: numberPickerRowHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: totalJuzCount,
              separatorBuilder: (_, _) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final number = index + 1;
                return _NumberChip(
                  label: convertToArabicNumber('$number'),
                  selected: juzNumber == number,
                  isDark: isDark,
                  onTap: (() => onJuzChanged(number)).withHaptic(GomanHapticKind.tap),
                );
              },
            ),
          ),
        ],
        if (division == QuranDivisionFilter.hizb) ...[
          const SizedBox(height: modeToPickerGap),
          SizedBox(
            height: numberPickerRowHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: totalHizbCount,
              separatorBuilder: (_, _) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final number = index + 1;
                return _NumberChip(
                  label: convertToArabicNumber('$number'),
                  selected: hizbNumber == number,
                  isDark: isDark,
                  onTap: (() => onHizbChanged(number)).withHaptic(GomanHapticKind.tap),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
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
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            height: QuranDivisionFilterBar.modeRowHeight,
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.secondary.withValues(alpha: 0.14)
                  : AppColors.glassLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected
                    ? AppColors.secondary.withValues(alpha: 0.28)
                    : AppColors.primary.withValues(alpha: 0.08),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: GoogleFonts.tajawal(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                color: selected
                    ? AppColors.secondary
                    : (isDark ? AppColors.surfaceLight : AppColors.primary)
                        .withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NumberChip extends StatelessWidget {
  const _NumberChip({
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.secondary.withValues(alpha: 0.14)
                : AppColors.glassLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? AppColors.secondary.withValues(alpha: 0.28)
                  : AppColors.primary.withValues(alpha: 0.08),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.tajawal(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: selected
                  ? AppColors.secondary
                  : (isDark ? AppColors.surfaceLight : AppColors.primary)
                      .withValues(alpha: 0.65),
            ),
          ),
        ),
      ),
    );
  }
}
