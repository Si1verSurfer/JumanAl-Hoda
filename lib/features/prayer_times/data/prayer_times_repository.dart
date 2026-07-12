import 'package:adhan/adhan.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../core/constants/app_strings.dart';
import '../domain/prayer_calculation_config.dart';
import '../domain/prayer_location_timezone.dart';
import 'aladhan/aladhan_api_client.dart';
import 'aladhan/aladhan_method_config.dart';
import 'aladhan/aladhan_prayer_times.dart';
import 'constants/prayer_arabic_labels.dart';
import 'models/cached_prayer_day.dart';
import 'models/daily_prayer_schedule.dart';
import 'models/prayer_location.dart';

class PrayerTimesRepository {
  CalculationParameters _parameters(PrayerLocation location) =>
      PrayerCalculationConfig.parametersFor(location);

  PrayerTimes _prayerTimesFor({
    required PrayerLocation location,
    required DateComponents dateComponents,
    required DateTime day,
  }) {
    final coords = Coordinates(location.latitude, location.longitude);
    final params = _parameters(location);
    final timezoneId = PrayerLocationTimezone.forLocation(location);
    final offset = PrayerLocationTimezone.utcOffsetFor(timezoneId, day);
    return PrayerTimes.utcOffset(coords, dateComponents, params, offset);
  }

  DateTime cityNow(PrayerLocation location) {
    final timezoneId = PrayerLocationTimezone.forLocation(location);
    return PrayerLocationTimezone.nowIn(timezoneId);
  }

  DateTime _referenceInLocation(PrayerLocation location, DateTime? reference) {
    if (reference != null) {
      return PrayerLocationTimezone.wallClock(reference);
    }
    return cityNow(location);
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
    final wall = PrayerLocationTimezone.wallClock(time);
    final hour = wall.hour.toString().padLeft(2, '0');
    final minute = wall.minute.toString().padLeft(2, '0');
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
    final now = _referenceInLocation(location, reference);
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
    final prayerTimes = _prayerTimesFor(
      location: location,
      dateComponents: DateComponents.from(localDay),
      day: localDay,
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

  Future<CachedPrayerDay> computeDayTimesAsync({
    required PrayerLocation location,
    required DateTime day,
  }) async {
    final localDay = DateTime(day.year, day.month, day.day);
    final fromApi = await _fetchDayFromApi(location: location, day: localDay);
    if (fromApi != null) return fromApi;

    return computeDayTimes(location: location, day: localDay);
  }

  Future<List<CachedPrayerDay>> computeDaysAsync({
    required PrayerLocation location,
    required DateTime start,
    int count = 30,
  }) async {
    final startDay = DateTime(start.year, start.month, start.day);
    final fromApi = await fetchDaysFromApi(
      location: location,
      start: startDay,
      count: count,
    );

    final days = <CachedPrayerDay>[];
    for (var i = 0; i < count; i++) {
      final day = startDay.add(Duration(days: i));
      final key = CachedPrayerDay.dayKeyFor(day);
      days.add(fromApi[key] ?? computeDayTimes(location: location, day: day));
    }
    return days;
  }

  /// Batch fetch via Aladhan calendar API (1–2 HTTP calls for 30 days).
  Future<Map<String, CachedPrayerDay>> fetchDaysFromApi({
    required PrayerLocation location,
    required DateTime start,
    required int count,
  }) async {
    final startDay = DateTime(start.year, start.month, start.day);
    final endDay = startDay.add(Duration(days: count - 1));
    final timezoneId = PrayerLocationTimezone.forLocation(location);
    final method = AladhanMethodConfig.calculationMethodForLocation(location);

    final months = <String, (int year, int month)>{};
    var cursor = startDay;
    while (!cursor.isAfter(endDay)) {
      months['${cursor.year}-${cursor.month}'] = (cursor.year, cursor.month);
      cursor = DateTime(cursor.year, cursor.month + 1, 1);
    }

    final result = <String, CachedPrayerDay>{};
    for (final entry in months.entries) {
      final (year, month) = entry.value;
      final monthData = await AladhanApiClient.fetchCalendarMonth(
        year: year,
        month: month,
        latitude: location.latitude,
        longitude: location.longitude,
        country: location.country,
        timezone: timezoneId,
        methodOverride: method,
      );
      if (monthData == null) continue;

      for (final item in monthData) {
        final day = _cachedDayFromCalendarEntry(item, location);
        if (day == null) continue;
        if (day.dayKey.compareTo(CachedPrayerDay.dayKeyFor(startDay)) >= 0 &&
            day.dayKey.compareTo(CachedPrayerDay.dayKeyFor(endDay)) <= 0) {
          result[day.dayKey] = day;
        }
      }
    }
    return result;
  }

  CachedPrayerDay? _cachedDayFromCalendarEntry(
    Map<String, dynamic> item,
    PrayerLocation location,
  ) {
    try {
      final apiTimes = AladhanPrayerTimes.fromJson(item);
      final date = item['date'] as Map<String, dynamic>;
      final gregorian = date['gregorian'] as Map<String, dynamic>;
      final parts = (gregorian['date'] as String).split('-');
      if (parts.length != 3) return null;
      final day = DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );

      final timesIso = <String, String>{};
      for (final key in CachedPrayerDay.prayerKeys) {
        final parsed = _parseApiTime(apiTimes.timeForKind(key), day);
        if (parsed == null) return null;
        timesIso[key] = parsed.toIso8601String();
      }

      return CachedPrayerDay(
        dayKey: CachedPrayerDay.dayKeyFor(day),
        latitude: location.latitude,
        longitude: location.longitude,
        timesIso: timesIso,
      );
    } catch (_) {
      return null;
    }
  }

  Future<CachedPrayerDay?> _fetchDayFromApi({
    required PrayerLocation location,
    required DateTime day,
  }) async {
    final timezoneId = PrayerLocationTimezone.forLocation(location);
    final apiTimes = await AladhanApiClient.fetchTimingsForDate(
      latitude: location.latitude,
      longitude: location.longitude,
      date: day,
      country: location.country,
      timezone: timezoneId,
      methodOverride: AladhanMethodConfig.calculationMethodForLocation(location),
    );
    if (apiTimes == null) return null;

    final timesIso = <String, String>{};
    for (final key in CachedPrayerDay.prayerKeys) {
      final parsed = _parseApiTime(apiTimes.timeForKind(key), day);
      if (parsed == null) return null;
      timesIso[key] = parsed.toIso8601String();
    }

    return CachedPrayerDay(
      dayKey: CachedPrayerDay.dayKeyFor(day),
      latitude: location.latitude,
      longitude: location.longitude,
      timesIso: timesIso,
    );
  }

  DateTime? _parseApiTime(String timeStr, DateTime day) {
    try {
      final cleaned = timeStr.replaceAll(RegExp(r'\s*\([^)]*\)'), '').trim();
      final parts = cleaned.split(':');
      if (parts.isEmpty) return null;

      final hour = int.tryParse(parts[0].trim()) ?? -1;
      if (hour < 0 || hour > 23) return null;

      final minutePart = parts.length > 1
          ? parts[1].split(RegExp(r'\s+')).first.trim()
          : '0';
      var minute = int.tryParse(minutePart) ?? 0;
      if (minute < 0 || minute > 59) minute = 0;

      return DateTime(day.year, day.month, day.day, hour, minute);
    } catch (_) {
      return null;
    }
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
    final now = _referenceInLocation(location, reference);
    final localDay = DateTime.parse('${cachedDay.dayKey}T00:00:00');
    final prayerTimes = _prayerTimesFor(
      location: location,
      dateComponents: DateComponents.from(localDay),
      day: localDay,
    );

    final nextSalah = _nextSalahPrayer(prayerTimes, now);
    final nextSalahTime = _nextSalahTime(prayerTimes, location, now);

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
    final raw = cachedDay.timeFor(kind) ?? now;
    final time = PrayerLocationTimezone.wallClock(raw);
    final wallNow = PrayerLocationTimezone.wallClock(now);
    return PrayerTimeEntry(
      kind: kind,
      name: PrayerArabicLabels.prayerDisplayName(kind),
      time: time,
      isPast: time.isBefore(wallNow),
      isNext: kind == nextSalah,
      isSalah: isSalah,
    );
  }

  PrayerTimeKind _nextSalahPrayer(PrayerTimes prayerTimes, DateTime now) {
    final wallNow = PrayerLocationTimezone.wallClock(now);
    var next = prayerTimes.nextPrayerByDateTime(wallNow);
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
    PrayerLocation location,
    DateTime now,
  ) {
    final wallNow = PrayerLocationTimezone.wallClock(now);
    var next = prayerTimes.nextPrayerByDateTime(wallNow);
    if (next == Prayer.sunrise) {
      next = Prayer.dhuhr;
    }
    if (next == Prayer.none) {
      final tomorrow = DateTime(now.year, now.month, now.day + 1);
      final tomorrowTimes = _prayerTimesFor(
        location: location,
        dateComponents: DateComponents.from(tomorrow),
        day: tomorrow,
      );
      return PrayerLocationTimezone.wallClock(tomorrowTimes.fajr);
    }
    return PrayerLocationTimezone.wallClock(prayerTimes.timeForPrayer(next)!);
  }
}
