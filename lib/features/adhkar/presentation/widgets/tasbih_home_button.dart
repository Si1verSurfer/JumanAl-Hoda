import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/goman_ink_well.dart';
import '../providers/tasbih_provider.dart';

/// Home-screen entry card for the electronic tasbih page.
class TasbihHomeButton extends ConsumerWidget {
  const TasbihHomeButton({
    super.key,
    required this.isDark,
    required this.onTap,
  });

  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasbih = ref.watch(tasbihProvider).valueOrNull;
    final subtitle = tasbih == null
        ? AppStrings.tasbihSubtitle
        : '${tasbih.dhikr} · ${tasbih.count}/${tasbih.target}';
    final titleColor = AppColors.onCard(isDark);
    final subtitleColor = isDark
        ? AppColors.accentOnSurface(AppColors.secondary, isDark)
            .withValues(alpha: 0.88)
        : AppColors.secondary.withValues(alpha: 0.72);
    final actionTint = AppColors.accentOnSurface(AppColors.secondary, isDark);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.adhkarCardShadow(isDark: isDark),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: GomanInkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: AppColors.featureCardGradient(isDark),
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.featureCardBorder(isDark),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Row(
                  children: [
                    _TasbihGlyph(isDark: isDark),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            AppStrings.electronicTasbih,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.tajawal(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                              color: titleColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.tajawal(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 1.35,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.secondary
                            .withValues(alpha: isDark ? 0.26 : 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.secondary
                              .withValues(alpha: isDark ? 0.48 : 0.2),
                        ),
                      ),
                      child: Icon(
                        Icons.touch_app_rounded,
                        color: actionTint,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TasbihGlyph extends StatelessWidget {
  const _TasbihGlyph({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.secondary.withValues(alpha: isDark ? 1.0 : 0.9),
            AppColors.primary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary
                .withValues(alpha: isDark ? 0.32 : 0.18),
            blurRadius: isDark ? 14 : 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (var i = 0; i < 8; i++)
            Transform.rotate(
              angle: i * 0.785398,
              child: Container(
                width: 4,
                height: 4,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: AppColors.onPrimary.withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.onPrimary.withValues(alpha: 0.18),
              border: Border.all(
                color: AppColors.onPrimary.withValues(alpha: 0.45),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
