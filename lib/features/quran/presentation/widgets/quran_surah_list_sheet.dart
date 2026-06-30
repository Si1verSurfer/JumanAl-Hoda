import 'package:flutter/material.dart';

import '../../../../core/navigation/goman_navigation.dart';
import '../../../../core/theme/app_colors.dart';
import 'quran_surah_index_body.dart';

Future<void> showQuranSurahListSheet(
  BuildContext context, {
  required ValueChanged<int> onSurahSelected,
  QuranAyahIndexTap? onAyahSelected,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return showGomanModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return DraggableScrollableSheet(
        initialChildSize: 0.82,
        minChildSize: 0.5,
        maxChildSize: 0.92,
        builder: (context, scrollController) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: isDark ? 0.18 : 0.08),
              ),
              boxShadow: AppColors.cardShadow(isDark: isDark),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                Expanded(
                  child: QuranSurahIndexBody(
                    isDark: isDark,
                    scrollController: scrollController,
                    showTitle: true,
                    controlsPadding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    gridPadding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                    onSurahTap: (surahNumber) {
                      Navigator.of(sheetContext).pop();
                      onSurahSelected(surahNumber);
                    },
                    onAyahTap: onAyahSelected == null
                        ? null
                        : (surah, verse) {
                            Navigator.of(sheetContext).pop();
                            onAyahSelected(surah, verse);
                          },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
