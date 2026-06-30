import 'package:qcf_quran/qcf_quran.dart';

/// Primary surah shown on a mushaf page (first surah block on the page).
int getPrimarySurahForPage(int pageNumber) {
  final ranges = getPageData(pageNumber.clamp(1, totalPagesCount));
  if (ranges.isEmpty) return 1;
  return int.parse(ranges.first['surah'].toString());
}
