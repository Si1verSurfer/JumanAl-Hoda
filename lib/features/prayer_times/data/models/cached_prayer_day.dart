import '../models/daily_prayer_schedule.dart';

class CachedPrayerDay {
  const CachedPrayerDay({
    required this.dayKey,
    required this.latitude,
    required this.longitude,
    required this.timesIso,
  });

  final String dayKey;
  final double latitude;
  final double longitude;
  final Map<String, String> timesIso;

  static const prayerKeys = [
    'fajr',
    'sunrise',
    'dhuhr',
    'asr',
    'maghrib',
    'isha',
  ];

  DateTime? timeFor(PrayerTimeKind kind) {
    final raw = timesIso[kind.name];
    if (raw == null) return null;
    return DateTime.parse(raw);
  }

  Map<String, dynamic> toJson() => {
        'dayKey': dayKey,
        'latitude': latitude,
        'longitude': longitude,
        'timesIso': timesIso,
      };

  factory CachedPrayerDay.fromJson(Map<String, dynamic> json) {
    return CachedPrayerDay(
      dayKey: json['dayKey'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timesIso: Map<String, String>.from(json['timesIso'] as Map),
    );
  }

  static String dayKeyFor(DateTime date) {
    final local = DateTime(date.year, date.month, date.day);
    return '${local.year.toString().padLeft(4, '0')}-'
        '${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')}';
  }
}
