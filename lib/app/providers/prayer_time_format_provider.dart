import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/data/prayer_time_format_storage.dart';

final prayerTimeFormatStorageProvider =
    Provider((ref) => PrayerTimeFormatStorage());

/// Prayer clock display: `false` = 12-hour (default), `true` = 24-hour.
final prayerTimeFormatProvider =
    AsyncNotifierProvider<PrayerTimeFormatNotifier, bool>(
  PrayerTimeFormatNotifier.new,
);

class PrayerTimeFormatNotifier extends AsyncNotifier<bool> {
  PrayerTimeFormatStorage get _storage =>
      ref.read(prayerTimeFormatStorageProvider);

  @override
  Future<bool> build() => _storage.loadIs24Hour();

  Future<void> setIs24Hour(bool value) async {
    state = AsyncData(value);
    await _storage.saveIs24Hour(value);
  }

  Future<void> set12Hour() => setIs24Hour(false);

  Future<void> set24Hour() => setIs24Hour(true);
}
