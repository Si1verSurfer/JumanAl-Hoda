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
        color: AppColors.cardSurface(isDark),
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
                const SizedBox(height: 14),
                _LocationFooter(
                  locationLabel: locationLabel,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LocationFooter extends StatelessWidget {
  const _LocationFooter({
    required this.locationLabel,
    required this.isDark,
  });

  final String locationLabel;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? AppColors.surfaceLight : AppColors.primary;
    final mutedTitle = titleColor.withValues(alpha: 0.55);
    final bodyColor = titleColor.withValues(alpha: 0.88);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDarkElevated.withValues(alpha: 0.72)
            : AppColors.secondary.withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: isDark ? 0.22 : 0.12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          AppColors.secondary.withValues(alpha: 0.2),
                          AppColors.secondary.withValues(alpha: 0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(
                        color: AppColors.secondary.withValues(alpha: 0.16),
                      ),
                    ),
                    child: const SizedBox(
                      width: 36,
                      height: 36,
                      child: Icon(
                        Icons.location_on_rounded,
                        size: 18,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          PrayerArabicLabels.currentLocation,
                          style: GoogleFonts.tajawal(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                            color: mutedTitle,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          locationLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.notoNaskhArabic(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                            color: bodyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppColors.primaryBrandGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit_location_alt_rounded,
                      size: 15,
                      color: AppColors.onPrimary.withValues(alpha: 0.92),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      PrayerArabicLabels.changeLocation,
                      style: GoogleFonts.notoNaskhArabic(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        color: AppColors.onPrimary,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: AppColors.onPrimary.withValues(alpha: 0.85),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
