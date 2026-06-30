import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../../core/haptics/goman_haptics.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/ayah_card.dart';
import '../../data/models/ayah_highlight.dart';
import '../providers/quran_ayah_cards_provider.dart';
import '../providers/quran_ayah_highlights_provider.dart';
import 'quran_rtl_icons.dart';
import 'quran_saved_ayah_tiles.dart';

/// Tappable summary card on the Quran tab — opens [QuranSavedAyahsScreen].
class QuranSavedAyahsEntryCard extends ConsumerWidget {
  const QuranSavedAyahsEntryCard({
    super.key,
    required this.isDark,
    required this.onTap,
  });

  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(quranAyahCardsProvider);
    final highlights = ref.watch(quranAyahHighlightsProvider);
    final total = cards.length + highlights.length;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow(isDark: isDark),
      ),
      child: Material(
        color: AppColors.glassLight,
        elevation: 0,
        shadowColor: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap.withHaptic(),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        AppColors.secondary.withValues(alpha: 0.16),
                        AppColors.secondary.withValues(alpha: 0.06),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Icon(
                    Icons.bookmarks_rounded,
                    color: AppColors.secondary.withValues(alpha: 0.88),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'آياتي المحفوظة',
                        style: GoogleFonts.notoNaskhArabic(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.surfaceLight
                              : AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        total == 0
                            ? 'البطاقات والتظليلات — اضغط للعرض'
                            : '${convertToArabicNumber('${cards.length}')} بطاقة · ${convertToArabicNumber('${highlights.length}')} تظليل',
                        style: GoogleFonts.tajawal(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: (isDark
                                  ? AppColors.surfaceLight
                                  : AppColors.primary)
                              .withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                ),
                QuranRtlIcons.forwardIcon(size: 15, opacity: 0.7),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuranSavedAyahsCardsTab extends StatelessWidget {
  const QuranSavedAyahsCardsTab({
    super.key,
    required this.cards,
    required this.isDark,
    required this.onOpenAyah,
    required this.onRemove,
  });

  final List<SavedAyahCard> cards;
  final bool isDark;
  final void Function(int surahNumber, int verseNumber) onOpenAyah;
  final void Function(String cardId) onRemove;

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return QuranSavedAyahsEmptyMessage(
        isDark: isDark,
        message: 'لا توجد بطاقات بعد',
        hint: 'اضغط مطولاً على آية وأضفها إلى البطاقات (حتى ٣ آيات)',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        return QuranAyahCardTile(
          card: card,
          isDark: isDark,
          onTap: () => onOpenAyah(card.surahNumber, card.firstVerse),
          onRemove: () => onRemove(card.id),
        );
      },
    );
  }
}

class QuranSavedAyahsHighlightsTab extends StatelessWidget {
  const QuranSavedAyahsHighlightsTab({
    super.key,
    required this.highlights,
    required this.isDark,
    required this.onOpenAyah,
    required this.onRemove,
  });

  final List<SavedAyahHighlight> highlights;
  final bool isDark;
  final void Function(int surahNumber, int verseNumber) onOpenAyah;
  final void Function(int surah, int verse) onRemove;

  @override
  Widget build(BuildContext context) {
    if (highlights.isEmpty) {
      return QuranSavedAyahsEmptyMessage(
        isDark: isDark,
        message: 'لا توجد تظليلات بعد',
        hint: 'اضغط مطولاً على آية واختر لون التظليل',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
      itemCount: highlights.length,
      itemBuilder: (context, index) {
        final highlight = highlights[index];
        return QuranAyahHighlightTile(
          highlight: highlight,
          isDark: isDark,
          onTap: () =>
              onOpenAyah(highlight.surahNumber, highlight.verseNumber),
          onRemove: () =>
              onRemove(highlight.surahNumber, highlight.verseNumber),
        );
      },
    );
  }
}

class QuranSavedAyahsEmptyMessage extends StatelessWidget {
  const QuranSavedAyahsEmptyMessage({
    super.key,
    required this.isDark,
    required this.message,
    required this.hint,
  });

  final bool isDark;
  final String message;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border_rounded,
              size: 32,
              color: AppColors.secondary.withValues(alpha: 0.45),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: GoogleFonts.tajawal(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.surfaceLight : AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hint,
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.5,
                color: (isDark ? AppColors.surfaceLight : AppColors.primary)
                    .withValues(alpha: 0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
