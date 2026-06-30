enum AyahHighlightColor {
  yellow,
  red,
  green,
}

extension AyahHighlightColorX on AyahHighlightColor {
  String get storageKey => name;

  static AyahHighlightColor fromStorageKey(String key) {
    return AyahHighlightColor.values.firstWhere(
      (color) => color.name == key,
      orElse: () => AyahHighlightColor.yellow,
    );
  }
}

class SavedAyahHighlight {
  const SavedAyahHighlight({
    required this.surahNumber,
    required this.verseNumber,
    required this.color,
    required this.savedAt,
  });

  final int surahNumber;
  final int verseNumber;
  final AyahHighlightColor color;
  final int savedAt;

  String get key => '$surahNumber:$verseNumber';

  factory SavedAyahHighlight.fromJson(Map<String, dynamic> json) {
    return SavedAyahHighlight(
      surahNumber: json['surahNumber'] as int? ?? 0,
      verseNumber: json['verseNumber'] as int? ?? 0,
      color: AyahHighlightColorX.fromStorageKey(
        json['color'] as String? ?? AyahHighlightColor.yellow.name,
      ),
      savedAt: json['savedAt'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'surahNumber': surahNumber,
        'verseNumber': verseNumber,
        'color': color.storageKey,
        'savedAt': savedAt,
      };

  SavedAyahHighlight copyWith({
    AyahHighlightColor? color,
    int? savedAt,
  }) {
    return SavedAyahHighlight(
      surahNumber: surahNumber,
      verseNumber: verseNumber,
      color: color ?? this.color,
      savedAt: savedAt ?? this.savedAt,
    );
  }
}
