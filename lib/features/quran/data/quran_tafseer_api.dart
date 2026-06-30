import 'dart:convert';

import 'package:http/http.dart' as http;

class AyahTafseer {
  const AyahTafseer({
    required this.text,
    required this.resourceName,
    required this.verseKey,
  });

  final String text;
  final String resourceName;
  final String verseKey;
}

abstract final class QuranTafseerApi {
  static const _baseUrl = 'https://api.qurancdn.com/api/qdc/tafsirs';
  static const _tafsirSlug = 'ar-tafsir-muyassar';

  static Future<AyahTafseer> fetchAyahTafseer({
    required int surahNumber,
    required int verseNumber,
  }) async {
    final uri = Uri.parse('$_baseUrl/$_tafsirSlug/by_ayah/$surahNumber:$verseNumber');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw QuranTafseerException(
        'تعذّر تحميل التفسير (${response.statusCode})',
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final tafsir = body['tafsir'] as Map<String, dynamic>?;
    if (tafsir == null) {
      throw const QuranTafseerException('لا يتوفر تفسير لهذه الآية.');
    }

    final text = _stripHtml(tafsir['text']?.toString() ?? '').trim();
    if (text.isEmpty) {
      throw const QuranTafseerException('لا يتوفر تفسير لهذه الآية.');
    }

    return AyahTafseer(
      text: text,
      resourceName: tafsir['resource_name']?.toString() ?? 'التفسير الميسر',
      verseKey: '$surahNumber:$verseNumber',
    );
  }

  static String _stripHtml(String input) {
    return input
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}

class QuranTafseerException implements Exception {
  const QuranTafseerException(this.message);

  final String message;

  @override
  String toString() => message;
}
