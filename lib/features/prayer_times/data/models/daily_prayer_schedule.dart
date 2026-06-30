import 'package:adhan/adhan.dart';

enum PrayerTimeKind {
  fajr,
  sunrise,
  dhuhr,
  asr,
  maghrib,
  isha,
}

class PrayerTimeEntry {
  const PrayerTimeEntry({
    required this.kind,
    required this.name,
    required this.time,
    required this.isPast,
    required this.isNext,
    this.isSalah = true,
  });

  final PrayerTimeKind kind;
  final String name;
  final DateTime time;
  final bool isPast;
  final bool isNext;
  final bool isSalah;
}

class DailyPrayerSchedule {
  const DailyPrayerSchedule({
    required this.date,
    required this.dateDisplay,
    required this.hijriLabel,
    required this.gregorianLabel,
    required this.entries,
    required this.nextSalah,
    required this.nextSalahTime,
    required this.locationLabel,
  });

  final DateTime date;
  final PrayerDateDisplay dateDisplay;
  final String hijriLabel;
  final String gregorianLabel;
  final List<PrayerTimeEntry> entries;
  final PrayerTimeKind nextSalah;
  final DateTime nextSalahTime;
  final String locationLabel;

  String nextSalahName() {
    return entries
        .firstWhere((entry) => entry.kind == nextSalah)
        .name;
  }
}

class PrayerDateDisplay {
  const PrayerDateDisplay({
    required this.weekdayName,
    required this.hijriMonthName,
    required this.hijriPill,
    required this.gregorianPill,
  });

  final String weekdayName;
  final String hijriMonthName;
  final String hijriPill;
  final String gregorianPill;
}

PrayerTimeKind prayerKindFromAdhan(Prayer prayer) {
  return switch (prayer) {
    Prayer.fajr => PrayerTimeKind.fajr,
    Prayer.sunrise => PrayerTimeKind.sunrise,
    Prayer.dhuhr => PrayerTimeKind.dhuhr,
    Prayer.asr => PrayerTimeKind.asr,
    Prayer.maghrib => PrayerTimeKind.maghrib,
    Prayer.isha => PrayerTimeKind.isha,
    Prayer.none => PrayerTimeKind.fajr,
  };
}

Prayer adhanPrayerFromKind(PrayerTimeKind kind) {
  return switch (kind) {
    PrayerTimeKind.fajr => Prayer.fajr,
    PrayerTimeKind.sunrise => Prayer.sunrise,
    PrayerTimeKind.dhuhr => Prayer.dhuhr,
    PrayerTimeKind.asr => Prayer.asr,
    PrayerTimeKind.maghrib => Prayer.maghrib,
    PrayerTimeKind.isha => Prayer.isha,
  };
}
