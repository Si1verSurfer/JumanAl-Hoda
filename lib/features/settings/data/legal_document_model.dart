class LegalSection {
  const LegalSection({
    required this.title,
    required this.paragraphs,
    this.bullets = const [],
  });

  final String title;
  final List<String> paragraphs;
  final List<String> bullets;
}

class LegalDocumentContent {
  const LegalDocumentContent({
    required this.title,
    required this.lastUpdated,
    required this.intro,
    required this.sections,
  });

  final String title;
  final String lastUpdated;
  final String intro;
  final List<LegalSection> sections;
}
