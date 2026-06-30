import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/ayah_card.dart';
import '../../data/models/ayah_highlight.dart';
import '../providers/quran_ayah_cards_provider.dart';
import '../providers/quran_ayah_highlights_provider.dart';
import 'quran_saved_ayah_tiles.dart';

class QuranSavedAyahsPanel extends ConsumerStatefulWidget {
  const QuranSavedAyahsPanel({
    super.key,
    required this.isDark,
    required this.onOpenAyah,
  });

  final bool isDark;
  final void Function(int surahNumber, int verseNumber) onOpenAyah;

  @override
  ConsumerState<QuranSavedAyahsPanel> createState() =>
      _QuranSavedAyahsPanelState();
}

class _QuranSavedAyahsPanelState extends ConsumerState<QuranSavedAyahsPanel>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final cards = ref.watch(quranAyahCardsProvider);
    final highlights = ref.watch(quranAyahHighlightsProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDarkElevated : AppColors.glassLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: isDark ? 0.14 : 0.07),
        ),
        boxShadow: AppColors.cardShadow(isDark: isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              'آياتي المحفوظة',
              style: GoogleFonts.notoNaskhArabic(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.surfaceLight : AppColors.primary,
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: AppColors.secondary,
            unselectedLabelColor:
                (isDark ? AppColors.surfaceLight : AppColors.primary)
                    .withValues(alpha: 0.5),
            indicatorColor: AppColors.secondary,
            indicatorSize: TabBarIndicatorSize.label,
            dividerColor: AppColors.secondary.withValues(alpha: 0.1),
            labelStyle: GoogleFonts.tajawal(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: GoogleFonts.tajawal(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            tabs: [
              Tab(text: 'البطاقات (${convertToArabicNumber('${cards.length}')})'),
              Tab(
                text:
                    'التظليلات (${convertToArabicNumber('${highlights.length}')})',
              ),
            ],
          ),
          SizedBox(
            height: _panelHeight(cards.length, highlights.length),
            child: TabBarView(
              controller: _tabController,
              children: [
                _CardsTab(
                  cards: cards,
                  isDark: isDark,
                  onOpenAyah: widget.onOpenAyah,
                  onRemove: (cardId) {
                    ref.read(quranAyahCardsProvider.notifier).removeCard(cardId);
                  },
                ),
                _HighlightsTab(
                  highlights: highlights,
                  isDark: isDark,
                  onOpenAyah: widget.onOpenAyah,
                  onRemove: (surah, verse) {
                    ref
                        .read(quranAyahHighlightsProvider.notifier)
                        .removeHighlight(
                          surahNumber: surah,
                          verseNumber: verse,
                        );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _panelHeight(int cardCount, int highlightCount) {
    final activeCount =
        _tabController.index == 0 ? cardCount : highlightCount;
    if (activeCount == 0) return 140;
    if (_tabController.index == 0) {
      return (activeCount * 260.0 + 24).clamp(200, 520);
    }
    return (activeCount * 96.0 + 24).clamp(160, 420);
  }
}

class _CardsTab extends StatelessWidget {
  const _CardsTab({
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
      return _EmptyTabMessage(
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

class _HighlightsTab extends StatelessWidget {
  const _HighlightsTab({
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
      return _EmptyTabMessage(
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

class _EmptyTabMessage extends StatelessWidget {
  const _EmptyTabMessage({
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
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border_rounded,
              size: 28,
              color: AppColors.secondary.withValues(alpha: 0.45),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: GoogleFonts.tajawal(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.surfaceLight : AppColors.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              hint,
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(
                fontSize: 12,
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
