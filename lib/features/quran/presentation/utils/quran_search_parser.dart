import 'package:qcf_quran/qcf_quran.dart';

class QuranSearchAyahRef {
  const QuranSearchAyahRef({
    required this.surahNumber,
    required this.verseNumber,
  });

  final int surahNumber;
  final int verseNumber;
}

class QuranSearchSurahMatch {
  const QuranSearchSurahMatch({required this.surahNumber});

  final int surahNumber;
}

class QuranSearchAyahMatch {
  const QuranSearchAyahMatch({
    required this.surahNumber,
    required this.verseNumber,
  });

  final int surahNumber;
  final int verseNumber;
}

class QuranSearchResults {
  const QuranSearchResults({
    this.directAyah,
    this.surahs = const [],
    this.ayahTextMatches = const [],
  });

  final QuranSearchAyahRef? directAyah;
  final List<QuranSearchSurahMatch> surahs;
  final List<QuranSearchAyahMatch> ayahTextMatches;
}

String toWesternDigits(String input) {
  const arabic = '٠١٢٣٤٥٦٧٨٩';
  const eastern = '۰۱۲۳۴۵۶۷۸۹';
  final buffer = StringBuffer();

  for (final code in input.runes) {
    final char = String.fromCharCode(code);
    final arabicIndex = arabic.indexOf(char);
    if (arabicIndex >= 0) {
      buffer.write(arabicIndex);
      continue;
    }
    final easternIndex = eastern.indexOf(char);
    if (easternIndex >= 0) {
      buffer.write(easternIndex);
      continue;
    }
    buffer.write(char);
  }

  return buffer.toString();
}

QuranSearchAyahRef? parseAyahReference(String query) {
  final normalized = toWesternDigits(query.trim())
      .replaceAll('،', ':')
      .replaceAll('/', ':')
      .replaceAll('-', ':');
  final match = RegExp(r'^(\d+)\s*:\s*(\d+)$').firstMatch(normalized);
  if (match == null) return null;

  final surah = int.tryParse(match.group(1)!);
  final verse = int.tryParse(match.group(2)!);
  if (surah == null || verse == null) return null;
  if (surah < 1 || surah > totalSurahCount) return null;
  if (verse < 1 || verse > getVerseCount(surah)) return null;

  return QuranSearchAyahRef(surahNumber: surah, verseNumber: verse);
}

QuranSearchResults searchQuran(String query) {
  final trimmed = query.trim();
  if (trimmed.isEmpty) {
    return const QuranSearchResults();
  }

  final directAyah = parseAyahReference(trimmed);
  final western = toWesternDigits(trimmed);
  final lower = trimmed.toLowerCase();

  final surahMatches = <QuranSearchSurahMatch>[];
  final seenSurahs = <int>{};

  final surahNumber = int.tryParse(western);
  if (surahNumber != null &&
      surahNumber >= 1 &&
      surahNumber <= totalSurahCount) {
    seenSurahs.add(surahNumber);
    surahMatches.add(QuranSearchSurahMatch(surahNumber: surahNumber));
  }

  for (var i = 1; i <= totalSurahCount; i++) {
    if (seenSurahs.contains(i)) continue;

    final arabicName = getSurahNameArabic(i);
    final englishName = getSurahNameEnglish(i).toLowerCase();
    if (arabicName.contains(trimmed) ||
        englishName.contains(lower) ||
        getSurahName(i).toLowerCase().contains(lower)) {
      seenSurahs.add(i);
      surahMatches.add(QuranSearchSurahMatch(surahNumber: i));
    }
  }

  final ayahMatches = <QuranSearchAyahMatch>[];
  if (trimmed.length >= 2) {
    final hits = searchWords(trimmed);
    final list = hits['result'];
    if (list is List) {
      for (final item in list) {
        if (item is! Map) continue;
        final surah = int.tryParse(item['suraNumber'].toString());
        final verse = int.tryParse(item['verseNumber'].toString());
        if (surah == null || verse == null) continue;
        ayahMatches.add(
          QuranSearchAyahMatch(surahNumber: surah, verseNumber: verse),
        );
      }
    }
  }

  return QuranSearchResults(
    directAyah: directAyah,
    surahs: surahMatches,
    ayahTextMatches: ayahMatches,
  );
}
