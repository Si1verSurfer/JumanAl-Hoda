enum PrayerLocationSource { gps, manual }

class PrayerLocation {
  const PrayerLocation({
    required this.latitude,
    required this.longitude,
    required this.label,
    required this.source,
  });

  final double latitude;
  final double longitude;
  final String label;
  final PrayerLocationSource source;

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'label': label,
        'source': source.name,
      };

  factory PrayerLocation.fromJson(Map<String, dynamic> json) {
    return PrayerLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      label: json['label'] as String,
      source: PrayerLocationSource.values.byName(json['source'] as String),
    );
  }
}

class PopularCity {
  const PopularCity({
    required this.label,
    required this.latitude,
    required this.longitude,
  });

  final String label;
  final double latitude;
  final double longitude;
}

const popularPrayerCities = [
  PopularCity(label: 'الرياض', latitude: 24.7136, longitude: 46.6753),
  PopularCity(label: 'مكة المكرمة', latitude: 21.4225, longitude: 39.8262),
  PopularCity(label: 'جدة', latitude: 21.5433, longitude: 39.1728),
  PopularCity(label: 'المدينة المنورة', latitude: 24.4672, longitude: 39.6111),
  PopularCity(label: 'القاهرة', latitude: 30.0444, longitude: 31.2357),
  PopularCity(label: 'دبي', latitude: 25.2048, longitude: 55.2708),
];
