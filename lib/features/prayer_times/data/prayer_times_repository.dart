import 'package:adhan/adhan.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../core/constants/app_strings.dart';
import 'constants/prayer_arabic_labels.dart';
import 'models/cached_prayer_day.dart';
import 'models/daily_prayer_schedule.dart';
import 'models/prayer_location.dart';

class PrayerTimesRepository {
  CalculationParameters _parameters() {
    final params = CalculationMethod.umm_al_qura.getParameters();
    params.madhab = Madhab.shafi;
    return params;
  }

  String formatHijriDate(DateTime date) {
    HijriCalendar.setLocal('ar');
    final hijri = HijriCalendar.fromDate(date);
    final day = convertToArabicNumber('${hijri.hDay}');
    final month = hijri.getLongMonthName();
    final year = convertToArabicNumber('${hijri.hYear}');
    return '$day $month $year ${AppStrings.prayerHijriSuffix}';
  }

  String formatGregorianDate(DateTime date) {
    final formatter = DateFormat('EEEE، d MMMM yyyy', 'ar');
    return _toArabicDigits(formatter.format(date));
  }

  PrayerDateDisplay buildDateDisplay(DateTime date) {
    HijriCalendar.setLocal('ar');
    final hijri = HijriCalendar.fromDate(date);
    final weekday = DateFormat('EEEE', 'ar').format(date);
    final hijriYear = hijri.hYear.toString().padLeft(4, '0');
    final hijriMonth = hijri.hMonth.toString().padLeft(2, '0');
    final hijriDay = hijri.hDay.toString().padLeft(2, '0');
    final gregYear = date.year.toString().padLeft(4, '0');
    final gregMonth = date.month.toString().padLeft(2, '0');
    final gregDay = date.day.toString().padLeft(2, '0');

    return PrayerDateDisplay(
      weekdayName: PrayerArabicLabels.weekday(weekday),
      hijriMonthName: PrayerArabicLabels.hijriMonth(hijri.hMonth),
      hijriPill: _toArabicDigits('$hijriYear-$hijriMonth-$hijriDay'),
      gregorianPill: _toArabicDigits('$gregYear-$gregMonth-$gregDay'),
    );
  }

  String formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return _toArabicDigits('$hour:$minute');
  }

  String formatCountdown(Duration remaining) {
    final totalSeconds = remaining.inSeconds.clamp(0, 86400);
    final hours = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return _toArabicDigits('$hours:$minutes:$seconds');
  }

  String _toArabicDigits(String input) {
    const arabics = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return input.replaceAllMapped(RegExp('[0-9]'), (match) {
      return arabics[int.parse(match.group(0)!)];
    });
  }

  DailyPrayerSchedule buildSchedule({
    required PrayerLocation location,
    DateTime? reference,
  }) {
    final now = reference ?? DateTime.now();
    final cached = computeDayTimes(location: location, day: now);
    return buildScheduleFromCache(
      cachedDay: cached,
      location: location,
      reference: now,
    );
  }

  CachedPrayerDay computeDayTimes({
    required PrayerLocation location,
    required DateTime day,
  }) {
    final localDay = DateTime(day.year, day.month, day.day);
    final coords = Coordinates(location.latitude, location.longitude);
    final params = _parameters();
    final prayerTimes = PrayerTimes(
      coords,
      DateComponents.from(localDay),
      params,
    );

    return CachedPrayerDay(
      dayKey: CachedPrayerDay.dayKeyFor(localDay),
      latitude: location.latitude,
      longitude: location.longitude,
      timesIso: {
        PrayerTimeKind.fajr.name: prayerTimes.fajr.toIso8601String(),
        PrayerTimeKind.sunrise.name: prayerTimes.sunrise.toIso8601String(),
        PrayerTimeKind.dhuhr.name: prayerTimes.dhuhr.toIso8601String(),
        PrayerTimeKind.asr.name: prayerTimes.asr.toIso8601String(),
        PrayerTimeKind.maghrib.name: prayerTimes.maghrib.toIso8601String(),
        PrayerTimeKind.isha.name: prayerTimes.isha.toIso8601String(),
      },
    );
  }

  List<CachedPrayerDay> computeDays({
    required PrayerLocation location,
    required DateTime start,
    int count = 30,
  }) {
    final days = <CachedPrayerDay>[];
    final startDay = DateTime(start.year, start.month, start.day);
    for (var i = 0; i < count; i++) {
      final day = startDay.add(Duration(days: i));
      days.add(computeDayTimes(location: location, day: day));
    }
    return days;
  }

  DailyPrayerSchedule buildScheduleFromCache({
    required CachedPrayerDay cachedDay,
    required PrayerLocation location,
    DateTime? reference,
  }) {
    final now = reference ?? DateTime.now();
    final coords = Coordinates(location.latitude, location.longitude);
    final params = _parameters();
    final localDay = DateTime.parse('${cachedDay.dayKey}T00:00:00');
    final prayerTimes = PrayerTimes(
      coords,
      DateComponents.from(localDay),
      params,
    );

    final nextSalah = _nextSalahPrayer(prayerTimes, now);
    final nextSalahTime = _nextSalahTime(prayerTimes, coords, params, now);

    final entries = <PrayerTimeEntry>[
      _entryFromCache(cachedDay, PrayerTimeKind.fajr, now, nextSalah),
      _entryFromCache(
        cachedDay,
        PrayerTimeKind.sunrise,
        now,
        nextSalah,
        isSalah: false,
      ),
      _entryFromCache(cachedDay, PrayerTimeKind.dhuhr, now, nextSalah),
      _entryFromCache(cachedDay, PrayerTimeKind.asr, now, nextSalah),
      _entryFromCache(cachedDay, PrayerTimeKind.maghrib, now, nextSalah),
      _entryFromCache(cachedDay, PrayerTimeKind.isha, now, nextSalah),
    ];

    return DailyPrayerSchedule(
      date: now,
      dateDisplay: buildDateDisplay(now),
      hijriLabel: formatHijriDate(now),
      gregorianLabel: formatGregorianDate(now),
      entries: entries,
      nextSalah: nextSalah,
      nextSalahTime: nextSalahTime,
      locationLabel: location.label,
    );
  }

  PrayerTimeEntry _entryFromCache(
    CachedPrayerDay cachedDay,
    PrayerTimeKind kind,
    DateTime now,
    PrayerTimeKind nextSalah, {
    bool isSalah = true,
  }) {
    final time = cachedDay.timeFor(kind) ?? now;
    return PrayerTimeEntry(
      kind: kind,
      name: PrayerArabicLabels.prayerDisplayName(kind),
      time: time,
      isPast: time.isBefore(now),
      isNext: kind == nextSalah,
      isSalah: isSalah,
    );
  }

  PrayerTimeKind _nextSalahPrayer(PrayerTimes prayerTimes, DateTime now) {
    var next = prayerTimes.nextPrayerByDateTime(now);
    if (next == Prayer.sunrise) {
      next = Prayer.dhuhr;
    }
    if (next == Prayer.none) {
      return PrayerTimeKind.fajr;
    }
    return prayerKindFromAdhan(next);
  }

  DateTime _nextSalahTime(
    PrayerTimes prayerTimes,
    Coordinates coords,
    CalculationParameters params,
    DateTime now,
  ) {
    var next = prayerTimes.nextPrayerByDateTime(now);
    if (next == Prayer.sunrise) {
      next = Prayer.dhuhr;
    }
    if (next == Prayer.none) {
      final tomorrow = DateTime(now.year, now.month, now.day + 1);
      final tomorrowTimes = PrayerTimes(
        coords,
        DateComponents.from(tomorrow),
        params,
      );
      return tomorrowTimes.fajr;
    }
    return prayerTimes.timeForPrayer(next)!;
  }
}
