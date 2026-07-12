import 'package:adhan/adhan.dart';

import '../data/models/prayer_location.dart';
import 'prayer_location_timezone.dart';

abstract final class PrayerCalculationConfig {
  static CalculationMethod methodFor(PrayerLocation location) {
    final timezoneId = PrayerLocationTimezone.forLocation(location);
    return switch (timezoneId) {
      'Africa/Cairo' => CalculationMethod.egyptian,
      'Asia/Dubai' => CalculationMethod.dubai,
      'Asia/Kuwait' || 'Asia/Qatar' || 'Asia/Bahrain' => CalculationMethod.kuwait,
      'Asia/Riyadh' => CalculationMethod.umm_al_qura,
      _ => CalculationMethod.muslim_world_league,
    };
  }

  static CalculationParameters parametersFor(PrayerLocation location) {
    final params = methodFor(location).getParameters();
    params.madhab = Madhab.shafi;
    return params;
  }
}
