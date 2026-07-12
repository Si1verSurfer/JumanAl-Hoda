import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/haptics/goman_haptics.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/goman_ink_well.dart';
import '../../../data/models/worship_item.dart';
import '../../providers/worship_provider.dart';

/// White centered card for duas/dhikr in guide screens.
class GuideDuaCard extends ConsumerWidget {
  const GuideDuaCard({
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.adhkarCardShadow(isDark: isDark),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            color: AppColors.cardSurface(isDark),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      _IconBtn(
                        icon: isFavorite
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_outline_rounded,
                        color: isFavorite
                            ? accentColor
                            : titleColor.withValues(alpha: 0.5),
                        onTap: () {
                          GomanHaptics.tap();
                          ref
                              .read(worshipFavoritesProvider.notifier)
                              .toggle(item.id);
                        },
                      ),
                      const SizedBox(width: 4),
                      _IconBtn(
                        icon: Icons.ios_share_rounded,
                        color: titleColor.withValues(alpha: 0.5),
                        onTap: () => _share(item),
                      ),
                    ],
                  ),
                  if (item.title.isNotEmpty) ...[
                    Text(
                      item.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoNaskhArabic(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    item.body,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoNaskhArabic(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      height: 1.85,
                      color: titleColor.withValues(alpha: 0.92),
                    ),
                  ),
                  if (item.repeatHint != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      item.repeatHint!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tajawal(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: accentColor.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                  if (item.reference != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      item.reference!,
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
          ),
        ),
      ),
    );
  }

  Future<void> _share(WorshipItem item) async {
    GomanHaptics.tap();
    await Share.share('${item.title}\n\n${item.body}'.trim());
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GomanInkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      enableScale: false,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}

/// Gradient intro hero for guide sections.
class GuideHeroCard extends StatelessWidget {
  const GuideHeroCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isDark,
    this.icon = Icons.menu_book_rounded,
    this.gradient,
  });

  final String title;
  final String subtitle;
  final bool isDark;
  final IconData icon;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.primaryBrandGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.adhkarCardShadow(isDark: isDark),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.onPrimary, size: 28),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoNaskhArabic(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.onPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.tajawal(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.45,
              color: AppColors.onPrimary.withValues(alpha: 0.78),
            ),
          ),
        ],
      ),
    );
  }
}

/// Rawatib timeline row with قبل/بعد badge and rak'ah chip.
class GuideTimelineRow extends StatelessWidget {
  const GuideTimelineRow({
    super.key,
    required this.item,
    required this.isDark,
    required this.accentColor,
    required this.isLast,
  });

  final WorshipItem item;
  final bool isDark;
  final Color accentColor;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final timing = item.metaString('timing');
    final rakahs = item.metaInt('rakahs');
    final titleColor = isDark ? AppColors.surfaceLight : AppColors.primary;
    final timingLabel = timing == 'before'
        ? 'قبل'
        : timing == 'after'
            ? 'بعد'
            : null;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentColor,
                    border: Border.all(
                      color: AppColors.cardSurface(isDark),
                      width: 2,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: accentColor.withValues(alpha: 0.25),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: AppColors.adhkarCardShadow(isDark: isDark),
                ),
                child: Material(
                  color: AppColors.cardSurface(isDark),
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (timingLabel != null)
                              _Chip(
                                label: timingLabel,
                                color: accentColor,
                              ),
                            if (rakahs != null) ...[
                              const SizedBox(width: 6),
                              _Chip(
                                label: '$rakahs ركعات',
                                color: AppColors.secondary,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoNaskhArabic(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: titleColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.body,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.tajawal(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                            color: titleColor.withValues(alpha: 0.75),
                          ),
                        ),
                        if (item.reference != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            item.reference!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.tajawal(
                              fontSize: 11,
                              color: accentColor.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.tajawal(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

/// Friday / sunnah checklist tile.
class GuideChecklistTile extends StatefulWidget {
  const GuideChecklistTile({
    super.key,
    required this.item,
    required this.isDark,
    required this.accentColor,
  });

  final WorshipItem item;
  final bool isDark;
  final Color accentColor;

  @override
  State<GuideChecklistTile> createState() => _GuideChecklistTileState();
}

class _GuideChecklistTileState extends State<GuideChecklistTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final titleColor =
        widget.isDark ? AppColors.surfaceLight : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppColors.adhkarCardShadow(isDark: widget.isDark),
        ),
        child: Material(
          color: AppColors.cardSurface(widget.isDark),
          borderRadius: BorderRadius.circular(14),
          child: GomanInkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: widget.accentColor,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.item.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoNaskhArabic(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: titleColor,
                          ),
                        ),
                      ),
                      Icon(
                        _expanded
                            ? Icons.expand_less_rounded
                            : Icons.expand_more_rounded,
                        color: titleColor.withValues(alpha: 0.45),
                      ),
                    ],
                  ),
                  if (_expanded) ...[
                    const SizedBox(height: 10),
                    Text(
                      widget.item.body,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tajawal(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                        color: titleColor.withValues(alpha: 0.8),
                      ),
                    ),
                    if (widget.item.benefit != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.item.benefit!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.tajawal(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                    if (widget.item.reference != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        widget.item.reference!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.tajawal(
                          fontSize: 11,
                          color: widget.accentColor.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Numbered etiquette step card.
class GuideEtiquetteStepCard extends StatelessWidget {
  const GuideEtiquetteStepCard({
    super.key,
    required this.item,
    required this.isDark,
    required this.accentColor,
  });

  final WorshipItem item;
  final bool isDark;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final step = item.metaInt('stepNumber') ?? item.sortOrder + 1;
    final titleColor = isDark ? AppColors.surfaceLight : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: AppColors.primaryBrandGradient,
              borderRadius: BorderRadius.circular(11),
            ),
            alignment: Alignment.center,
            child: Text(
              '$step',
              style: GoogleFonts.tajawal(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.onPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: AppColors.adhkarCardShadow(isDark: isDark),
              ),
              child: Material(
                color: AppColors.cardSurface(isDark),
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        item.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoNaskhArabic(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.body,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.tajawal(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          color: titleColor.withValues(alpha: 0.78),
                        ),
                      ),
                      if (item.reference != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          item.reference!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.tajawal(
                            fontSize: 11,
                            color: accentColor.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Expandable ruling accordion panel.
class GuideAccordionPanel extends StatefulWidget {
  const GuideAccordionPanel({
    super.key,
    required this.item,
    required this.isDark,
    required this.accentColor,
  });

  final WorshipItem item;
  final bool isDark;
  final Color accentColor;

  @override
  State<GuideAccordionPanel> createState() => _GuideAccordionPanelState();
}

class _GuideAccordionPanelState extends State<GuideAccordionPanel> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final titleColor =
        widget.isDark ? AppColors.surfaceLight : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppColors.adhkarCardShadow(isDark: widget.isDark),
        ),
        child: Material(
          color: AppColors.cardSurface(widget.isDark),
          borderRadius: BorderRadius.circular(14),
          child: GomanInkWell(
            onTap: () => setState(() => _open = !_open),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.gavel_rounded,
                        color: widget.accentColor,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.item.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoNaskhArabic(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: titleColor,
                          ),
                        ),
                      ),
                      Icon(
                        _open
                            ? Icons.expand_less_rounded
                            : Icons.expand_more_rounded,
                        color: titleColor.withValues(alpha: 0.45),
                      ),
                    ],
                  ),
                  if (_open) ...[
                    const SizedBox(height: 10),
                    Text(
                      widget.item.body,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tajawal(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.55,
                        color: titleColor.withValues(alpha: 0.82),
                      ),
                    ),
                    if (widget.item.reference != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.item.reference!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.tajawal(
                          fontSize: 11,
                          color: widget.accentColor.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Step card for duha and similar guides.
class GuideStepCard extends StatelessWidget {
  const GuideStepCard({
    super.key,
    required this.item,
    required this.isDark,
    required this.accentColor,
    required this.icon,
  });

  final WorshipItem item;
  final bool isDark;
  final Color accentColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? AppColors.surfaceLight : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppColors.adhkarCardShadow(isDark: isDark),
        ),
        child: Material(
          color: AppColors.cardSurface(isDark),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(icon, color: accentColor, size: 24),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoNaskhArabic(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.body,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tajawal(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    color: titleColor.withValues(alpha: 0.78),
                  ),
                ),
                if (item.reference != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    item.reference!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.tajawal(
                      fontSize: 11,
                      color: accentColor.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Forbidden time window band card.
class GuideTimeWindowCard extends StatelessWidget {
  const GuideTimeWindowCard({
    super.key,
    required this.item,
    required this.isDark,
    required this.timeLabel,
    required this.isProhibited,
  });

  final WorshipItem item;
  final bool isDark;
  final String? timeLabel;
  final bool isProhibited;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? AppColors.surfaceLight : AppColors.primary;
    final bandColor = isProhibited
        ? const Color(0xFFC62828)
        : const Color(0xFF2E7D32);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppColors.adhkarCardShadow(isDark: isDark),
        ),
        child: Material(
          color: AppColors.cardSurface(isDark),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (timeLabel != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: bandColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: bandColor.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Text(
                      timeLabel!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tajawal(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: bandColor,
                      ),
                    ),
                  ),
                if (timeLabel != null) const SizedBox(height: 10),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoNaskhArabic(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.body,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tajawal(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    color: titleColor.withValues(alpha: 0.78),
                  ),
                ),
                if (item.reference != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.reference!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.tajawal(
                      fontSize: 11,
                      color: AppColors.secondary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Section header inside guide screens (e.g. prayer name in timeline).
class GuideSectionHeader extends StatelessWidget {
  const GuideSectionHeader({
    super.key,
    required this.label,
    required this.accentColor,
  });

  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: GoogleFonts.notoNaskhArabic(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: accentColor,
        ),
      ),
    );
  }
}

const guidePrayerLabels = <String, String>{
  'fajr': 'الفجر',
  'dhuhr': 'الظهر',
  'asr': 'العصر',
  'maghrib': 'المغرب',
  'isha': 'العشاء',
};
