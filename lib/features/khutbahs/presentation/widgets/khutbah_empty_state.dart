import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';

class KhutbahEmptyState extends StatelessWidget {
  const KhutbahEmptyState({
    super.key,
    required this.isDark,
    this.loading = false,
  });

  final bool isDark;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Skeletonizer(
        enabled: true,
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          itemCount: 8,
          itemBuilder: (context, index) {
            return Container(
              height: 92,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.cardSurface(isDark),
                borderRadius: BorderRadius.circular(16),
              ),
            );
          },
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 48,
              color: AppColors.secondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.khutbahsEmpty,
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.mutedOnCard(isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
