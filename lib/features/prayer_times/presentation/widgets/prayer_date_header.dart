import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/daily_prayer_schedule.dart';
import '../../../../core/theme/app_colors.dart';
import '../theme/prayer_time_tile_style.dart';

abstract final class PrayerDateHeaderStyle {
  static TextStyle calligraphy(Color color) => GoogleFonts.notoNaskhArabic(
        fontSize: 38,
        fontWeight: FontWeight.w700,
        height: 1.08,
        color: color,
      );

  static TextStyle pill(Color color) => GoogleFonts.notoNaskhArabic(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        height: 1.3,
        color: color,
      );
}

class PrayerDateHeader extends StatelessWidget {
  const PrayerDateHeader({
    super.key,
    required this.dateDisplay,
    required this.isDark,
  });

  final PrayerDateDisplay dateDisplay;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? AppColors.surfaceLight : AppColors.primary;
    final accentColor = isDark
        ? AppColors.surfaceLight.withValues(alpha: 0.9)
        : AppColors.secondary;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow(isDark: isDark),
      ),
      child: Material(
        color: AppColors.glassLight,
        elevation: 0,
        shadowColor: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 22, 14, 16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      dateDisplay.weekdayName,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: PrayerDateHeaderStyle.calligraphy(titleColor),
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryBrandGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondary.withValues(alpha: 0.26),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.nightlight_round,
                      size: 22,
                      color: AppColors.onPrimary.withValues(alpha: 0.94),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      dateDisplay.hijriMonthName,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: PrayerDateHeaderStyle.calligraphy(accentColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _DatePill(
                      label: dateDisplay.hijriPill,
                      caption: 'هِجْرِيٌّ',
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _DatePill(
                      label: dateDisplay.gregorianPill,
                      caption: 'مِيلَادِيٌّ',
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DatePill extends StatelessWidget {
  const _DatePill({
    required this.label,
    required this.caption,
    required this.isDark,
  });

  final String label;
  final String caption;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.surfaceLight : AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.35)
            : AppColors.surfaceElevatedLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: isDark ? 0.14 : 0.08),
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: PrayerDateHeaderStyle.pill(textColor),
          ),
          const SizedBox(height: 2),
          Text(
            caption,
            style: PrayerTimeTileStyle.meta(textColor),
          ),
        ],
      ),
    );
  }
}
