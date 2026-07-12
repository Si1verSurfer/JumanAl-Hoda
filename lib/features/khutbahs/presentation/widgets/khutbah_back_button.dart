import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/haptics/goman_haptics.dart';
import '../../../../core/theme/app_colors.dart';
import '../theme/khutbah_page_style.dart';

class KhutbahBackButton extends StatelessWidget {
  const KhutbahBackButton({
    super.key,
    required this.isDark,
    required this.label,
    required this.onPressed,
  });

  final bool isDark;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            GomanHaptics.tap();
            onPressed();
          },
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            decoration: BoxDecoration(
              color: AppColors.cardSurface(isDark),
              borderRadius: BorderRadius.circular(18),
              border: KhutbahPageStyle.border(isDark: isDark),
              boxShadow: KhutbahPageStyle.floatShadow(isDark: isDark),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.tajawal(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: AppColors.secondary.withValues(alpha: 0.88),
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
