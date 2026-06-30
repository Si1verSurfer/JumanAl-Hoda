class PrayerNotificationSettings {
  const PrayerNotificationSettings({
    this.masterEnabled = true,
    this.fajr = true,
    this.sunrise = false,
    this.dhuhr = true,
    this.asr = true,
    this.maghrib = true,
    this.isha = true,
  });

  final bool masterEnabled;
  final bool fajr;
  final bool sunrise;
  final bool dhuhr;
  final bool asr;
  final bool maghrib;
  final bool isha;

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
  }) {
    return PrayerNotificationSettings(
      masterEnabled: masterEnabled ?? this.masterEnabled,
      fajr: fajr ?? this.fajr,
      sunrise: sunrise ?? this.sunrise,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
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
    );
  }
}
