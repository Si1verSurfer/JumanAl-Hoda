import '../models/worship_item.dart';

/// آداب الدعاء — من حصن المسلم (باب آداب الدعاء).
abstract final class WorshipSeedDuaEtiquette {
  static const items = <WorshipItem>[
    WorshipItem(
      id: 'dua_etiquette_01',
      categoryId: 'dua_etiquette',
      title: 'الإخلاص في الدعاء',
      sortOrder: 0,
      kind: 'etiquette',
      meta: {'stepNumber': 1},
      reference: 'من السنة',
      body:
          'يَجِبُ أَنْ يَكُونَ الدُّعَاءُ بِإِخْلَاصٍ لِلَّهِ تَعَالَى، فَلَا يُدْعَى إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ.',
    ),
    WorshipItem(
      id: 'dua_etiquette_02',
      categoryId: 'dua_etiquette',
      title: 'البدء بحمد الله والثناء عليه',
      sortOrder: 1,
      kind: 'etiquette',
      meta: {'stepNumber': 2},
      reference: 'رواه أبو داود والترمذي',
      body:
          'إِذَا دَعَا أَحَدُكُمْ فَلْيَبْدَأْ بِحَمْدِ اللَّهِ وَالثَّنَاءِ عَلَيْهِ، ثُمَّ يُصَلِّي عَلَى النَّبِيِّ ﷺ، ثُمَّ يَدْعُو بِمَا شَاءَ.',
    ),
    WorshipItem(
      id: 'dua_etiquette_03',
      categoryId: 'dua_etiquette',
      title: 'الصلاة على النبي ﷺ في الدعاء',
      sortOrder: 2,
      kind: 'etiquette',
      meta: {'stepNumber': 3},
      reference: 'رواه أبو داود والترمذي',
      body:
          'مِنْ آدَابِ الدُّعَاءِ أَنْ يُصَلِّيَ الدَّاعِي عَلَى النَّبِيِّ ﷺ قَبْلَ سُؤَالِ حَاجَتِهِ وَبَعْدَهَا.',
    ),
    WorshipItem(
      id: 'dua_etiquette_04',
      categoryId: 'dua_etiquette',
      title: 'حضور القلب والإقبال على الله',
      sortOrder: 3,
      kind: 'etiquette',
      meta: {'stepNumber': 4},
      reference: 'من السنة',
      body:
          'يُسْتَحَبُّ لِلدَّاعِي أَنْ يَكُونَ قَلْبُهُ حَاضِرًا مُقْبِلًا عَلَى رَبِّهِ، مُحِسًّا بِعَظَمَةِ مَنْ يَدْعُوهُ وَضَعْفِ مَنْ يَدْعُو.',
    ),
    WorshipItem(
      id: 'dua_etiquette_05',
      categoryId: 'dua_etiquette',
      title: 'التضرع والخشوع',
      sortOrder: 4,
      kind: 'etiquette',
      meta: {'stepNumber': 5},
      reference: 'قال تعالى',
      quranReference: 'سورة الأعراف ٥٥',
      body:
          'ادْعُوا رَبَّكُمْ تَضَرُّعًا وَخُفْيَةً ۚ إِنَّهُ لَا يُحِبُّ الْمُعْتَدِينَ. وَيُسْتَحَبُّ أَنْ يَظْهَرَ الْفَقْرُ وَالْحَاجَةُ إِلَى اللَّهِ فِي الدُّعَاءِ.',
    ),
    WorshipItem(
      id: 'dua_etiquette_06',
      categoryId: 'dua_etiquette',
      title: 'رفع اليدين في الدعاء',
      sortOrder: 5,
      kind: 'etiquette',
      meta: {'stepNumber': 6},
      reference: 'رواه أبو داود والترمذي',
      body:
          'إِنَّ رَبَّكُمْ حَيِيٌّ كَرِيمٌ يَسْتَحْيِي مِنْ عَبْدِهِ إِذَا رَفَعَ يَدَيْهِ إِلَيْهِ أَنْ يَرُدَّهُمَا صِفْرًا (خَائِبَتَيْنِ).',
    ),
    WorshipItem(
      id: 'dua_etiquette_07',
      categoryId: 'dua_etiquette',
      title: 'الدعاء بأسماء الله الحسنى',
      sortOrder: 6,
      kind: 'etiquette',
      meta: {'stepNumber': 7},
      reference: 'قال تعالى',
      quranReference: 'سورة الأعراف ١٨٠',
      body:
          'وَلِلَّهِ الْأَسْمَاءُ الْحُسْنَىٰ فَادْعُوهُ بِهَا. وَيُسْتَحَبُّ أَنْ يُنَاسِبَ الدَّاعِي اسْمَ اللَّهَ بِحَاجَتِهِ.',
    ),
    WorshipItem(
      id: 'dua_etiquette_08',
      categoryId: 'dua_etiquette',
      title: 'الإلحاح في الدعاء',
      sortOrder: 7,
      kind: 'etiquette',
      meta: {'stepNumber': 8},
      reference: 'رواه البخاري ومسلم',
      body:
          'يُدْعَى اللَّهُ وَيُرْجَى، وَلَا يُعْجَزُ عَنِ الدُّعَاءِ. وَيُسْتَحَبُّ تَكْرَارُ الدُّعَاءِ ثَلَاثَ مَرَّاتٍ.',
    ),
    WorshipItem(
      id: 'dua_etiquette_09',
      categoryId: 'dua_etiquette',
      title: 'الدعاء ثلاث مرات',
      sortOrder: 8,
      kind: 'etiquette',
      meta: {'stepNumber': 9},
      repeatHint: '٣ مرات',
      reference: 'رواه البخاري ومسلم',
      body:
          'كَانَ النَّبِيُّ ﷺ إِذَا دَعَا دَعَا ثَلَاثًا، وَإِذَا سَأَلَ سَأَلَ ثَلَاثًا.',
    ),
    WorshipItem(
      id: 'dua_etiquette_10',
      categoryId: 'dua_etiquette',
      title: 'عدم الاستعجال في الإجابة',
      sortOrder: 9,
      kind: 'etiquette',
      meta: {'stepNumber': 10},
      reference: 'رواه البخاري ومسلم',
      body:
          'يَسْتَجِيبُ أَحَدُكُمْ مَا لَمْ يَعْجَلْ، يَقُولُ: دَعَوْتُ فَلَمْ يُسْتَجَبْ لِي. وَيُكْرَهُ أَنْ يَقُولَ: لَمْ يُسْتَجِبْ لِي.',
    ),
    WorshipItem(
      id: 'dua_etiquette_11',
      categoryId: 'dua_etiquette',
      title: 'الدعاء في أوقات الإجابة',
      sortOrder: 10,
      kind: 'etiquette',
      meta: {'stepNumber': 11},
      reference: 'من السنة',
      body:
          'مِنْ أَوْقَاتِ إِجَابَةِ الدُّعَاءِ: السَّحَرُ، وَبَيْنَ الْأَذَانِ وَالْإِقَامَةِ، وَآخِرُ سَاعَةٍ مِنْ يَوْمِ الْجُمُعَةِ، وَعِنْدَ نُزُولِ الْغَيْثِ، وَفِي السُّجُودِ.',
    ),
    WorshipItem(
      id: 'dua_etiquette_12',
      categoryId: 'dua_etiquette',
      title: 'الدعاء للمسلمين',
      sortOrder: 11,
      kind: 'etiquette',
      meta: {'stepNumber': 12},
      reference: 'رواه مسلم',
      body:
          'دُعَاءُ الْمُسْلِمِ لِأَخِيهِ بِظَهْرِ الْغَيْبِ مُسْتَجَابٌ، عِنْدَ رَأْسِهِ مَلَكٌ مُوَكَّلٌ، كُلَّمَا دَعَا لِأَخِيهِ بِخَيْرٍ قَالَ الْمَلَكُ: آمِينَ وَلَكَ بِمِثْلٍ.',
    ),
    WorshipItem(
      id: 'dua_etiquette_13',
      categoryId: 'dua_etiquette',
      title: 'عدم التعدي في الدعاء',
      sortOrder: 12,
      kind: 'etiquette',
      meta: {'stepNumber': 13},
      reference: 'رواه مسلم',
      body:
          'لَا يَعْتَدِيَنَّ أَحَدُكُمْ فِي الدُّعَاءِ، فَإِنَّهُ لَنْ يُهْلَكَ بِدَعْوَةٍ. وَيُكْرَهُ الدُّعَاءُ عَلَى الْمُسْلِمِ بِالْهَلَاكِ وَالْقَطِيعَةِ.',
    ),
    WorshipItem(
      id: 'dua_etiquette_14',
      categoryId: 'dua_etiquette',
      title: 'الدعاء بالمعاصي',
      sortOrder: 13,
      kind: 'etiquette',
      meta: {'stepNumber': 14},
      reference: 'رواه الترمذي',
      body:
          'الدُّعَاءُ مُنْعَكِسٌ بِحَسَبِ حَالِ الْعَبْدِ: إِنْ أَعْجَلَ فَأُعْجِلَ لَهُ، وَإِنْ أَحْسَنَ فَأُحْسَنَ لَهُ. وَيُسْتَحَبُّ أَنْ يَكُونَ طَيِّبَ الْمَطْعَمِ وَالْمَلْبَسِ وَالْمَشْرَبِ.',
    ),
    WorshipItem(
      id: 'dua_etiquette_15',
      categoryId: 'dua_etiquette',
      title: 'الدعاء بما علم من الأدعية المأثورة',
      sortOrder: 14,
      kind: 'etiquette',
      meta: {'stepNumber': 15},
      reference: 'من السنة',
      body:
          'يُسْتَحَبُّ الِاعْتِمَادُ عَلَى الْأَدْعِيَةِ الْمَأْثُورَةِ عَنِ النَّبِيِّ ﷺ، وَلَا بَأْسَ بِالدُّعَاءِ بِمَا لَمْ يُنَصَّ عَلَيْهِ مِنْ خَيْرِ الدُّنْيَا وَالْآخِرَةِ.',
    ),
    WorshipItem(
      id: 'dua_etiquette_16',
      categoryId: 'dua_etiquette',
      title: 'الدعاء لنفسه ثم لغيره',
      sortOrder: 15,
      kind: 'etiquette',
      meta: {'stepNumber': 16},
      reference: 'من السنة',
      body:
          'يُسْتَحَبُّ أَنْ يَبْدَأَ الدَّاعِي بِنَفْسِهِ ثُمَّ يَتَوَسَّعُ فِي الدُّعَاءِ لِأَهْلِهِ وَإِخْوَانِهِ الْمُؤْمِنِينَ.',
    ),
    WorshipItem(
      id: 'dua_etiquette_17',
      categoryId: 'dua_etiquette',
      title: 'اليقين بإجابة الدعاء',
      sortOrder: 16,
      kind: 'etiquette',
      meta: {'stepNumber': 17},
      reference: 'رواه أبو داود والترمذي',
      body:
          'ادْعُوا اللَّهَ وَأَنْتُمْ مُوقِنُونَ بِالْإِجَابَةِ، وَاعْلَمُوا أَنَّ اللَّهَ لَا يَسْتَجِيبُ دُعَاءً مِنْ قَلْبٍ لَاهٍ غَافِلٍ.',
    ),
    WorshipItem(
      id: 'dua_etiquette_18',
      categoryId: 'dua_etiquette',
      title: 'الختم بالحمد والصلاة على النبي',
      sortOrder: 17,
      kind: 'etiquette',
      meta: {'stepNumber': 18},
      reference: 'رواه أبو داود والترمذي',
      body:
          'يُخْتَمُ الدُّعَاءُ بِالْحَمْدِ لِلَّهِ وَالصَّلَاةِ عَلَى رَسُولِ اللَّهِ ﷺ، كَمَا بُدِئَ بِهِمَا.',
    ),
  ];
}
