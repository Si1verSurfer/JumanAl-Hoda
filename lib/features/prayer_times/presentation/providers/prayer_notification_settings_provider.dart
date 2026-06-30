import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/prayer_notification_settings.dart';
import '../../data/prayer_notification_settings_storage.dart';
import 'prayer_schedule_sync_provider.dart';

final prayerNotificationSettingsStorageProvider =
    Provider<PrayerNotificationSettingsStorage>(
  (ref) => PrayerNotificationSettingsStorage(),
);

final prayerNotificationSettingsProvider = StateNotifierProvider<
    PrayerNotificationSettingsNotifier, PrayerNotificationSettings>(
  (ref) => PrayerNotificationSettingsNotifier(ref),
);

class PrayerNotificationSettingsNotifier
    extends StateNotifier<PrayerNotificationSettings> {
  PrayerNotificationSettingsNotifier(this._ref)
      : super(const PrayerNotificationSettings()) {
    _load();
  }

  final Ref _ref;

  Future<void> _load() async {
    final storage = _ref.read(prayerNotificationSettingsStorageProvider);
    state = await storage.load();
  }

  Future<void> updateSettings(PrayerNotificationSettings settings) async {
    state = settings;
    await _ref.read(prayerNotificationSettingsStorageProvider).save(settings);
    await _ref.read(prayerScheduleSyncProvider.notifier).syncAll();
  }

  Future<void> setMasterEnabled(bool value) =>
      updateSettings(state.copyWith(masterEnabled: value));

  Future<void> setPrayerEnabled(String key, bool value) {
    return updateSettings(
      switch (key) {
        'fajr' => state.copyWith(fajr: value),
        'sunrise' => state.copyWith(sunrise: value),
        'dhuhr' => state.copyWith(dhuhr: value),
        'asr' => state.copyWith(asr: value),
        'maghrib' => state.copyWith(maghrib: value),
        'isha' => state.copyWith(isha: value),
        _ => state,
      },
    );
  }
}
