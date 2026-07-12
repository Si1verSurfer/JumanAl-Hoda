import '../models/prayer_location.dart';
import '../../domain/prayer_location_timezone.dart';

/// Aladhan API calculation methods per region.
/// See https://api.aladhan.com/v1/methods
abstract final class AladhanMethodConfig {
  static const int methodUmmAlQuraKsa = 4;
  static const int methodEgypt = 5;
  static const int methodGulf = 8;
  static const int methodKuwait = 9;
  static const int methodQatar = 10;
  static const int methodUae = 16;
  static const int methodSingapore = 20;
  static const int methodTurkey = 13;
  static const int methodRussia = 21;
  static const int methodNorthAmerica = 2;
  static const int methodEurope = 12;
  static const int methodMorocco = 3;
  static const int methodAlgeria = 5;
  static const int methodTunisia = 1;
  static const int methodIndonesia = 11;
  static const int methodMalaysia = 20;

  static int calculationMethodForCountry(String? country) {
    if (country == null || country.isEmpty) return methodEgypt;
    final c = country.trim().toLowerCase();
    if (c.contains('saudi') ||
        c == 'sa' ||
        c == 'ksa' ||
        c.contains('المملكة')) {
      return methodUmmAlQuraKsa;
    }
    if (c.contains('kuwait')) return methodKuwait;
    if (c.contains('qatar')) return methodQatar;
    if (c.contains('uae') ||
        c.contains('emirates') ||
        c.contains('dubai') ||
        c.contains('الإمارات')) {
      return methodUae;
    }
    if (c.contains('bahrain') ||
        c.contains('oman') ||
        c.contains('gulf') ||
        c.contains('yemen')) {
      return methodGulf;
    }
    if (c.contains('singapore')) return methodSingapore;
    if (c.contains('turkey') || c.contains('türkiye')) return methodTurkey;
    if (c.contains('russia')) return methodRussia;
    if (c.contains('united states') ||
        c.contains('usa') ||
        c.contains('america') ||
        c.contains('canada')) {
      return methodNorthAmerica;
    }
    if (c.contains('united kingdom') ||
        c.contains('uk') ||
        c.contains('britain') ||
        c.contains('germany') ||
        c.contains('france')) {
      return methodEurope;
    }
    if (c.contains('morocco')) return methodMorocco;
    if (c.contains('algeria')) return methodAlgeria;
    if (c.contains('tunisia')) return methodTunisia;
    if (c.contains('indonesia')) return methodIndonesia;
    if (c.contains('malaysia')) return methodMalaysia;
    if (c.contains('egypt') || c.contains('مصر')) return methodEgypt;
    return methodEgypt;
  }

  static int calculationMethodForLocation(PrayerLocation location) {
    if (location.country != null && location.country!.isNotEmpty) {
      return calculationMethodForCountry(location.country);
    }
    final timezoneId = PrayerLocationTimezone.forLocation(location);
    return switch (timezoneId) {
      'Africa/Cairo' => methodEgypt,
      'Asia/Dubai' => methodUae,
      'Asia/Kuwait' => methodKuwait,
      'Asia/Qatar' => methodQatar,
      'Asia/Bahrain' => methodGulf,
      'Asia/Riyadh' => methodUmmAlQuraKsa,
      _ => methodEgypt,
    };
  }
}
