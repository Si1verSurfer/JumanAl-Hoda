import 'khutbah_constants.dart';

class KhutbahIndexEntry {
  const KhutbahIndexEntry({
    required this.id,
    required this.title,
    required this.slug,
    required this.categoryText,
    required this.authorName,
    required this.pdfFileName,
    this.createdAt,
  });

  final int id;
  final String title;
  final String slug;
  final String categoryText;
  final String authorName;
  final String pdfFileName;
  final String? createdAt;

  bool get hasPdf => pdfFileName.trim().toLowerCase().endsWith('.pdf');

  String get pdfUrl =>
      '${KhutbahConstants.githubPdfBase}/${Uri.encodeComponent(pdfFileName)}';

  factory KhutbahIndexEntry.fromJson(Map<String, dynamic> json) {
    return KhutbahIndexEntry(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      categoryText: json['categoryText'] as String? ?? '',
      authorName: json['authorName'] as String? ?? '',
      pdfFileName: json['pdfFileName'] as String? ?? '',
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'slug': slug,
        'categoryText': categoryText,
        'authorName': authorName,
        'pdfFileName': pdfFileName,
        if (createdAt != null) 'createdAt': createdAt,
      };
}

class KhutbahCategory {
  const KhutbahCategory({
    required this.name,
    required this.count,
  });

  final String name;
  final int count;
}

/// Maps khutbah title to GitHub PDF filename.
String khutbahPdfFileNameFromTitle(String title) {
  return '${title.trim().replaceAll(' ', '_')}.pdf';
}
