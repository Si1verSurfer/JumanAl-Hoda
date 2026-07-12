/// Prayer timings returned by the Aladhan API for a single day.
class AladhanPrayerTimes {
  const AladhanPrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.dateReadable,
    required this.hijriDate,
  });

  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String dateReadable;
  final String hijriDate;

  factory AladhanPrayerTimes.fromJson(Map<String, dynamic> json) {
    final timings = json['timings'] as Map<String, dynamic>;
    final date = json['date'] as Map<String, dynamic>;
    final hijri = date['hijri'] as Map<String, dynamic>;

    return AladhanPrayerTimes(
      fajr: _cleanTime(timings['Fajr'] ?? '--'),
      sunrise: _cleanTime(timings['Sunrise'] ?? '--'),
      dhuhr: _cleanTime(timings['Dhuhr'] ?? '--'),
      asr: _cleanTime(timings['Asr'] ?? '--'),
      maghrib: _cleanTime(timings['Maghrib'] ?? '--'),
      isha: _cleanTime(timings['Isha'] ?? '--'),
      dateReadable: date['readable'] as String? ?? '---',
      hijriDate:
          "${hijri['day']} ${hijri['month']['en']} ${hijri['year']} هـ",
    );
  }

  static String _cleanTime(String time) {
    return time.replaceAll(RegExp(r'\s*\([^)]*\)'), '').trim();
  }

  String timeForKind(String kind) {
    return switch (kind) {
      'fajr' => fajr,
      'sunrise' => sunrise,
      'dhuhr' => dhuhr,
      'asr' => asr,
      'maghrib' => maghrib,
      'isha' => isha,
      _ => '--',
    };
  }
}
