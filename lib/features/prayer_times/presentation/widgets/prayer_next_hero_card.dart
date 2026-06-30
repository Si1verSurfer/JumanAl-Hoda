import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/haptics/goman_haptics.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/constants/prayer_arabic_labels.dart';
import '../theme/prayer_time_tile_style.dart';

class PrayerNextHeroCard extends StatelessWidget {
  const PrayerNextHeroCard({
    super.key,
    required this.prayerName,
    required this.prayerTimeLabel,
    required this.countdownLabel,
    required this.locationLabel,
    required this.isDark,
    required this.onChangeLocation,
  });

  final String prayerName;
  final String prayerTimeLabel;
  final String countdownLabel;
  final String locationLabel;
  final bool isDark;
  final VoidCallback onChangeLocation;

  @override
  Widget build(BuildContext context) {
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
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onChangeLocation.withHaptic(),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            PrayerArabicLabels.nextPrayer,
                            style: GoogleFonts.notoNaskhArabic(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondary,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            prayerName,
                            style: PrayerTimeTileStyle.prayerGlyph(
                              isDark
                                  ? AppColors.surfaceLight
                                  : AppColors.primary,
                            ).copyWith(fontSize: 34),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          prayerTimeLabel,
                          style: GoogleFonts.tajawal(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? AppColors.surfaceLight
                                : AppColors.primary,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          countdownLabel,
                          style: GoogleFonts.tajawal(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 1,
                  color: AppColors.primary.withValues(alpha: 0.06),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: AppColors.secondary.withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        locationLabel,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoNaskhArabic(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: (isDark
                                  ? AppColors.surfaceLight
                                  : AppColors.primary)
                              .withValues(alpha: 0.72),
                        ),
                      ),
                    ),
                    Text(
                      PrayerArabicLabels.changeLocation,
                      style: GoogleFonts.notoNaskhArabic(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.chevron_left_rounded,
                      size: 18,
                      color: AppColors.secondary.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
