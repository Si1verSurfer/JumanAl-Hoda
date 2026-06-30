import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/constants/app_nav_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/platform_utils.dart';
import '../providers/quran_reading_provider.dart';
import '../widgets/quran_continue_card.dart';
import '../widgets/quran_surah_tile.dart';

class QuranScreen extends ConsumerWidget {
  const QuranScreen({super.key});

  void _openReader(BuildContext context, int pageNumber) {
    context.push('${Routes.quran}/read?page=$pageNumber');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lastPage = ref.watch(quranLastPageProvider);
    final bottomPadding = PlatformUtils.isIOS
        ? AppNavConstants.floatingBottomPadding(context)
        : 24.0;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.quran,
                  style: GoogleFonts.notoNaskhArabic(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.surfaceLight
                        : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppStrings.quranSubtitle,
                  style: GoogleFonts.notoNaskhArabic(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: (isDark
                            ? AppColors.surfaceLight
                            : AppColors.primary)
                        .withValues(alpha: 0.62),
                  ),
                ),
                const SizedBox(height: 20),
                QuranContinueCard(
                  pageNumber: lastPage,
                  onTap: () => _openReader(context, lastPage),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(
                      'فهرس السور',
                      style: GoogleFonts.notoNaskhArabic(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.surfaceLight
                            : AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${convertToArabicNumber('$totalSurahCount')} سورة',
                      style: GoogleFonts.notoNaskhArabic(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, bottomPadding),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final surahNumber = index + 1;
                return QuranSurahTile(
                  surahNumber: surahNumber,
                  onTap: () {
                    final page = getPageNumber(surahNumber, 1);
                    _openReader(context, page);
                  },
                );
              },
              childCount: totalSurahCount,
            ),
          ),
        ),
      ],
    );
  }
}
