enum PrayerLocationSource { gps, manual }

class PrayerLocation {
  const PrayerLocation({
    required this.latitude,
    required this.longitude,
    required this.label,
    required this.source,
    this.timezoneId,
    this.country,
  });

  final double latitude;
  final double longitude;
  final String label;
  final PrayerLocationSource source;
  final String? timezoneId;
  final String? country;

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'label': label,
        'source': source.name,
        if (timezoneId != null) 'timezoneId': timezoneId,
        if (country != null) 'country': country,
      };

  factory PrayerLocation.fromJson(Map<String, dynamic> json) {
    final latitude = (json['latitude'] as num).toDouble();
    final longitude = (json['longitude'] as num).toDouble();
    return PrayerLocation(
      latitude: latitude,
      longitude: longitude,
      label: json['label'] as String,
      source: PrayerLocationSource.values.byName(json['source'] as String),
      timezoneId: json['timezoneId'] as String?,
      country: json['country'] as String?,
    );
  }
}

class PopularCity {
  const PopularCity({
    required this.label,
    required this.latitude,
    required this.longitude,
    required this.timezoneId,
    this.country,
  });

  final String label;
  final double latitude;
  final double longitude;
  final String timezoneId;
  final String? country;
}

const popularPrayerCities = [
  PopularCity(
    label: 'الرياض',
    latitude: 24.7136,
    longitude: 46.6753,
    timezoneId: 'Asia/Riyadh',
    country: 'Saudi Arabia',
  ),
  PopularCity(
    label: 'مكة المكرمة',
    latitude: 21.4225,
    longitude: 39.8262,
    timezoneId: 'Asia/Riyadh',
    country: 'Saudi Arabia',
  ),
  PopularCity(
    label: 'جدة',
    latitude: 21.5433,
    longitude: 39.1728,
    timezoneId: 'Asia/Riyadh',
    country: 'Saudi Arabia',
  ),
  PopularCity(
    label: 'المدينة المنورة',
    latitude: 24.4672,
    longitude: 39.6111,
    timezoneId: 'Asia/Riyadh',
    country: 'Saudi Arabia',
  ),
  PopularCity(
    label: 'القاهرة',
    latitude: 30.0444,
    longitude: 31.2357,
    timezoneId: 'Africa/Cairo',
    country: 'Egypt',
  ),
  PopularCity(
    label: 'دبي',
    latitude: 25.2048,
    longitude: 55.2708,
    timezoneId: 'Asia/Dubai',
    country: 'United Arab Emirates',
  ),
];
