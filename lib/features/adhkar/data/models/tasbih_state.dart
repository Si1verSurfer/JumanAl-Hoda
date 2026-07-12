class TasbihState {
  const TasbihState({
    required this.dhikr,
    required this.target,
    required this.count,
    this.hapticsEnabled = true,
  });

  static const defaultDhikr = 'سُبْحَانَ اللَّهِ';
  static const defaultTarget = 33;

  static const defaults = TasbihState(
    dhikr: defaultDhikr,
    target: defaultTarget,
    count: 0,
    hapticsEnabled: true,
  );

  final String dhikr;
  final int target;
  final int count;
  final bool hapticsEnabled;

  double get progress =>
      target <= 0 ? 0 : (count / target).clamp(0.0, 1.0);

  int get progressPercent => (progress * 100).round();

  bool get isComplete => target > 0 && count >= target;

  TasbihState copyWith({
    String? dhikr,
    int? target,
    int? count,
    bool? hapticsEnabled,
  }) {
    return TasbihState(
      dhikr: dhikr ?? this.dhikr,
      target: target ?? this.target,
      count: count ?? this.count,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    );
  }
}

class TasbihPreset {
  const TasbihPreset({required this.dhikr, required this.target});

  final String dhikr;
  final int target;
}

abstract final class TasbihPresets {
  static const list = [
    TasbihPreset(dhikr: 'سُبْحَانَ اللَّهِ', target: 33),
    TasbihPreset(dhikr: 'الْحَمْدُ لِلَّهِ', target: 33),
    TasbihPreset(dhikr: 'اللَّهُ أَكْبَرُ', target: 34),
    TasbihPreset(dhikr: 'لَا إِلَٰهَ إِلَّا اللَّهُ', target: 100),
    TasbihPreset(dhikr: 'أَسْتَغْفِرُ اللَّهَ', target: 100),
  ];
}
