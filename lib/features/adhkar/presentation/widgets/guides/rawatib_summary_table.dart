import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/worship_item.dart';
import 'guide_widgets.dart';

/// Quick-reference table: obligatory prayer with sunnah before/after.
class RawatibSummaryTable extends StatelessWidget {
  const RawatibSummaryTable({
    super.key,
    required this.items,
    required this.isDark,
    required this.accentColor,
  });

  final List<WorshipItem> items;
  final bool isDark;
  final Color accentColor;

  static const _prayerOrder = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];

  static const _prayerIcons = <String, IconData>{
    'fajr': Icons.wb_twilight_rounded,
    'dhuhr': Icons.wb_sunny_rounded,
    'asr': Icons.light_mode_rounded,
    'maghrib': Icons.wb_cloudy_rounded,
    'isha': Icons.nights_stay_rounded,
  };

  List<_CellBadge> _badgesFor(String prayerKey, String timing) {
    final rituals = items.where(
      (item) =>
          item.kind == 'ritual' &&
          item.metaString('prayerKey') == prayerKey &&
          item.metaString('timing') == timing,
    );

    final badges = <_CellBadge>[];
    for (final item in rituals) {
      final rakahs = item.metaInt('rakahs');
      if (rakahs != null && rakahs > 0) {
        badges.add(_CellBadge.rakahs(rakahs));
      } else if (item.title.contains('وتر')) {
        badges.add(const _CellBadge.witr());
      }
    }
    return badges;
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.surfaceLight : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: AppColors.adhkarCardShadow(isDark: isDark),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: isDark
                ? [
                    AppColors.surfaceDarkElevated,
                    AppColors.surfaceDark,
                  ]
                : [
                    AppColors.mushafPaper,
                    AppColors.glassLight,
                  ],
          ),
          border: Border.all(
            color: accentColor.withValues(alpha: isDark ? 0.24 : 0.12),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(21),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TableBanner(isDark: isDark, accentColor: accentColor),
              _ColumnHeaderRow(isDark: isDark, accentColor: accentColor),
              for (var i = 0; i < _prayerOrder.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                    color: accentColor.withValues(alpha: isDark ? 0.14 : 0.08),
                  ),
                _PrayerRow(
                  label: guidePrayerLabels[_prayerOrder[i]] ?? _prayerOrder[i],
                  icon: _prayerIcons[_prayerOrder[i]] ?? Icons.mosque_rounded,
                  before: _badgesFor(_prayerOrder[i], 'before'),
                  after: _badgesFor(_prayerOrder[i], 'after'),
                  isDark: isDark,
                  accentColor: accentColor,
                  textColor: textColor,
                  stripe: i.isOdd,
                ),
              ],
              _TableFooter(isDark: isDark, accentColor: accentColor),
            ],
          ),
        ),
      ),
    );
  }
}

class _CellBadge {
  const _CellBadge.rakahs(this.rakahs) : isWitr = false;
  const _CellBadge.witr() : rakahs = null, isWitr = true;

  final int? rakahs;
  final bool isWitr;
}

class _TableBanner extends StatelessWidget {
  const _TableBanner({required this.isDark, required this.accentColor});

  final bool isDark;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            accentColor,
            AppColors.primary,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.table_chart_rounded,
              size: 18,
              color: AppColors.onPrimary.withValues(alpha: 0.9),
            ),
            const SizedBox(width: 8),
            Text(
              'ملخّص السنن الراتبة',
              style: GoogleFonts.tajawal(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColumnHeaderRow extends StatelessWidget {
  const _ColumnHeaderRow({required this.isDark, required this.accentColor});

  final bool isDark;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final labelColor = isDark
        ? AppColors.surfaceLight.withValues(alpha: 0.75)
        : AppColors.secondary.withValues(alpha: 0.8);

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      child: Row(
        children: [
          Expanded(
            flex: 14,
            child: Text(
              'الصلاة',
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: labelColor,
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: _ColumnHeaderChip(
              label: 'قبل',
              sublabel: 'الفرض',
              color: accentColor.withValues(alpha: 0.85),
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: 10,
            child: _ColumnHeaderChip(
              label: 'بعد',
              sublabel: 'الفرض',
              color: AppColors.primary.withValues(alpha: 0.85),
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _ColumnHeaderChip extends StatelessWidget {
  const _ColumnHeaderChip({
    required this.label,
    required this.sublabel,
    required this.color,
    required this.isDark,
  });

  final String label;
  final String sublabel;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.18 : 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.tajawal(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            sublabel,
            style: GoogleFonts.tajawal(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: color.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerRow extends StatelessWidget {
  const _PrayerRow({
    required this.label,
    required this.icon,
    required this.before,
    required this.after,
    required this.isDark,
    required this.accentColor,
    required this.textColor,
    required this.stripe,
  });

  final String label;
  final IconData icon;
  final List<_CellBadge> before;
  final List<_CellBadge> after;
  final bool isDark;
  final Color accentColor;
  final Color textColor;
  final bool stripe;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: stripe
          ? accentColor.withValues(alpha: isDark ? 0.05 : 0.025)
          : Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(
          children: [
            Expanded(
              flex: 14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          accentColor.withValues(alpha: 0.18),
                          accentColor.withValues(alpha: 0.06),
                        ],
                      ),
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Icon(icon, size: 17, color: accentColor),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      label,
                      style: GoogleFonts.notoNaskhArabic(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 10,
              child: _BadgeCell(
                badges: before,
                accentColor: accentColor,
                isDark: isDark,
                variant: _BadgeVariant.before,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              flex: 10,
              child: _BadgeCell(
                badges: after,
                accentColor: accentColor,
                isDark: isDark,
                variant: _BadgeVariant.after,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _BadgeVariant { before, after }

class _BadgeCell extends StatelessWidget {
  const _BadgeCell({
    required this.badges,
    required this.accentColor,
    required this.isDark,
    required this.variant,
  });

  final List<_CellBadge> badges;
  final Color accentColor;
  final bool isDark;
  final _BadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) {
      return Center(
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: accentColor.withValues(alpha: isDark ? 0.06 : 0.04),
          ),
          child: Icon(
            Icons.remove_rounded,
            size: 16,
            color: accentColor.withValues(alpha: 0.22),
          ),
        ),
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 4,
      runSpacing: 4,
      children: [
        for (final badge in badges)
          _RakahBadge(
            badge: badge,
            accentColor: accentColor,
            isDark: isDark,
            variant: variant,
          ),
      ],
    );
  }
}

class _RakahBadge extends StatelessWidget {
  const _RakahBadge({
    required this.badge,
    required this.accentColor,
    required this.isDark,
    required this.variant,
  });

  final _CellBadge badge;
  final Color accentColor;
  final bool isDark;
  final _BadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final isWitr = badge.isWitr;
    final baseColor =
        variant == _BadgeVariant.before ? accentColor : AppColors.primary;

    if (isWitr) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: baseColor.withValues(alpha: isDark ? 0.22 : 0.1),
          border: Border.all(color: baseColor.withValues(alpha: 0.28)),
        ),
        child: Text(
          'وتر',
          style: GoogleFonts.notoNaskhArabic(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: baseColor,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            baseColor.withValues(alpha: isDark ? 0.55 : 0.88),
            baseColor.withValues(alpha: isDark ? 0.38 : 0.72),
          ],
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: baseColor.withValues(alpha: 0.22),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Text(
        '${badge.rakahs}',
        style: GoogleFonts.tajawal(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: AppColors.onPrimary,
        ),
      ),
    );
  }
}

class _TableFooter extends StatelessWidget {
  const _TableFooter({required this.isDark, required this.accentColor});

  final bool isDark;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: isDark ? 0.08 : 0.04),
        border: Border(
          top: BorderSide(
            color: accentColor.withValues(alpha: isDark ? 0.16 : 0.1),
          ),
        ),
      ),
      child: Text(
        'المجموع: ١٢ ركعة راتبة يوميًا — والوتر سنة مؤكدة بعد العشاء',
        textAlign: TextAlign.center,
        style: GoogleFonts.tajawal(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          height: 1.45,
          color: accentColor.withValues(alpha: isDark ? 0.78 : 0.72),
        ),
      ),
    );
  }
}
