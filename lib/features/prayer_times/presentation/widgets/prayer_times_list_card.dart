import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/daily_prayer_schedule.dart';
import '../theme/prayer_time_tile_style.dart';

class PrayerTimesListCard extends StatelessWidget {
  const PrayerTimesListCard({
    super.key,
    required this.entries,
    required this.isDark,
    required this.timeLabelFor,
  });

  final List<PrayerTimeEntry> entries;
  final bool isDark;
  final String Function(DateTime time) timeLabelFor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow(isDark: isDark),
      ),
      child: Material(
        color: AppColors.cardSurface(isDark),
        elevation: 0,
        shadowColor: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            for (var i = 0; i < entries.length; i++) ...[
              if (i > 0)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.dividerOnCard(isDark),
                  indent: 16,
                  endIndent: 16,
                ),
              _PrayerTimeRow(
                entry: entries[i],
                timeLabel: timeLabelFor(entries[i].time),
                isDark: isDark,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PrayerTimeRow extends StatelessWidget {
  const _PrayerTimeRow({
    required this.entry,
    required this.timeLabel,
    required this.isDark,
  });

  final PrayerTimeEntry entry;
  final String timeLabel;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? AppColors.surfaceLight : AppColors.primary;
    final isNext = entry.isNext && entry.isSalah;
    final isPast = entry.isPast && !isNext;
    final nameColor = isPast
        ? titleColor.withValues(alpha: 0.38)
        : titleColor;
    final timeColor = isPast
        ? titleColor.withValues(alpha: 0.34)
        : titleColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      color: isNext
          ? AppColors.secondary.withValues(alpha: 0.09)
          : Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Text(
                entry.name,
                textAlign: TextAlign.right,
                style: PrayerTimeTileStyle.prayerGlyph(nameColor).copyWith(
                  fontSize: entry.isSalah ? 26 : 22,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            if (isNext) ...[
              const SizedBox(width: 8),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _iconForPrayer(entry.kind),
                  size: 18,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: 8),
            ] else
              const SizedBox(width: 50),
            Expanded(
              flex: 4,
              child: Text(
                timeLabel,
                textAlign: TextAlign.left,
                style: GoogleFonts.tajawal(
                  fontSize: isNext ? 22 : 20,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  color: isNext ? AppColors.secondary : timeColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForPrayer(PrayerTimeKind kind) {
    return switch (kind) {
      PrayerTimeKind.fajr => Icons.bedtime_rounded,
      PrayerTimeKind.sunrise => Icons.wb_twilight_rounded,
      PrayerTimeKind.dhuhr => Icons.wb_sunny_rounded,
      PrayerTimeKind.asr => Icons.wb_cloudy_rounded,
      PrayerTimeKind.maghrib => Icons.nights_stay_rounded,
      PrayerTimeKind.isha => Icons.dark_mode_rounded,
    };
  }
}
