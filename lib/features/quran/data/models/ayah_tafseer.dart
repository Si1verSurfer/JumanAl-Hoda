class AyahTafseer {
  const AyahTafseer({
    required this.text,
    required this.resourceName,
    required this.verseKey,
    required this.bookSlug,
    required this.cachedAt,
  });

  final String text;
  final String resourceName;
  final String verseKey;
  final String bookSlug;
  final int cachedAt;

  factory AyahTafseer.fromJson(Map<String, dynamic> json) {
    return AyahTafseer(
      text: json['text'] as String? ?? '',
      resourceName: json['resourceName'] as String? ?? '',
      verseKey: json['verseKey'] as String? ?? '',
      bookSlug: json['bookSlug'] as String? ?? '',
      cachedAt: json['cachedAt'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'text': text,
        'resourceName': resourceName,
        'verseKey': verseKey,
        'bookSlug': bookSlug,
        'cachedAt': cachedAt,
      };

  AyahTafseer copyWith({
    String? text,
    String? resourceName,
    String? verseKey,
    String? bookSlug,
    int? cachedAt,
  }) {
    return AyahTafseer(
      text: text ?? this.text,
      resourceName: resourceName ?? this.resourceName,
      verseKey: verseKey ?? this.verseKey,
      bookSlug: bookSlug ?? this.bookSlug,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }
}
