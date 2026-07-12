import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/providers/app_icon_provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/haptics/goman_haptics.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/app_icon_storage.dart';

class AppIconPicker extends ConsumerWidget {
  const AppIconPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedId = ref.watch(appIconProvider).valueOrNull ?? AppIconOption.classic.id;
    final titleColor = AppColors.onCard(isDark);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppStrings.settingsAppIconHint,
          style: GoogleFonts.tajawal(
            fontSize: 12.5,
            height: 1.35,
            fontWeight: FontWeight.w600,
            color: AppColors.mutedOnCard(isDark),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (var i = 0; i < AppIconOption.options.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              Expanded(
                child: _AppIconCard(
                  option: AppIconOption.options[i],
                  isSelected: selectedId == AppIconOption.options[i].id,
                  isDark: isDark,
                  titleColor: titleColor,
                  onTap: () => _selectIcon(context, ref, AppIconOption.options[i].id),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Future<void> _selectIcon(
    BuildContext context,
    WidgetRef ref,
    String iconId,
  ) async {
    GomanHaptics.tap();
    final ok = await ref.read(appIconProvider.notifier).setIcon(iconId);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? AppStrings.settingsAppIconChanged : AppStrings.settingsAppIconUnsupported,
          style: GoogleFonts.tajawal(fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _AppIconCard extends StatelessWidget {
  const _AppIconCard({
    required this.option,
    required this.isSelected,
    required this.isDark,
    required this.titleColor,
    required this.onTap,
  });

  final AppIconOption option;
  final bool isSelected;
  final bool isDark;
  final Color titleColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: isSelected
                ? const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xFF8B2A32),
                      AppColors.secondary,
                      AppColors.primary,
                    ],
                  )
                : LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      isDark
                          ? AppColors.surfaceDarkElevated
                          : AppColors.surfaceElevatedLight,
                      isDark ? AppColors.surfaceDark : AppColors.glassLight,
                    ],
                  ),
            border: Border.all(
              color: isSelected
                  ? AppColors.onPrimary.withValues(alpha: 0.28)
                  : AppColors.primary.withValues(alpha: isDark ? 0.16 : 0.08),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.28),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.onPrimary.withValues(alpha: 0.35)
                        : AppColors.secondary.withValues(alpha: 0.18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  option.previewAsset,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                option.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.notoNaskhArabic(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  color: isSelected ? AppColors.onPrimary : titleColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                option.subtitle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.tajawal(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                  color: isSelected
                      ? AppColors.onPrimary.withValues(alpha: 0.82)
                      : titleColor.withValues(alpha: 0.52),
                ),
              ),
              if (isSelected) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.onPrimary.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'مُختار',
                    style: GoogleFonts.tajawal(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onPrimary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
