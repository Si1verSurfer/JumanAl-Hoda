class WorshipItem {
  const WorshipItem({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.body,
    required this.sortOrder,
    this.reference,
    this.repeatHint,
    this.quranReference,
    this.benefit,
    this.invocation,
    this.kind,
    this.meta,
  });

  final String id;
  final String categoryId;
  final String title;
  final String body;
  final int sortOrder;
  final String? reference;
  /// e.g. «مرة واحدة»، «٣ مرات» — from حصن المسلم.
  final String? repeatHint;
  final String? quranReference;
  final String? benefit;
  final String? invocation;
  /// ritual | virtue | dua | dhikr | etiquette | ruling | time_window | checklist
  final String? kind;
  final Map<String, dynamic>? meta;

  String? metaString(String key) => meta?[key]?.toString();

  int? metaInt(String key) {
    final value = meta?[key];
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoryId': categoryId,
        'title': title,
        'body': body,
        'sortOrder': sortOrder,
        if (reference != null) 'reference': reference,
        if (repeatHint != null) 'repeatHint': repeatHint,
        if (quranReference != null) 'quranReference': quranReference,
        if (benefit != null) 'benefit': benefit,
        if (invocation != null) 'invocation': invocation,
        if (kind != null) 'kind': kind,
        if (meta != null) 'meta': meta,
      };

  factory WorshipItem.fromJson(Map<String, dynamic> json) {
    return WorshipItem(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      sortOrder: json['sortOrder'] as int,
      reference: json['reference'] as String?,
      repeatHint: json['repeatHint'] as String?,
      quranReference: json['quranReference'] as String?,
      benefit: json['benefit'] as String?,
      invocation: json['invocation'] as String?,
      kind: json['kind'] as String?,
      meta: json['meta'] == null
          ? null
          : Map<String, dynamic>.from(json['meta'] as Map),
    );
  }
}
