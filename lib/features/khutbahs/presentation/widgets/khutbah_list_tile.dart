import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/haptics/goman_haptics.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../quran/presentation/widgets/quran_rtl_icons.dart';
import '../../data/khutbah_models.dart';
import '../theme/khutbah_page_style.dart';

class KhutbahListTile extends StatelessWidget {
  const KhutbahListTile({
    super.key,
    required this.entry,
    required this.isDark,
    required this.onTap,
    this.showCategory = true,
  });

  final KhutbahIndexEntry entry;
  final bool isDark;
  final VoidCallback onTap;
  final bool showCategory;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? AppColors.surfaceLight : AppColors.primary;
    final subtitleColor = titleColor.withValues(alpha: 0.58);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: KhutbahPageStyle.floatShadow(isDark: isDark),
        ),
        child: Material(
          color: AppColors.cardSurface(isDark),
          elevation: 0,
          shadowColor: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              GomanHaptics.tap();
              onTap();
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: KhutbahPageStyle.border(isDark: isDark),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            AppColors.secondary.withValues(alpha: 0.20),
                            AppColors.secondary.withValues(alpha: 0.07),
                          ],
                        ),
                        border: Border.all(
                          color: AppColors.secondary.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Icon(
                        Icons.picture_as_pdf_rounded,
                        color: AppColors.secondary.withValues(alpha: 0.9),
                        size: 23,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            entry.title,
                            textAlign: TextAlign.right,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.notoNaskhArabic(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              height: 1.35,
                              color: titleColor,
                            ),
                          ),
                          if (entry.authorName.isNotEmpty) ...[
                            const SizedBox(height: 5),
                            Text(
                              entry.authorName,
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.tajawal(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: subtitleColor,
                              ),
                            ),
                          ],
                          if (showCategory && entry.categoryText.isNotEmpty) ...[
                            const SizedBox(height: 9),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary
                                      .withValues(alpha: isDark ? 0.16 : 0.08),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.secondary
                                        .withValues(alpha: 0.12),
                                  ),
                                ),
                                child: Text(
                                  entry.categoryText,
                                  style: GoogleFonts.tajawal(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.secondary
                                        .withValues(alpha: 0.92),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    QuranRtlIcons.forwardIcon(size: 15, opacity: 0.65),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
