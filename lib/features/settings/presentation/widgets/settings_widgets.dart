import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';

class SettingsSectionHeader extends StatelessWidget {
  const SettingsSectionHeader({
    super.key,
    required this.title,
    this.icon,
  });

  final String title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark
        ? AppColors.surfaceLight.withValues(alpha: 0.62)
        : AppColors.primary.withValues(alpha: 0.62);

    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 22, 6, 10),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: AppColors.secondary),
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: GoogleFonts.notoNaskhArabic(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  const SettingsCard({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.cardSurface(isDark),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: isDark ? 0.14 : 0.06),
        ),
        boxShadow: AppColors.adhkarCardShadow(isDark: isDark),
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.showDivider = true,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = AppColors.onCard(isDark);
    final subtitleColor = AppColors.mutedOnCard(isDark);

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  if (leading != null) ...[
                    leading!,
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.tajawal(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: titleColor,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 3),
                          Text(
                            subtitle!,
                            style: GoogleFonts.tajawal(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (trailing != null)
                    trailing!
                  else if (onTap != null)
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: subtitleColor,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: leading == null ? 14 : 58,
            endIndent: 14,
            color: AppColors.dividerOnCard(isDark),
          ),
      ],
    );
  }
}

class SettingsIconBadge extends StatelessWidget {
  const SettingsIconBadge({
    super.key,
    required this.icon,
    this.highlight = false,
  });

  final IconData icon;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: highlight
            ? const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [AppColors.secondary, AppColors.primary],
              )
            : LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  AppColors.secondary.withValues(alpha: isDark ? 0.22 : 0.12),
                  AppColors.primary.withValues(alpha: isDark ? 0.14 : 0.06),
                ],
              ),
      ),
      child: Icon(
        icon,
        size: 20,
        color: highlight ? AppColors.onPrimary : AppColors.secondary,
      ),
    );
  }
}

class SettingsChoiceChip extends StatelessWidget {
  const SettingsChoiceChip({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: selected
                  ? const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color(0xFF8B2A32),
                        AppColors.secondary,
                        AppColors.primary,
                      ],
                    )
                  : null,
              color: selected
                  ? null
                  : (isDark
                      ? AppColors.surfaceDarkElevated
                      : AppColors.surfaceElevatedLight),
              border: Border.all(
                color: selected
                    ? AppColors.onPrimary.withValues(alpha: 0.28)
                    : AppColors.primary.withValues(alpha: isDark ? 0.16 : 0.08),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: selected
                      ? AppColors.onPrimary
                      : AppColors.secondary,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tajawal(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: selected
                        ? AppColors.onPrimary
                        : AppColors.onCard(isDark),
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

class SettingsCheckmark extends StatelessWidget {
  const SettingsCheckmark({super.key, required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    if (!selected) return const SizedBox(width: 24);

    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.secondary,
      ),
      child: const Icon(
        Icons.check_rounded,
        size: 16,
        color: AppColors.onPrimary,
      ),
    );
  }
}

class SettingsHeroHeader extends StatelessWidget {
  const SettingsHeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = AppColors.onCard(isDark);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.secondary.withValues(alpha: isDark ? 0.34 : 0.18),
            AppColors.primary.withValues(alpha: isDark ? 0.24 : 0.08),
          ],
        ),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: isDark ? 0.34 : 0.16),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: isDark ? 0.16 : 0.08),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.onPrimary.withValues(alpha: 0.14),
              border: Border.all(
                color: AppColors.onPrimary.withValues(alpha: 0.28),
              ),
              image: const DecorationImage(
                image: AssetImage('assets/appLogo/ios/AppIcon@3x.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.appName,
                  style: GoogleFonts.notoNaskhArabic(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'رفيقك في الذكر والعبادة اليومية',
                  style: GoogleFonts.tajawal(
                    fontSize: 13,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                    color: titleColor.withValues(alpha: 0.68),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsVersionFooter extends StatelessWidget {
  const SettingsVersionFooter({
    super.key,
    required this.version,
    required this.footer,
  });

  final String version;
  final String footer;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = AppColors.mutedOnCard(isDark);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.cardSurface(isDark),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: isDark ? 0.14 : 0.06),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/appLogo/ios/AppIcon@3x.png',
                  width: 42,
                  height: 42,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.appName,
                    style: GoogleFonts.notoNaskhArabic(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onCard(isDark),
                    ),
                  ),
                  Text(
                    'الإصدار $version',
                    style: GoogleFonts.tajawal(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          footer,
          textAlign: TextAlign.center,
          style: GoogleFonts.tajawal(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.6,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
