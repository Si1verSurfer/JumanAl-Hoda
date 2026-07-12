import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/models/prayer_location.dart';
import '../../data/prayer_location_storage.dart';
import '../../domain/prayer_location_timezone.dart';
import '../../notifications/prayer_timezone.dart';

final prayerLocationStorageProvider = Provider<PrayerLocationStorage>(
  (ref) => PrayerLocationStorage(),
);

/// Optional initial location for tests or pre-seeded flows.
final prayerLocationSeedProvider = Provider<PrayerLocation?>((ref) => null);

sealed class PrayerLocationState {}

class PrayerLocationLoading extends PrayerLocationState {}

class PrayerLocationReady extends PrayerLocationState {
  PrayerLocationReady(this.location);

  final PrayerLocation location;
}

class PrayerLocationError extends PrayerLocationState {
  PrayerLocationError(this.message);

  final String message;
}

final prayerLocationProvider =
    StateNotifierProvider<PrayerLocationNotifier, PrayerLocationState>(
  (ref) => PrayerLocationNotifier(ref),
);

class PrayerLocationNotifier extends StateNotifier<PrayerLocationState> {
  PrayerLocationNotifier(this._ref) : super(PrayerLocationLoading()) {
    _initialize();
  }

  final Ref _ref;

  PrayerLocationStorage get _storage =>
      _ref.read(prayerLocationStorageProvider);

  Future<void> _initialize() async {
    final seed = _ref.read(prayerLocationSeedProvider);
    if (seed != null) {
      state = PrayerLocationReady(seed);
      return;
    }

    final saved = await _storage.load();
    if (saved != null) {
      state = PrayerLocationReady(_withTimezone(saved));
      return;
    }
    await refreshFromGps();
  }

  Future<void> refreshFromGps() async {
    final keepCurrentLocation = state is PrayerLocationReady;
    if (!keepCurrentLocation) {
      state = PrayerLocationLoading();
    }
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = PrayerLocationError('خدمة الموقع غير مفعّلة على الجهاز.');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        state = PrayerLocationError('لم يتم السماح بالوصول إلى الموقع.');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 12),
        ),
      );

      final resolved = await _resolvePlace(position.latitude, position.longitude);
      final timezoneId = await PrayerTimezone.localTimezoneName();
      final location = PrayerLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        label: resolved.label,
        source: PrayerLocationSource.gps,
        timezoneId: timezoneId,
        country: resolved.country,
      );
      await _storage.save(location);
      state = PrayerLocationReady(location);
    } catch (_) {
      state = PrayerLocationError('تعذّر تحديد الموقع. اختر مدينة يدوياً.');
    }
  }

  Future<void> setManualLocation({
    required double latitude,
    required double longitude,
    required String label,
    String? timezoneId,
    String? country,
  }) async {
    final location = PrayerLocation(
      latitude: latitude,
      longitude: longitude,
      label: label,
      source: PrayerLocationSource.manual,
      timezoneId: timezoneId ??
          PrayerLocationTimezone.forCoordinates(latitude, longitude),
      country: country,
    );
    await _storage.save(location);
    state = PrayerLocationReady(location);
  }

  PrayerLocation _withTimezone(PrayerLocation location) {
    if (location.timezoneId != null && location.timezoneId!.isNotEmpty) {
      return location;
    }
    return PrayerLocation(
      latitude: location.latitude,
      longitude: location.longitude,
      label: location.label,
      source: location.source,
      timezoneId: PrayerLocationTimezone.forCoordinates(
        location.latitude,
        location.longitude,
      ),
      country: location.country,
    );
  }

  Future<({String label, String? country})> _resolvePlace(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) {
        return (label: 'موقعك الحالي', country: null);
      }
      final place = placemarks.first;
      final parts = <String>[
        if (place.locality?.isNotEmpty == true) place.locality!,
        if (place.subAdministrativeArea?.isNotEmpty == true &&
            place.subAdministrativeArea != place.locality)
          place.subAdministrativeArea!,
        if (place.country?.isNotEmpty == true) place.country!,
      ];
      if (parts.isEmpty) {
        return (label: 'موقعك الحالي', country: place.country);
      }
      return (
        label: parts.take(2).join('، '),
        country: place.country,
      );
    } catch (_) {
      return (label: 'موقعك الحالي', country: null);
    }
  }
}

Future<List<PopularCity>> searchCities(String query) async {
  final trimmed = query.trim();
  if (trimmed.isEmpty) return popularPrayerCities;

  try {
    final locations = await locationFromAddress(trimmed);
    if (locations.isEmpty) return [];
    return locations
        .take(6)
        .map(
          (location) => PopularCity(
            label: trimmed,
            latitude: location.latitude,
            longitude: location.longitude,
            timezoneId: PrayerLocationTimezone.forCoordinates(
              location.latitude,
              location.longitude,
            ),
          ),
        )
        .toList();
  } catch (_) {
    return [];
  }
}
