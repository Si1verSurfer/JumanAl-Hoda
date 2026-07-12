import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_nav_constants.dart';
import '../../../../core/haptics/goman_haptics.dart';
import '../../../../core/navigation/goman_navigation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/platform_utils.dart';
import '../../data/models/quran_mushaf_theme.dart';
import '../providers/quran_mushaf_theme_provider.dart';

void showQuranMushafThemeSheet(BuildContext context) {
  showGomanModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const QuranMushafThemeSheet(),
  );
}

class QuranMushafThemeSheet extends ConsumerWidget {
  const QuranMushafThemeSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selected = ref.watch(quranMushafThemeProvider);
    final titleColor = isDark ? AppColors.surfaceLight : AppColors.primary;
    final sheetColor = AppColors.cardSurface(isDark);
    final bottomMargin = PlatformUtils.isIOS
        ? AppNavConstants.floatingBottomPadding(context)
        : 24.0;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.fromLTRB(12, 0, 12, bottomMargin),
          decoration: BoxDecoration(
            color: sheetColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppColors.cardShadow(isDark: isDark),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: titleColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                child: Text(
                  'مظهر المصحف',
                  style: GoogleFonts.notoNaskhArabic(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final spec in QuranMushafThemes.selectable)
                      _ThemeOptionTile(
                        spec: spec,
                        isSelected: selected == spec.id,
                        isFeatured: spec.id == QuranMushafTheme.cream,
                        onTap: () {
                          GomanHaptics.confirm();
                          ref
                              .read(quranMushafThemeProvider.notifier)
                              .setTheme(spec.id);
                          Navigator.of(context).pop();
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  const _ThemeOptionTile({
    required this.spec,
    required this.isSelected,
    required this.onTap,
    this.isFeatured = false,
  });

  final QuranMushafThemeSpec spec;
  final bool isSelected;
  final bool isFeatured;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? (isFeatured ? spec.headerFrame : AppColors.secondary)
        : isFeatured
            ? spec.headerFrame.withValues(alpha: 0.45)
            : AppColors.primary.withValues(alpha: 0.08);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          width: isFeatured ? 156 : 148,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 2 : 1,
            ),
            gradient: isFeatured
                ? LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      spec.pageBackground,
                      Color.lerp(spec.pageBackground, spec.swatch, 0.35)!,
                    ],
                  )
                : null,
            color: isFeatured ? null : spec.pageBackground,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: (isFeatured ? spec.headerFrame : AppColors.secondary)
                          .withValues(alpha: 0.22),
                      blurRadius: isFeatured ? 18 : 14,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : isFeatured
                    ? [
                        BoxShadow(
                          color: spec.headerFrame.withValues(alpha: 0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
          ),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: spec.pageBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: spec.verseText.withValues(alpha: 0.08),
                      ),
                      boxShadow: isFeatured
                          ? [
                              BoxShadow(
                                color: spec.headerFrame.withValues(alpha: 0.16),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'بِسْمِ اللَّهِ',
                      style: GoogleFonts.notoNaskhArabic(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: spec.basmala,
                      ),
                    ),
                  ),
                  if (isFeatured)
                    Positioned(
                      top: -8,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              spec.headerFrame,
                              spec.verseNumber,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: spec.headerFrame.withValues(alpha: 0.28),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'مميز',
                          style: GoogleFonts.tajawal(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: spec.pageBackground,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (isFeatured) ...[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [spec.headerFrame, spec.verseNumber],
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ] else
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: spec.swatch,
                        shape: BoxShape.circle,
                      ),
                    ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      spec.label,
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: spec.verseText,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: spec.verseNumber,
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
