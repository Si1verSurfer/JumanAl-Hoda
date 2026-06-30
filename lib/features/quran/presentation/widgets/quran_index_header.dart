import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../../core/haptics/goman_haptics.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/quran_last_reading.dart';
import 'quran_rtl_icons.dart';

class QuranLastReadCard extends StatelessWidget {
  const QuranLastReadCard({
    super.key,
    required this.reading,
    required this.isDark,
    required this.onTap,
    this.onBookmarksTap,
  });

  final QuranLastReading reading;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback? onBookmarksTap;

  @override
  Widget build(BuildContext context) {
    final surahName = getSurahNameArabicWithTashkeel(reading.surahNumber);
    final whenLabel = _formatReadAt(reading.readAt);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow(isDark: isDark),
      ),
      child: Material(
        color: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap.withHaptic(),
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: AppColors.primaryBrandGradient,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'آخر قراءة — $surahName',
                              style: GoogleFonts.notoNaskhArabic(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'الآية ${convertToArabicNumber('${reading.verseNumber}')} · ص ${convertToArabicNumber('${reading.page}')}',
                              style: GoogleFonts.tajawal(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onPrimary.withValues(alpha: 0.78),
                              ),
                            ),
                            if (whenLabel != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                whenLabel,
                                style: GoogleFonts.tajawal(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      AppColors.onPrimary.withValues(alpha: 0.58),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      QuranRtlIcons.forwardIcon(
                        size: 16,
                        color: AppColors.onPrimary,
                        opacity: 0.7,
                      ),
                    ],
                  ),
                ),
                if (onBookmarksTap != null)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: IconButton(
                      onPressed: onBookmarksTap?.withHaptic(GomanHapticKind.tap),
                      icon: Icon(
                        Icons.bookmarks_outlined,
                        size: 20,
                        color: AppColors.onPrimary.withValues(alpha: 0.85),
                      ),
                      tooltip: 'آياتي المحفوظة',
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _formatReadAt(DateTime? readAt) {
    if (readAt == null) return null;
    final now = DateTime.now();
    final isToday =
        readAt.year == now.year &&
        readAt.month == now.month &&
        readAt.day == now.day;
    final dayLabel = isToday
        ? 'اليوم'
        : '${convertToArabicNumber('${readAt.day}')}/${convertToArabicNumber('${readAt.month}')}';
    final hour = readAt.hour % 12 == 0 ? 12 : readAt.hour % 12;
    final period = readAt.hour >= 12 ? 'م' : 'ص';
    final minute = readAt.minute.toString().padLeft(2, '0');
    return '$dayLabel · ${convertToArabicNumber('$hour')}:$minute $period';
  }
}
