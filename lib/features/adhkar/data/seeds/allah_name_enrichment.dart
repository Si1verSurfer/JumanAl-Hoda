import '../models/worship_item.dart';

/// Enriches base أسماء الله entries with Qur'an refs, virtues, and duas.
abstract final class AllahNameEnrichment {
  static const _hadithBenefit =
      'قال النبي ﷺ: «إِنَّ لِلَّهِ تِسْعًا وَتِسْعِينَ اسْمًا، مِائَةً إِلَّا وَاحِدًا؛ مَنْ أَحْصَاهَا دَخَلَ الْجَنَّةَ» متفق عليه.';

  static const _defaultQuran =
      '﴿وَلِلَّهِ الْأَسْمَاءُ الْحُسْنَى فَادْعُوهُ بِهَا وَذَرُوا الَّذِينَ يُلْحِدُونَ فِي أَسْمَائِهِ﴾ — سورة الإسراء: ١١٠';

  static List<WorshipItem> enrichAll(List<WorshipItem> base) =>
      base.map(enrich).toList(growable: false);

  static WorshipItem enrich(WorshipItem item) {
    final extra = _specific[item.id];
    return WorshipItem(
      id: item.id,
      categoryId: item.categoryId,
      title: item.title,
      body: item.body,
      sortOrder: item.sortOrder,
      repeatHint: item.repeatHint,
      reference: item.reference ?? extra?.hadith,
      quranReference: extra?.quran ?? _defaultQuran,
      benefit: extra?.benefit ?? _hadithBenefit,
      invocation: extra?.dua ?? _duaFor(item.title),
    );
  }

  static String _duaFor(String name) =>
      'اللَّهُمَّ إِنِّي أَسْأَلُكَ بِاسْمِكَ $name أَنْ تَغْفِرَ لِي ذَنْبِي، وَتُصَلِّحَ لِي شَأْنِي كُلَّهُ، وَتُدْخِلَنِي الْجَنَّةَ.';

  static const _specific = <String, _AllahExtra>{
    'name_01': _AllahExtra(
      quran: '﴿اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ﴾ — سورة البقرة: ٢٥٥',
      benefit:
          'الاسم الأعظم الذي إذا دُعيَ به أجاب، وإذا سُئل به أعطى. قال ﷺ: «أَقْرَبُ مَا يَكُونُ الْعَبْدُ مِنْ رَبِّهِ وَهُوَ سَاجِدٌ».',
      dua:
          'اللَّهُمَّ إِنِّي أَسْأَلُكَ بِاسْمِكَ الأَعْظَمِ أَنْ تَغْفِرَ لِي وَتَرْحَمَنِي.',
      hadith: 'رواه الترمذي',
    ),
    'name_02': _AllahExtra(
      quran: '﴿الرَّحْمَٰنُ عَلَى الْعَرْشِ اسْتَوَىٰ﴾ — سورة طه: ٥',
      benefit:
          'اسم عموم الرحمة؛ وسعت رحمته كل شيء. من أدرك رحمة الرحمن أدرك الدنيا والآخرة.',
      dua:
          'يَا رَحْمَٰنُ يَا رَحْمَٰنُ يَا رَحْمَٰنُ، ارْحَمْنِي بِرَحْمَتِكَ الَّتِي وَسِعَتْ كُلَّ شَيْءٍ.',
    ),
    'name_03': _AllahExtra(
      quran: '﴿وَكَانَ بِالْمُؤْمِنِينَ رَحِيمًا﴾ — سورة الأحزاب: ٤٣',
      benefit: 'يخص المؤمنين برحمته في الدنيا بالتوفيق، وفي الآخرة بالجنة.',
    ),
    'name_04': _AllahExtra(
      quran: '﴿لِلَّهِ مُلْكُ السَّمَاوَاتِ وَالْأَرْضِ﴾ — سورة آل عمران: ١٨٩',
      benefit: 'من عرف أن الملك لله وحده، أمن من خوف المخلوقين.',
    ),
    'name_05': _AllahExtra(
      quran: '﴿هُوَ اللَّهُ الَّذِي لَا إِلَٰهَ إِلَّا هُوَ الْمَلِكُ الْقُدُّوسُ﴾ — سورة الحشر: ٢٣',
    ),
    'name_17': _AllahExtra(
      quran: '﴿أَمَّنْ هُوَ قَنَّاتٌ آنَاءَ اللَّيْلِ سَاجِدًا وَقَائِمًا يَحْذَرُ الْآخِرَةَ وَيَرْجُو رَحْمَةَ رَبِّهِ﴾ — سورة الزمر: ٩',
      benefit: 'من سأل الوهاب أعطاه بلا حساب، فإنه كثير الهبات.',
      dua: 'اللَّهُمَّ إِنَّكَ وَهَّابٌ فَهَبْ لِي مِنْ لَدُنْكَ رَحْمَةً.',
    ),
    'name_18': _AllahExtra(
      quran: '﴿إِنَّ اللَّهَ هُوَ الرَّزَّاقُ ذُو الْقُوَّةِ الْمَتِينُ﴾ — سورة الذاريات: ٥٨',
      benefit: 'من توكل على الرزاق كفاه الله، ومن خاف الفقر فُتِح عليه باب الشح.',
    ),
    'name_20': _AllahExtra(
      quran: '﴿وَهُوَ بِكُلِّ شَيْءٍ عَلِيمٌ﴾ — سورة البقرة: ٢٩',
      benefit: 'من استحضر علم الله بقلبه، حرص على الخلوة والاستغفار.',
    ),
    'name_35': _AllahExtra(
      quran: '﴿إِنَّهُ غَفُورٌ شَكُورٌ﴾ — سورة الشورى: ٢٣',
      benefit: 'من تاب إلى الغفور غفر الله له ذنبه، وإن كان كالزبد في البحر.',
      dua: 'رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ.',
    ),
    'name_63': _AllahExtra(
      quran: '﴿اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ﴾ — سورة البقرة: ٢٥٥',
      benefit: 'الحي الذي لا يموت؛ من تعلق باسم الحي لم ييأس.',
    ),
    'name_64': _AllahExtra(
      quran: '﴿اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ﴾ — سورة البقرة: ٢٥٥',
      benefit: 'القيوم على كل شيء بتدبيره؛ لا تأخذه سنة ولا نوم.',
    ),
    'name_83': _AllahExtra(
      quran: 'قال ﷺ لعائشة: «اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي» — رواه الترمذي',
      benefit: 'من لجأ إلى العفو في العشر الأواخر من رمضان، رجا المغفرة.',
      dua: 'اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي.',
      hadith: 'رواه الترمذي',
    ),
    'name_94': _AllahExtra(
      quran: '﴿اللَّهُ نُورُ السَّمَاوَاتِ وَالْأَرْضِ﴾ — سورة النور: ٣٥',
      benefit: 'من سأل الله النور أضاء قلبه، ونور بصيرته في الدنيا والآخرة.',
      dua:
          'اللَّهُمَّ اجْعَلْ فِي قَلْبِي نُورًا، وَفِي بَصَرِي نُورًا، وَفِي سَمْعِي نُورًا.',
    ),
  };
}

final class _AllahExtra {
  const _AllahExtra({
    this.quran,
    this.benefit,
    this.dua,
    this.hadith,
  });

  final String? quran;
  final String? benefit;
  final String? dua;
  final String? hadith;
}
