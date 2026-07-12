import 'dart:math' as math;

/// Coordinates of the Kaaba in Makkah.
abstract final class QiblahConstants {
  static const double kaabaLatitude = 21.422487;
  static const double kaabaLongitude = 39.826206;
}

/// Bearing in degrees clockwise from true north (0–360).
double qiblahBearingDegrees({
  required double latitude,
  required double longitude,
}) {
  final lat1 = _toRadians(latitude);
  final lat2 = _toRadians(QiblahConstants.kaabaLatitude);
  final deltaLng = _toRadians(QiblahConstants.kaabaLongitude - longitude);

  final y = math.sin(deltaLng) * math.cos(lat2);
  final x = math.cos(lat1) * math.sin(lat2) -
      math.sin(lat1) * math.cos(lat2) * math.cos(deltaLng);

  return (_toDegrees(math.atan2(y, x)) + 360) % 360;
}

double normalizeDegrees(double degrees) => (degrees % 360 + 360) % 360;

double _toRadians(double degrees) => degrees * math.pi / 180;

double _toDegrees(double radians) => radians * 180 / math.pi;
