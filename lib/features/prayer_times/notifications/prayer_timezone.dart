import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

abstract final class PrayerTimezone {
  static bool _initialized = false;
  static String? _resolvedName;

  static Future<void> configure() async {
    final deviceName = await _resolveDeviceTimezoneName();
    if (_initialized && _resolvedName == deviceName) return;

    tz.initializeTimeZones();
    _resolvedName = deviceName;
    try {
      tz.setLocalLocation(tz.getLocation(deviceName));
    } catch (_) {
      tz.setLocalLocation(_locationForOffset(DateTime.now().timeZoneOffset));
      _resolvedName = tz.local.name;
    }
    _initialized = true;
  }

  static Future<String> _resolveDeviceTimezoneName() async {
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      final identifier = info.identifier.trim();
      if (identifier.isNotEmpty) {
        tz.initializeTimeZones();
        tz.getLocation(identifier);
        return identifier;
      }
    } catch (_) {
      // Fall back to offset-based mapping below.
    }
    return _locationForOffset(DateTime.now().timeZoneOffset).name;
  }

  static tz.Location _locationForOffset(Duration offset) {
    final totalMinutes = offset.inMinutes;
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes.abs() % 60;

    if (minutes == 0) {
      final sign = hours >= 0 ? '-' : '+';
      final name = 'Etc/GMT$sign${hours.abs()}';
      try {
        return tz.getLocation(name);
      } catch (_) {
        return tz.UTC;
      }
    }

    const fixedOffsetZones = <int, String>{
      330: 'Asia/Kolkata',
      345: 'Asia/Kathmandu',
      390: 'Asia/Yangon',
      525: 'Australia/Eucla',
      570: 'Australia/Darwin',
    };
    final zoneName = fixedOffsetZones[totalMinutes];
    if (zoneName != null) {
      try {
        return tz.getLocation(zoneName);
      } catch (_) {
        return tz.UTC;
      }
    }

    return tz.UTC;
  }

  static Future<String> localTimezoneName() async {
    await configure();
    return _resolvedName ?? tz.local.name;
  }

  static tz.Location get local => tz.local;
}
