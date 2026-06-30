import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/haptics/goman_haptics.dart';
import '../../../../core/theme/app_colors.dart';
import 'quran_rtl_icons.dart';

class QuranSearchResultTile extends StatelessWidget {
  const QuranSearchResultTile({
    super.key,
    required this.isDark,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool isDark;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppColors.cardShadow(isDark: isDark),
        ),
        child: Material(
          color: AppColors.glassLight,
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap.withHaptic(),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.notoNaskhArabic(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.surfaceLight
                                : AppColors.primary,
                          ),
                        ),
                        if (subtitle.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.notoNaskhArabic(
                              fontSize: 13,
                              height: 1.5,
                              color: (isDark
                                      ? AppColors.surfaceLight
                                      : AppColors.primary)
                                  .withValues(alpha: 0.58),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  QuranRtlIcons.forwardIcon(size: 18, opacity: 0.75),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class QuranSearchSectionTitle extends StatelessWidget {
  const QuranSearchSectionTitle({
    super.key,
    required this.label,
    required this.isDark,
  });

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        label,
        style: GoogleFonts.notoNaskhArabic(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}
