import 'package:qcf_quran/qcf_quran.dart';

import 'quran_search_parser.dart';

enum QuranDivisionFilter { all, juz, hizb }

List<int> baseSurahsForDivision({
  required QuranDivisionFilter division,
  required int juzNumber,
  required int hizbNumber,
}) {
  return switch (division) {
    QuranDivisionFilter.all =>
      List.generate(totalSurahCount, (index) => index + 1),
    QuranDivisionFilter.juz => getSurahsInJuz(juzNumber),
    QuranDivisionFilter.hizb => getSurahsInHizb(hizbNumber),
  };
}

List<int> resolveVisibleSurahs({
  required String query,
  required QuranDivisionFilter division,
  required int juzNumber,
  required int hizbNumber,
}) {
  final base = baseSurahsForDivision(
    division: division,
    juzNumber: juzNumber,
    hizbNumber: hizbNumber,
  );

  final trimmed = query.trim();
  if (trimmed.isEmpty) return base;

  final matches =
      searchQuran(trimmed).surahs.map((match) => match.surahNumber).toSet();
  return base.where(matches.contains).toList();
}

bool hasAyahSearchResults(String query, QuranSearchResults results) {
  if (query.trim().isEmpty) return false;
  return results.directAyah != null || results.ayahTextMatches.isNotEmpty;
}
