import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../../core/theme/app_colors.dart';

abstract final class QuranReaderChrome {
  static const topBarHeight = 44.0;
  static const bottomBarHeight = 40.0;
}

class QuranReaderTopBar extends StatelessWidget {
  const QuranReaderTopBar({
    super.key,
    required this.surahName,
    required this.onBack,
    required this.onSurahList,
    required this.onTafseer,
  });

  final String surahName;
  final VoidCallback onBack;
  final VoidCallback onSurahList;
  final VoidCallback onTafseer;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return _FrostedBar(
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: QuranReaderChrome.topBarHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                QuranReaderActionButton(
                  icon: Icons.arrow_forward_rounded,
                  tooltip: 'رجوع',
                  onPressed: onBack,
                ),
                Expanded(
                  child: Text(
                    surahName,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoNaskhArabic(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.surfaceLight
                          : AppColors.primary,
                    ),
                  ),
                ),
                QuranReaderActionButton(
                  icon: Icons.menu_book_rounded,
                  tooltip: 'التفسير',
                  onPressed: onTafseer,
                  variant: QuranReaderButtonVariant.secondary,
                ),
                const SizedBox(width: 6),
                QuranReaderActionButton(
                  icon: Icons.format_list_bulleted_rounded,
                  tooltip: 'فهرس السور',
                  onPressed: onSurahList,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuranReaderBottomBar extends StatelessWidget {
  const QuranReaderBottomBar({
    super.key,
    required this.pageNumber,
  });

  final int pageNumber;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return _FrostedBar(
      edge: _FrostedBarEdge.top,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: QuranReaderChrome.bottomBarHeight,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.14),
                    AppColors.primary.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.22),
                ),
              ),
              child: Text(
                'صفحة ${convertToArabicNumber('$pageNumber')} من ${convertToArabicNumber('$totalPagesCount')}',
                style: GoogleFonts.notoNaskhArabic(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.surfaceLight : AppColors.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum QuranReaderButtonVariant { primary, secondary }

class QuranReaderActionButton extends StatelessWidget {
  const QuranReaderActionButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.variant = QuranReaderButtonVariant.primary,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final QuranReaderButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final isPrimary = variant == QuranReaderButtonVariant.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(11),
            child: Ink(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                gradient: isPrimary
                    ? const LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [AppColors.secondary, AppColors.primary],
                      )
                    : null,
                color: isPrimary
                    ? null
                    : AppColors.surfaceLight.withValues(alpha: 0.72),
                border: Border.all(
                  color: isPrimary
                      ? AppColors.primary.withValues(alpha: 0.35)
                      : AppColors.secondary.withValues(alpha: 0.35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.14),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 19,
                color: isPrimary ? AppColors.onPrimary : AppColors.secondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FrostedBar extends StatelessWidget {
  const _FrostedBar({
    required this.child,
    this.edge = _FrostedBarEdge.bottom,
  });

  final Widget child;
  final _FrostedBarEdge edge;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = AppColors.primary.withValues(alpha: 0.06);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: (isDark ? AppColors.surfaceDark : AppColors.glassLight)
                .withValues(alpha: 0.9),
            border: Border(
              top: edge == _FrostedBarEdge.top
                  ? BorderSide(color: borderColor)
                  : BorderSide.none,
              bottom: edge == _FrostedBarEdge.bottom
                  ? BorderSide(color: borderColor)
                  : BorderSide.none,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

enum _FrostedBarEdge { top, bottom }
