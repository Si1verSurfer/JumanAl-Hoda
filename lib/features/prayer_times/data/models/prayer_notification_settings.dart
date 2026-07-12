class PrayerNotificationSettings {
  const PrayerNotificationSettings({
    this.masterEnabled = true,
    this.fajr = true,
    this.sunrise = false,
    this.dhuhr = true,
    this.asr = true,
    this.maghrib = true,
    this.isha = true,
    this.selectedAzan = 'azano',
    this.azkarEvening = true,
    this.azkarMorning = true,
    this.kahfFriday = true,
  });

  static const validAzanSounds = ['azano', 'azant', 'azanc', 'azand'];

  final bool masterEnabled;
  final bool fajr;
  final bool sunrise;
  final bool dhuhr;
  final bool asr;
  final bool maghrib;
  final bool isha;
  final String selectedAzan;
  final bool azkarEvening;
  final bool azkarMorning;
  final bool kahfFriday;

  String get resolvedAzanSound {
    final sound = selectedAzan.trim().toLowerCase();
    return validAzanSounds.contains(sound) ? sound : 'azano';
  }

  bool isEnabledFor(String prayerKey) {
    if (!masterEnabled) return false;
    return switch (prayerKey) {
      'fajr' => fajr,
      'sunrise' => sunrise,
      'dhuhr' => dhuhr,
      'asr' => asr,
      'maghrib' => maghrib,
      'isha' => isha,
      _ => false,
    };
  }

  PrayerNotificationSettings copyWith({
    bool? masterEnabled,
    bool? fajr,
    bool? sunrise,
    bool? dhuhr,
    bool? asr,
    bool? maghrib,
    bool? isha,
    String? selectedAzan,
    bool? azkarEvening,
    bool? azkarMorning,
    bool? kahfFriday,
  }) {
    return PrayerNotificationSettings(
      masterEnabled: masterEnabled ?? this.masterEnabled,
      fajr: fajr ?? this.fajr,
      sunrise: sunrise ?? this.sunrise,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
      selectedAzan: selectedAzan ?? this.selectedAzan,
      azkarEvening: azkarEvening ?? this.azkarEvening,
      azkarMorning: azkarMorning ?? this.azkarMorning,
      kahfFriday: kahfFriday ?? this.kahfFriday,
    );
  }

  Map<String, dynamic> toJson() => {
        'masterEnabled': masterEnabled,
        'fajr': fajr,
        'sunrise': sunrise,
        'dhuhr': dhuhr,
        'asr': asr,
        'maghrib': maghrib,
        'isha': isha,
        'selectedAzan': selectedAzan,
        'azkarEvening': azkarEvening,
        'azkarMorning': azkarMorning,
        'kahfFriday': kahfFriday,
      };

  factory PrayerNotificationSettings.fromJson(Map<String, dynamic> json) {
    return PrayerNotificationSettings(
      masterEnabled: json['masterEnabled'] as bool? ?? true,
      fajr: json['fajr'] as bool? ?? true,
      sunrise: json['sunrise'] as bool? ?? false,
      dhuhr: json['dhuhr'] as bool? ?? true,
      asr: json['asr'] as bool? ?? true,
      maghrib: json['maghrib'] as bool? ?? true,
      isha: json['isha'] as bool? ?? true,
      selectedAzan: json['selectedAzan'] as String? ?? 'azano',
      azkarEvening: json['azkarEvening'] as bool? ?? true,
      azkarMorning: json['azkarMorning'] as bool? ?? true,
      kahfFriday: json['kahfFriday'] as bool? ?? true,
    );
  }
}
