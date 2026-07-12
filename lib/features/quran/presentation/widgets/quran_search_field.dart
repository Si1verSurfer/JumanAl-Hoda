import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/goman_search_field.dart';
import '../constants/quran_icon_assets.dart';

class QuranSearchField extends StatelessWidget {
  const QuranSearchField({
    super.key,
    required this.controller,
    required this.isDark,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.hintText = 'ابحث عن سورة أو آية',
    this.showHintChip = true,
    this.height,
    this.hintStyle,
  });

  static const double preferredHeight = GomanSearchField.preferredHeight;

  final TextEditingController controller;
  final bool isDark;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String hintText;
  final bool showHintChip;
  final double? height;
  final TextStyle? hintStyle;

  @override
  Widget build(BuildContext context) {
    final muted = (isDark ? AppColors.surfaceLight : AppColors.primary)
        .withValues(alpha: 0.42);

    return GomanSearchField(
      controller: controller,
      isDark: isDark,
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      hintText: hintText,
      height: height ?? preferredHeight,
      iconAsset: QuranIconAssets.search,
      hintStyle: hintStyle ??
          GoogleFonts.notoNaskhArabic(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: muted,
            height: 1.3,
          ),
      suffix: showHintChip ? _SearchHintChip(isDark: isDark) : null,
    );
  }
}

class _SearchHintChip extends StatelessWidget {
  const _SearchHintChip({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final color = isDark ? AppColors.surfaceLight : AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: isDark ? 0.12 : 0.07),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '٢:٢٥٥',
        style: GoogleFonts.tajawal(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
