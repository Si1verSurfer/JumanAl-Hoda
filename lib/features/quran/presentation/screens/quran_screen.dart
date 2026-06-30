import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/navigation/goman_navigation.dart';
import '../../../../core/constants/app_nav_constants.dart';
import '../../../../core/utils/platform_utils.dart';
import '../providers/quran_reading_provider.dart';
import '../../../../core/widgets/animated_entrance.dart';
import '../theme/quran_page_style.dart';
import '../widgets/quran_index_header.dart';
import '../widgets/quran_saved_ayahs_panel.dart';
import '../widgets/quran_surah_index_body.dart';

class QuranScreen extends ConsumerWidget {
  const QuranScreen({super.key});

  void _openReader(BuildContext context, int pageNumber) {
    context.pushAnimated(
      '${Routes.quran}/read?page=$pageNumber',
      haptic: null,
    );
  }

  void _openAyah(BuildContext context, int surahNumber, int verseNumber) {
    final page = getPageNumber(surahNumber, verseNumber);
    context.pushAnimated(
      '${Routes.quran}/read?page=$page&surah=$surahNumber&verse=$verseNumber',
      haptic: null,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reading = ref.watch(quranLastReadingProvider);
    final bottomPadding = PlatformUtils.isIOS
        ? AppNavConstants.floatingBottomPadding(context)
        : 24.0;

    return Container(
      color: QuranPageStyle.background(isDark),
      child: QuranSurahIndexBody(
        isDark: isDark,
        onSurahTap: (surah) =>
            _openReader(context, getPageNumber(surah, 1)),
        onAyahTap: (surah, verse) => _openAyah(context, surah, verse),
        gridPadding: EdgeInsets.fromLTRB(20, 14, 20, bottomPadding),
        headerSlivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: QuranPageStyle.pagePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AnimatedEntrance(
                    child: QuranLastReadCard(
                      reading: reading,
                      isDark: isDark,
                      onTap: () => _openReader(context, reading.page),
                    ),
                  ),
                  const SizedBox(height: 14),
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 60),
                    child: QuranSavedAyahsEntryCard(
                      isDark: isDark,
                      onTap: () => context.pushAnimated(
                        Routes.quranSaved,
                        haptic: null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
