import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/ayah_tafseer.dart';

export 'models/ayah_tafseer.dart';

abstract final class QuranTafseerApi {
  static const _baseUrl = 'https://api.qurancdn.com/api/qdc/tafsirs';

  static Future<AyahTafseer> fetchAyahTafseer({
    required int surahNumber,
    required int verseNumber,
    required String tafsirSlug,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/$tafsirSlug/by_ayah/$surahNumber:$verseNumber',
    );
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

    final rawHtml = tafsir['text']?.toString() ?? '';
    if (rawHtml.trim().isEmpty) {
      throw const QuranTafseerException('لا يتوفر تفسير لهذه الآية.');
    }

    return AyahTafseer(
      text: rawHtml,
      resourceName: tafsir['resource_name']?.toString() ?? '',
      verseKey: '$surahNumber:$verseNumber',
      bookSlug: tafsirSlug,
      cachedAt: 0,
    );
  }
}

class QuranTafseerException implements Exception {
  const QuranTafseerException(this.message);

  final String message;

  @override
  String toString() => message;
}
