import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/goman_scaffold.dart';
import '../../../../prayer_times/data/models/daily_prayer_schedule.dart';
import '../../../../prayer_times/presentation/providers/prayer_time_label_provider.dart';
import '../../../../prayer_times/presentation/providers/prayer_times_provider.dart';
import '../../../data/models/worship_item.dart';
import '../../providers/worship_provider.dart';
import '../../theme/worship_page_style.dart';
import '../../widgets/guides/guide_widgets.dart';

class ForbiddenTimesScreen extends ConsumerWidget {
  const ForbiddenTimesScreen({super.key});

  static const categoryId = 'forbidden_times';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final category = ref.watch(worshipCategoryProvider(categoryId));
    final items = ref.watch(worshipItemsProvider(categoryId));
    final schedule = ref.watch(prayerScheduleProvider);
    final formatTime = ref.watch(prayerTimeLabelProvider);
    final accent = category?.accentColor ?? AppColors.secondary;

    final windows = items.where((e) => e.kind == 'time_window');
    final evidence = items.where((e) => e.kind != 'time_window');

    return GomanScaffold(
      title: category?.title ?? 'أوقات النهي',
      body: Container(
        color: WorshipPageStyle.background(isDark),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          children: [
            GuideHeroCard(
              isDark: isDark,
              icon: Icons.block_rounded,
              title: 'أوقات النهي عن الصلاة',
              subtitle: 'أوقات يُنهى فيها عن الصلاة والصوم عند طلوع الشمس',
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFC62828).withValues(alpha: 0.9),
                  AppColors.primary,
                ],
              ),
            ),
            if (schedule != null) ...[
              _LiveTimeline(
                schedule: schedule,
                isDark: isDark,
                formatTime: formatTime,
              ),
              const SizedBox(height: 12),
            ] else
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'فعّل الموقع في المواقيت لعرض الأوقات الفعلية لهذا اليوم',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tajawal(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary.withValues(alpha: 0.75),
                  ),
                ),
              ),
            for (final item in windows)
              GuideTimeWindowCard(
                item: item,
                isDark: isDark,
                timeLabel: _timeLabelFor(item, schedule, formatTime),
                isProhibited: true,
              ),
            GuideSectionHeader(label: 'الأدلة من السنة', accentColor: accent),
            for (final item in evidence)
              GuideTimeWindowCard(
                item: item,
                isDark: isDark,
                timeLabel: null,
                isProhibited: false,
              ),
          ],
        ),
      ),
    );
  }

  String? _timeLabelFor(
    WorshipItem item,
    DailyPrayerSchedule? schedule,
    String Function(DateTime) formatTime,
  ) {
    if (schedule == null) return item.metaString('timeLabel');
    final key = item.metaString('windowKey');
    DateTime? start;
    DateTime? end;
    for (final e in schedule.entries) {
      if (key == 'after_fajr' && e.kind == PrayerTimeKind.fajr) {
        start = e.time;
      }
      if (key == 'after_fajr' && e.kind == PrayerTimeKind.sunrise) {
        end = e.time;
      }
      if (key == 'zenith' && e.kind == PrayerTimeKind.dhuhr) {
        start = e.time.subtract(const Duration(minutes: 10));
        end = e.time.add(const Duration(minutes: 10));
      }
      if (key == 'after_asr' && e.kind == PrayerTimeKind.asr) {
        start = e.time;
      }
      if (key == 'after_asr' && e.kind == PrayerTimeKind.maghrib) {
        end = e.time;
      }
    }
    if (start != null && end != null) {
      return '${formatTime(start)} — ${formatTime(end)}';
    }
    return item.metaString('timeLabel');
  }
}

class _LiveTimeline extends StatelessWidget {
  const _LiveTimeline({
    required this.schedule,
    required this.isDark,
    required this.formatTime,
  });

  final DailyPrayerSchedule schedule;
  final bool isDark;
  final String Function(DateTime) formatTime;

  @override
  Widget build(BuildContext context) {
    final salah = schedule.entries.where((e) => e.isSalah).toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardSurface(isDark),
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppColors.adhkarCardShadow(isDark: isDark),
      ),
      child: Column(
        children: [
          Text(
            'مواقيت اليوم',
            style: GoogleFonts.notoNaskhArabic(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.surfaceLight : AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final e in salah)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: e.isNext
                        ? AppColors.secondary.withValues(alpha: 0.12)
                        : AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${e.name} ${formatTime(e.time)}',
                    style: GoogleFonts.tajawal(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.surfaceLight
                          : AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
