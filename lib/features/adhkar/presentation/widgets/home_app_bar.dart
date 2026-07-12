import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_brand_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/general_icon_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/goman_svg_icon.dart';

/// Fixed home app bar — logo and title aligned from the right (RTL start).
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    required this.isDark,
    required this.onSettingsTap,
  });

  static String logoAssetFor(bool isDark) =>
      AppBrandAssets.homeLogoFor(isDark: isDark);

  final bool isDark;
  final VoidCallback onSettingsTap;

  static double totalHeight(BuildContext context) =>
      MediaQuery.paddingOf(context).top + _toolbarHeight;

  static const double _toolbarHeight = 72;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? AppColors.surfaceLight : AppColors.primary;
    final subtitleColor = titleColor.withValues(alpha: 0.62);
    final background = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;

    return Material(
      color: background,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: _toolbarHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _LogoMark(isDark: isDark),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        AppStrings.appName,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoNaskhArabic(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppStrings.appSubtitle,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.tajawal(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: AppStrings.settings,
                  onPressed: onSettingsTap,
                  icon: GomanSvgIcon(
                    asset: GeneralIconAssets.settings,
                    color: titleColor.withValues(alpha: 0.85),
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.secondary.withValues(
              alpha: isDark ? 0.28 : 0.14,
            ),
          ),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: ClipOval(
          child: Image.asset(
            HomeAppBar.logoAssetFor(isDark),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            errorBuilder: (context, error, stackTrace) => ColoredBox(
              color: AppColors.secondary.withValues(alpha: 0.12),
              child: Icon(
                Icons.mosque_rounded,
                color: AppColors.secondary.withValues(alpha: 0.8),
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
