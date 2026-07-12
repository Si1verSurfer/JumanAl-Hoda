import 'package:qcf_quran/qcf_quran.dart';

import '../../data/models/quran_mushaf_theme.dart';
import 'quran_cream_mushaf_theme.dart';

abstract final class QuranQcfTheme {
  static QcfThemeData forMushafTheme(QuranMushafTheme theme) {
    if (theme == QuranMushafTheme.cream) {
      return QuranCreamMushafTheme.build(
        QuranMushafThemes.specFor(theme),
      );
    }

    final spec = QuranMushafThemes.specFor(theme);
    return QcfThemeData(
      verseTextColor: spec.verseText,
      verseNumberColor: spec.verseNumber,
      basmalaColor: spec.basmala,
      headerTextColor: spec.headerText,
      pageBackgroundColor: spec.pageBackground,
      headerFrameColor: spec.headerFrame,
    );
  }
}
