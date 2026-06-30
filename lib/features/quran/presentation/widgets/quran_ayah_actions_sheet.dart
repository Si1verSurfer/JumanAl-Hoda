import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/ayah_card.dart';
import '../../data/models/ayah_highlight.dart';
import '../providers/quran_ayah_cards_provider.dart';
import '../providers/quran_ayah_highlights_provider.dart';
import '../utils/ayah_highlight_colors.dart';

Future<void> showQuranAyahActionsSheet(
  BuildContext context, {
  required int surahNumber,
  required int verseNumber,
  required VoidCallback onOpenTafseer,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return _QuranAyahActionsSheet(
        surahNumber: surahNumber,
        verseNumber: verseNumber,
        onOpenTafseer: onOpenTafseer,
      );
    },
  );
}

class _QuranAyahActionsSheet extends ConsumerWidget {
  const _QuranAyahActionsSheet({
    required this.surahNumber,
    required this.verseNumber,
    required this.onOpenTafseer,
  });

  final int surahNumber;
  final int verseNumber;
  final VoidCallback onOpenTafseer;

  String _cardActionLabel(
    SavedAyahCard? card,
    SavedAyahCard? incompleteCard,
  ) {
    if (card != null) {
      final count = convertToArabicNumber('${card.verseNumbers.length}');
      return 'إزالة من البطاقة ($count آيات)';
    }
    if (incompleteCard != null) {
      final current =
          convertToArabicNumber('${incompleteCard.verseNumbers.length}');
      final max = convertToArabicNumber('${SavedAyahCard.maxVerses}');
      return 'إضافة إلى البطاقة ($current/$max)';
    }
    return 'إضافة بطاقة جديدة';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final highlights = ref.watch(quranAyahHighlightsProvider);
    ref.watch(quranAyahCardsProvider);
    SavedAyahHighlight? currentHighlight;
    for (final entry in highlights) {
      if (entry.surahNumber == surahNumber &&
          entry.verseNumber == verseNumber) {
        currentHighlight = entry;
        break;
      }
    }
    final card = ref.watch(quranAyahCardsProvider.notifier).cardContainingVerse(
          surahNumber,
          verseNumber,
        );
    final incompleteCard = ref
        .read(quranAyahCardsProvider.notifier)
        .latestIncompleteCard(surahNumber);

    final surahName = getSurahNameArabicWithTashkeel(surahNumber);
    final ayahText = getVerse(surahNumber, verseNumber);
    final ayahLabel =
        '${convertToArabicNumber('$surahNumber')}:${convertToArabicNumber('$verseNumber')}';

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: isDark ? 0.18 : 0.08),
          ),
          boxShadow: AppColors.cardShadow(isDark: isDark),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '$surahName · $ayahLabel',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoNaskhArabic(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.surfaceLight : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  ayahText,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.notoNaskhArabic(
                    fontSize: 20,
                    height: 1.85,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.surfaceLight.withValues(alpha: 0.94)
                        : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'تظليل الآية',
                  style: GoogleFonts.tajawal(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: AyahHighlightColor.values.map((color) {
                    final selected = currentHighlight?.color == color;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: color == AyahHighlightColor.green ? 6 : 0,
                          right: color == AyahHighlightColor.yellow ? 6 : 0,
                        ),
                        child: _HighlightColorButton(
                          color: color,
                          selected: selected,
                          isDark: isDark,
                          onTap: () async {
                            await ref
                                .read(quranAyahHighlightsProvider.notifier)
                                .toggleHighlight(
                                  surahNumber: surahNumber,
                                  verseNumber: verseNumber,
                                  color: color,
                                );
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
                if (currentHighlight != null) ...[
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () async {
                      await ref
                          .read(quranAyahHighlightsProvider.notifier)
                          .removeHighlight(
                            surahNumber: surahNumber,
                            verseNumber: verseNumber,
                          );
                    },
                    child: Text(
                      'إزالة التظليل',
                      style: GoogleFonts.tajawal(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                _ActionTile(
                  icon: card != null
                      ? Icons.bookmark_remove_rounded
                      : Icons.bookmark_add_rounded,
                  label: _cardActionLabel(card, incompleteCard),
                  isDark: isDark,
                  onTap: () async {
                    await ref
                        .read(quranAyahCardsProvider.notifier)
                        .toggleVerseInCard(
                          context: context,
                          surahNumber: surahNumber,
                          verseNumber: verseNumber,
                        );
                  },
                ),
                _ActionTile(
                  icon: Icons.menu_book_rounded,
                  label: 'تفسير الآية',
                  isDark: isDark,
                  onTap: () {
                    Navigator.of(context).pop();
                    onOpenTafseer();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HighlightColorButton extends StatelessWidget {
  const _HighlightColorButton({
    required this.color,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  final AyahHighlightColor color;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fill = AyahHighlightColors.chip(color);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: fill.withValues(alpha: selected ? 0.28 : 0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? fill : fill.withValues(alpha: 0.45),
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: fill,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.65),
                    width: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                AyahHighlightColors.label(color),
                style: GoogleFonts.tajawal(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.surfaceLight : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceDarkElevated
                  : AppColors.glassLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: 0.16),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  Icon(icon, color: AppColors.secondary, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color:
                            isDark ? AppColors.surfaceLight : AppColors.primary,
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
