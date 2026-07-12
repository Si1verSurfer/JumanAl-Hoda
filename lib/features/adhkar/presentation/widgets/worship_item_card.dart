import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/haptics/goman_haptics.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/goman_ink_well.dart';
import '../../data/models/worship_item.dart';
import '../providers/worship_provider.dart';

class WorshipItemCard extends ConsumerWidget {
  const WorshipItemCard({
    super.key,
    required this.item,
    required this.isDark,
    required this.accentColor,
  });

  final WorshipItem item;
  final bool isDark;
  final Color accentColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(worshipFavoritesProvider);
    final isFavorite = favorites.contains(item.id);
    final titleColor = isDark ? AppColors.surfaceLight : AppColors.primary;
    final headerBg = isDark
        ? AppColors.surfaceDarkElevated
        : AppColors.primary.withValues(alpha: 0.04);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.adhkarCardShadow(isDark: isDark),
      ),
      child: Material(
        color: AppColors.cardSurface(isDark),
        elevation: 0,
        shadowColor: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: isDark ? 0.14 : 0.07),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
                decoration: BoxDecoration(
                  color: headerBg,
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.06),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        _HeaderIconButton(
                          icon: isFavorite
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_outline_rounded,
                          color: isFavorite
                              ? accentColor
                              : titleColor.withValues(alpha: 0.55),
                          tooltip:
                              isFavorite ? 'إزالة من أذكاري' : 'حفظ في أذكاري',
                          onTap: () {
                            GomanHaptics.tap();
                            ref
                                .read(worshipFavoritesProvider.notifier)
                                .toggle(item.id);
                          },
                        ),
                        const SizedBox(width: 4),
                        _HeaderIconButton(
                          icon: Icons.ios_share_rounded,
                          color: titleColor.withValues(alpha: 0.55),
                          tooltip: 'مشاركة',
                          onTap: () => _shareItem(item),
                        ),
                      ],
                    ),
                    Text(
                      item.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoNaskhArabic(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                        color: titleColor,
                      ),
                    ),
                    if (item.repeatHint != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.repeatHint!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.tajawal(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: accentColor.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      item.body,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoNaskhArabic(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.85,
                        color: titleColor.withValues(alpha: 0.92),
                      ),
                    ),
                    if (item.reference != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        item.reference!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.tajawal(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: accentColor.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _shareItem(WorshipItem item) async {
    GomanHaptics.tap();
    final buffer = StringBuffer()
      ..writeln(item.title)
      ..writeln()
      ..writeln(item.body);
    if (item.reference != null) {
      buffer
        ..writeln()
        ..writeln(item.reference);
    }
    await Share.share(buffer.toString().trim());
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GomanInkWell(
        onTap: onTap,
        haptic: GomanHapticKind.tap,
        enableScale: false,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}
