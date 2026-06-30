class SavedAyahCard {
  const SavedAyahCard({
    required this.id,
    required this.surahNumber,
    required this.verseNumbers,
    required this.savedAt,
    this.imagePath,
  });

  static const maxVerses = 3;

  final String id;
  final int surahNumber;
  final List<int> verseNumbers;
  final int savedAt;
  final String? imagePath;

  int get firstVerse => verseNumbers.first;

  bool containsVerse(int verseNumber) => verseNumbers.contains(verseNumber);

  bool get isFull => verseNumbers.length >= maxVerses;

  factory SavedAyahCard.fromJson(Map<String, dynamic> json) {
    final surahNumber = json['surahNumber'] as int? ?? 0;
    final verses = json['verseNumbers'] as List<dynamic>?;
    final verseNumbers = verses != null
        ? verses.map((v) => v as int).toList()
        : [json['verseNumber'] as int? ?? 0];

    return SavedAyahCard(
      id: json['id'] as String? ?? '$surahNumber:${verseNumbers.join('-')}',
      surahNumber: surahNumber,
      verseNumbers: verseNumbers,
      savedAt: json['savedAt'] as int? ?? 0,
      imagePath: json['imagePath'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'surahNumber': surahNumber,
        'verseNumbers': verseNumbers,
        'savedAt': savedAt,
        if (imagePath != null) 'imagePath': imagePath,
      };

  SavedAyahCard copyWith({
    String? id,
    int? surahNumber,
    List<int>? verseNumbers,
    int? savedAt,
    String? imagePath,
    bool clearImagePath = false,
  }) {
    return SavedAyahCard(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      verseNumbers: verseNumbers ?? this.verseNumbers,
      savedAt: savedAt ?? this.savedAt,
      imagePath: clearImagePath ? null : imagePath ?? this.imagePath,
    );
  }
}
