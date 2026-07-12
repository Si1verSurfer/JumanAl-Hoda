import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../../core/haptics/goman_haptics.dart';
import '../../../../core/theme/app_colors.dart';
import 'quran_index_grid_tiles.dart';

abstract final class QuranReaderChrome {
  static const topBarHeight = 44.0;
  static const topBarBottomPadding = 10.0;
  static const bottomBarHeight = 40.0;
  static const topBarBottomRadius = 28.0;
}

class QuranReaderTopBar extends StatelessWidget {
  const QuranReaderTopBar({
    super.key,
    required this.surahNumber,
    required this.onClose,
    required this.onSurahList,
    required this.onSearch,
    required this.onTheme,
    required this.searchIconAsset,
    required this.surahListIconAsset,
    required this.barBackground,
    required this.barTextColor,
    required this.barAccentColor,
  });

  final int surahNumber;
  final VoidCallback onClose;
  final VoidCallback onSurahList;
  final VoidCallback onSearch;
  final VoidCallback onTheme;
  final String searchIconAsset;
  final String surahListIconAsset;
  final Color barBackground;
  final Color barTextColor;
  final Color barAccentColor;

  @override
  Widget build(BuildContext context) {
    return _FrostedBar(
      backgroundColor: barBackground,
      borderColor: barAccentColor.withValues(alpha: 0.14),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(QuranReaderChrome.topBarBottomRadius),
        bottomRight: Radius.circular(QuranReaderChrome.topBarBottomRadius),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: QuranReaderChrome.topBarBottomPadding,
          ),
          child: SizedBox(
            height: QuranReaderChrome.topBarHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  QuranReaderActionButton(
                    icon: Icons.close_rounded,
                    tooltip: 'العودة للقرآن',
                    onPressed: onClose,
                    variant: QuranReaderButtonVariant.secondary,
                    accentColor: barAccentColor,
                    surfaceColor: barBackground,
                  ),
                  Expanded(
                    child: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: SurahFontHelper.surahNameSpan(
                        surahNumber,
                        style: QuranSurahGridTileStyle.appBarSurahGlyph(
                          barTextColor,
                        ),
                        package: 'qcf_quran',
                      ),
                    ),
                  ),
                  QuranReaderActionButton(
                    iconAsset: searchIconAsset,
                    tooltip: 'بحث',
                    onPressed: onSearch,
                    variant: QuranReaderButtonVariant.secondary,
                    accentColor: barAccentColor,
                    surfaceColor: barBackground,
                  ),
                  const SizedBox(width: 6),
                  QuranReaderActionButton(
                    icon: Icons.palette_outlined,
                    tooltip: 'مظهر المصحف',
                    onPressed: onTheme,
                    variant: QuranReaderButtonVariant.secondary,
                    accentColor: barAccentColor,
                    surfaceColor: barBackground,
                  ),
                  const SizedBox(width: 6),
                  QuranReaderActionButton(
                    iconAsset: surahListIconAsset,
                    tooltip: 'فهرس السور',
                    onPressed: onSurahList,
                    accentColor: barAccentColor,
                    onAccentColor: barBackground,
                  ),
                ],
              ),
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
    this.iconAsset,
    this.icon,
    required this.tooltip,
    required this.onPressed,
    this.variant = QuranReaderButtonVariant.primary,
    this.accentColor = AppColors.secondary,
    this.onAccentColor = AppColors.onPrimary,
    this.surfaceColor,
  }) : assert(iconAsset != null || icon != null);

  final String? iconAsset;
  final IconData? icon;
  final String tooltip;
  final VoidCallback onPressed;
  final QuranReaderButtonVariant variant;
  final Color accentColor;
  final Color onAccentColor;
  final Color? surfaceColor;

  @override
  Widget build(BuildContext context) {
    final isPrimary = variant == QuranReaderButtonVariant.primary;
    final iconColor = isPrimary ? onAccentColor : accentColor;
    final secondarySurface =
        (surfaceColor ?? AppColors.surfaceLight).withValues(alpha: 0.72);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed.withHaptic(
              icon == Icons.close_rounded
                  ? GomanHapticKind.success
                  : GomanHapticKind.tap,
            ),
            borderRadius: BorderRadius.circular(11),
            child: Ink(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                gradient: isPrimary
                    ? LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [accentColor, accentColor.withValues(alpha: 0.82)],
                      )
                    : null,
                color: isPrimary ? null : secondarySurface,
                border: Border.all(
                  color: accentColor.withValues(alpha: isPrimary ? 0.35 : 0.28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: icon != null
                    ? Icon(icon, size: 20, color: iconColor)
                    : SvgPicture.asset(
                        iconAsset!,
                        width: 19,
                        height: 19,
                        colorFilter:
                            ColorFilter.mode(iconColor, BlendMode.srcIn),
                      ),
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
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
  });

  final Widget child;
  final _FrostedBarEdge edge;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fill = backgroundColor ??
        (isDark ? AppColors.surfaceDarkElevated : AppColors.glassLight)
            .withValues(alpha: 0.9);
    final stroke =
        borderColor ?? AppColors.primary.withValues(alpha: isDark ? 0.14 : 0.06);
    final radius = borderRadius ?? BorderRadius.zero;

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: fill,
            borderRadius: radius,
            border: Border(
              top: edge == _FrostedBarEdge.top
                  ? BorderSide(color: stroke)
                  : BorderSide.none,
              bottom: edge == _FrostedBarEdge.bottom
                  ? BorderSide(color: stroke)
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
