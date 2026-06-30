class QuranLastReading {
  const QuranLastReading({
    required this.page,
    required this.surahNumber,
    required this.verseNumber,
    this.readAt,
  });

  final int page;
  final int surahNumber;
  final int verseNumber;
  final DateTime? readAt;

  factory QuranLastReading.fromJson(Map<String, dynamic> json) {
    final readAtMs = json['readAt'] as int?;
    return QuranLastReading(
      page: json['page'] as int? ?? 1,
      surahNumber: json['surahNumber'] as int? ?? 1,
      verseNumber: json['verseNumber'] as int? ?? 1,
      readAt: readAtMs == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(readAtMs),
    );
  }

  Map<String, dynamic> toJson() => {
        'page': page,
        'surahNumber': surahNumber,
        'verseNumber': verseNumber,
        if (readAt != null) 'readAt': readAt!.millisecondsSinceEpoch,
      };

  QuranLastReading copyWith({
    int? page,
    int? surahNumber,
    int? verseNumber,
    DateTime? readAt,
  }) {
    return QuranLastReading(
      page: page ?? this.page,
      surahNumber: surahNumber ?? this.surahNumber,
      verseNumber: verseNumber ?? this.verseNumber,
      readAt: readAt ?? this.readAt,
    );
  }
}
