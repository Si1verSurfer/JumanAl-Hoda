import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';

class QuranSearchField extends StatelessWidget {
  const QuranSearchField({
    super.key,
    required this.controller,
    required this.isDark,
    this.focusNode,
    this.onChanged,
    this.hintText = 'ابحث عن سورة أو آية',
  });

  static const double preferredHeight = 52;

  final TextEditingController controller;
  final bool isDark;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final query = controller.text.trim();
        final textColor = isDark ? AppColors.surfaceLight : AppColors.primary;

        return Container(
          height: preferredHeight,
          decoration: BoxDecoration(
            color: AppColors.glassLight,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: isDark ? 0.14 : 0.07),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.07),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.03),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            textAlign: TextAlign.right,
            style: GoogleFonts.notoNaskhArabic(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textColor,
              height: 1.2,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.notoNaskhArabic(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor.withValues(alpha: 0.38),
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 14,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 10, right: 4),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        AppColors.secondary.withValues(alpha: 0.16),
                        AppColors.secondary.withValues(alpha: 0.06),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: AppColors.secondary.withValues(alpha: 0.88),
                  ),
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 48,
                minHeight: 34,
              ),
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      onPressed: controller.clear,
                      icon: Icon(
                        Icons.cancel_rounded,
                        size: 20,
                        color: AppColors.secondary.withValues(alpha: 0.65),
                      ),
                    ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: AppColors.secondary.withValues(alpha: 0.55),
                  width: 1.2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
