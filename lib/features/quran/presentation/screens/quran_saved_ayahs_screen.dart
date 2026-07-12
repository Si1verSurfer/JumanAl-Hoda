import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/navigation/goman_navigation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/goman_app_bar_close_button.dart';
import '../providers/quran_ayah_cards_provider.dart';
import '../providers/quran_ayah_highlights_provider.dart';
import '../widgets/quran_saved_ayahs_panel.dart';

class QuranSavedAyahsScreen extends ConsumerStatefulWidget {
  const QuranSavedAyahsScreen({super.key});

  @override
  ConsumerState<QuranSavedAyahsScreen> createState() =>
      _QuranSavedAyahsScreenState();
}

class _QuranSavedAyahsScreenState extends ConsumerState<QuranSavedAyahsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openAyah(int surahNumber, int verseNumber) {
    final page = getPageNumber(surahNumber, verseNumber);
    context.pushAnimated(
      '${Routes.quranRead}?page=$page&surah=$surahNumber&verse=$verseNumber',
      haptic: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cards = ref.watch(quranAyahCardsProvider);
    final highlights = ref.watch(quranAyahHighlightsProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: GomanAppBarCloseButton(
          color: isDark ? AppColors.surfaceLight : AppColors.primary,
        ),
        title: Text(
          'آياتي المحفوظة',
          style: GoogleFonts.notoNaskhArabic(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.surfaceLight : AppColors.primary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              height: 40,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.cardSurface(isDark),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.12),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.2),
                  ),
                ),
                labelColor: AppColors.secondary,
                unselectedLabelColor:
                    (isDark ? AppColors.surfaceLight : AppColors.primary)
                        .withValues(alpha: 0.5),
                labelStyle: GoogleFonts.tajawal(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: GoogleFonts.tajawal(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                tabs: [
                  Tab(
                    text:
                        'البطاقات (${convertToArabicNumber('${cards.length}')})',
                  ),
                  Tab(
                    text:
                        'التظليلات (${convertToArabicNumber('${highlights.length}')})',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          QuranSavedAyahsCardsTab(
            cards: cards,
            isDark: isDark,
            onOpenAyah: _openAyah,
            onRemove: (cardId) {
              ref.read(quranAyahCardsProvider.notifier).removeCard(cardId);
            },
          ),
          QuranSavedAyahsHighlightsTab(
            highlights: highlights,
            isDark: isDark,
            onOpenAyah: _openAyah,
            onRemove: (surah, verse) {
              ref.read(quranAyahHighlightsProvider.notifier).removeHighlight(
                    surahNumber: surah,
                    verseNumber: verse,
                  );
            },
          ),
        ],
      ),
    );
  }
}
