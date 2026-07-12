import '../models/worship_item.dart';

/// أدعية وأذكار متنوعة — من حصن المسلم (أبواب لم تُدرَج في التصنيفات الأخرى).
abstract final class WorshipSeedDuaDhikr {
  static const items = <WorshipItem>[
    // —— الوضوء ——
    WorshipItem(
      id: 'dua_dhikr_01',
      categoryId: 'dua_dhikr',
      title: 'التسمية قبل الوضوء',
      sortOrder: 0,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه الترمذي',
      body: 'بِسْمِ اللَّهِ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_02',
      categoryId: 'dua_dhikr',
      title: 'الشهادة بعد الوضوء',
      sortOrder: 1,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه مسلم',
      body:
          'أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_03',
      categoryId: 'dua_dhikr',
      title: 'دعاء بعد الوضوء',
      sortOrder: 2,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه الترمذي',
      body:
          'اللَّهُمَّ اجْعَلْنِي مِنَ التَّوَّابِينَ وَاجْعَلْنِي مِنَ الْمُتَطَهِّرِينَ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_04',
      categoryId: 'dua_dhikr',
      title: 'الاستغفار بعد الوضوء',
      sortOrder: 3,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه الترمذي',
      repeatHint: '٣ مرات',
      body: 'سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ، أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا أَنْتَ، أَسْتَغْفِرُكَ وَأَتُوبُ إِلَيْكَ.',
    ),

    // —— الخلاء ——
    WorshipItem(
      id: 'dua_dhikr_05',
      categoryId: 'dua_dhikr',
      title: 'دعاء دخول الخلاء',
      sortOrder: 4,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'متفق عليه',
      body:
          'بِسْمِ اللَّهِ، اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_06',
      categoryId: 'dua_dhikr',
      title: 'دعاء الخروج من الخلاء',
      sortOrder: 5,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه الترمذي',
      body: 'غُفْرَانَكَ.',
    ),

    // —— اللباس ——
    WorshipItem(
      id: 'dua_dhikr_07',
      categoryId: 'dua_dhikr',
      title: 'دعاء لبس الثوب',
      sortOrder: 6,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه أبو داود والترمذي',
      body:
          'الْحَمْدُ لِلَّهِ الَّذِي كَسَانِي هَذَا الثَّوْبَ وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_08',
      categoryId: 'dua_dhikr',
      title: 'دعاء لبس الثوب الجديد',
      sortOrder: 7,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه أبو داود والترمذي',
      body:
          'اللَّهُمَّ لَكَ الْحَمْدُ أَنْتَ كَسَوْتَنِيهِ، أَسْأَلُكَ مِنْ خَيْرِهِ وَخَيْرِ مَا صُنِعَ لَهُ، وَأَعُوذُ بِكَ مِنْ شَرِّهِ وَشَرِّ مَا صُنِعَ لَهُ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_09',
      categoryId: 'dua_dhikr',
      title: 'التسمية عند خلع الثوب',
      sortOrder: 8,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه الترمذي',
      body: 'بِسْمِ اللَّهِ.',
    ),

    // —— المرآة ——
    WorshipItem(
      id: 'dua_dhikr_10',
      categoryId: 'dua_dhikr',
      title: 'دعاء النظر في المرآة',
      sortOrder: 9,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه الحاكم',
      body:
          'اللَّهُمَّ أَنْتَ حَسَّنْتَ خَلْقِي فَحَسِّنْ خُلُقِي.',
    ),

    // —— الطعام والشراب ——
    WorshipItem(
      id: 'dua_dhikr_11',
      categoryId: 'dua_dhikr',
      title: 'التسمية قبل الطعام',
      sortOrder: 10,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه أبو داود والترمذي',
      body: 'بِسْمِ اللَّهِ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_12',
      categoryId: 'dua_dhikr',
      title: 'إذا نسي التسمية في أوله',
      sortOrder: 11,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه أبو داود والترمذي',
      body: 'بِسْمِ اللَّهِ فِي أَوَّلِهِ وَآخِرِهِ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_13',
      categoryId: 'dua_dhikr',
      title: 'الحمد بعد الفراغ من الطعام',
      sortOrder: 12,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه أبو داود والترمذي',
      body:
          'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_14',
      categoryId: 'dua_dhikr',
      title: 'دعاء من سقاه أو أطعمه',
      sortOrder: 13,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه الترمذي',
      body:
          'اللَّهُمَّ أَطْعِمْ مَنْ أَطْعَمَنِي، وَاسْقِ مَنْ سَقَانِي.',
    ),
    WorshipItem(
      id: 'dua_dhikr_15',
      categoryId: 'dua_dhikr',
      title: 'دعاء شرب اللبن',
      sortOrder: 14,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه الترمذي',
      body: 'اللَّهُمَّ بَارِكْ لَنَا فِيهِ وَزِدْنَا مِنْهُ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_16',
      categoryId: 'dua_dhikr',
      title: 'دعاء الضيف لصاحب الطعام',
      sortOrder: 15,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه أبو داود',
      body:
          'اللَّهُمَّ بَارِكْ لَهُمْ فِيمَا رَزَقْتَهُمْ، وَاغْفِرْ لَهُمْ وَارْحَمْهُمْ.',
    ),

    // —— السفر ——
    WorshipItem(
      id: 'dua_dhikr_17',
      categoryId: 'dua_dhikr',
      title: 'دعاء الركوب',
      sortOrder: 16,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه مسلم',
      body:
          'بِسْمِ اللَّهِ، الْحَمْدُ لِلَّهِ، سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ، وَإِنَّا إِلَىٰ رَبِّنَا لَمُنْقَلِبُونَ. الْحَمْدُ لِلَّهِ، الْحَمْدُ لِلَّهِ، الْحَمْدُ لِلَّهِ، اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، سُبْحَانَكَ اللَّهُمَّ إِنِّي ظَلَمْتُ نَفْسِي فَاغْفِرْ لِي، فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_18',
      categoryId: 'dua_dhikr',
      title: 'دعاء السفر',
      sortOrder: 17,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه مسلم',
      body:
          'اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَذَا الْبِرَّ وَالتَّقْوَىٰ، وَمِنَ الْعَمَلِ مَا تَرْضَىٰ، اللَّهُمَّ هَوِّنْ عَلَيْنَا سَفَرَنَا هَذَا وَاطْوِ عَنَّا بُعْدَهُ، اللَّهُمَّ أَنْتَ الصَّاحِبُ فِي السَّفَرِ وَالْخَلِيفَةُ فِي الْأَهْلِ، اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ وَعْثَاءِ السَّفَرِ، وَكَآبَةِ الْمَنْظَرِ، وَسُوءِ الْمُنْقَلَبِ فِي الْمَالِ وَالْأَهْلِ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_19',
      categoryId: 'dua_dhikr',
      title: 'دعاء دخول القرية',
      sortOrder: 18,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه مسلم',
      body:
          'اللَّهُمَّ رَبَّ السَّمَاوَاتِ السَّبْعِ وَمَا أَظْلَلْنَ، وَرَبَّ الْأَرَضِينَ السَّبْعِ وَمَا أَقْلَلْنَ، وَرَبَّ الشَّيَاطِينِ وَمَا أَضْلَلْنَ، وَرَبَّ الرِّيَاحِ وَمَا ذَرَيْنَ، أَسْأَلُكَ خَيْرَ هَذِهِ الْقَرْيَةِ وَخَيْرَ أَهْلِهَا، وَأَعُوذُ بِكَ مِنْ شَرِّهَا وَشَرِّ أَهْلِهَا.',
    ),
    WorshipItem(
      id: 'dua_dhikr_20',
      categoryId: 'dua_dhikr',
      title: 'دعاء العودة من السفر',
      sortOrder: 19,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه مسلم',
      body:
          'آيِبُونَ تَائِبُونَ عَابِدُونَ لِرَبِّنَا حَامِدُونَ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_21',
      categoryId: 'dua_dhikr',
      title: 'التكبير عند الصعود',
      sortOrder: 20,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه البخاري',
      body: 'اللَّهُ أَكْبَرُ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_22',
      categoryId: 'dua_dhikr',
      title: 'التسبيح عند الهبوط',
      sortOrder: 21,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه البخاري',
      body: 'سُبْحَانَ اللَّهِ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_23',
      categoryId: 'dua_dhikr',
      title: 'دعاء المبيت في السفر',
      sortOrder: 22,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه مسلم',
      body:
          'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ.',
    ),

    // —— المطر والريح ——
    WorshipItem(
      id: 'dua_dhikr_24',
      categoryId: 'dua_dhikr',
      title: 'دعاء نزول المطر',
      sortOrder: 23,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه البخاري',
      body: 'اللَّهُمَّ صَيِّبًا نَافِعًا.',
    ),
    WorshipItem(
      id: 'dua_dhikr_25',
      categoryId: 'dua_dhikr',
      title: 'دعاء كثرة المطر',
      sortOrder: 24,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه البخاري',
      body: 'اللَّهُمَّ حَوَالَيْنَا وَلَا عَلَيْنَا، اللَّهُمَّ عَلَىٰ الْآكَامِ وَالظِّرَابِ وَبُطُونِ الْأَوْدِيَةِ وَمَنَابِتِ الشَّجَرِ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_26',
      categoryId: 'dua_dhikr',
      title: 'دعاء بعد المطر',
      sortOrder: 25,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه أبو داود',
      body:
          'مُطِرْنَا بِفَضْلِ اللَّهِ وَرَحْمَتِهِ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_27',
      categoryId: 'dua_dhikr',
      title: 'دعاء الريح',
      sortOrder: 26,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه الترمذي',
      body:
          'اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَهَا وَخَيْرَ مَا فِيهَا وَخَيْرَ مَا أُرْسِلَتْ بِهِ، وَأَعُوذُ بِكَ مِنْ شَرِّهَا وَشَرِّ مَا فِيهَا وَشَرِّ مَا أُرْسِلَتْ بِهِ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_28',
      categoryId: 'dua_dhikr',
      title: 'ذكر عند سماع الرعد',
      sortOrder: 27,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه مالك في الموطأ',
      body:
          'سُبْحَانَ الَّذِي يُسَبِّحُ الرَّعْدُ بِحَمْدِهِ وَالْمَلَائِكَةُ مِنْ خِيفَتِهِ.',
    ),

    // —— الخوف والهم ——
    WorshipItem(
      id: 'dua_dhikr_29',
      categoryId: 'dua_dhikr',
      title: 'دعاء الخوف والفزع',
      sortOrder: 28,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه أبو داود والترمذي',
      body:
          'لَا إِلَٰهَ إِلَّا اللَّهُ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_30',
      categoryId: 'dua_dhikr',
      title: 'دعاء من أصابه أمر فزع',
      sortOrder: 29,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه البخاري',
      body:
          'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ جَهْدِ الْبَلَاءِ، وَدَرَكِ الشَّقَاءِ، وَسُوءِ الْقَضَاءِ، وَشَمَاتَةِ الْأَعْدَاءِ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_31',
      categoryId: 'dua_dhikr',
      title: 'حسبي الله ونعم الوكيل',
      sortOrder: 30,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه أبو داود والترمذي',
      repeatHint: '٧ مرات',
      body: 'حَسْبِيَ اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ، عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_32',
      categoryId: 'dua_dhikr',
      title: 'دعاء الكرب الشديد',
      sortOrder: 31,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه مسلم',
      body:
          'اللَّهُمَّ رَحْمَتَكَ أَرْجُو، فَلَا تَكِلْنِي إِلَىٰ نَفْسِي طَرْفَةَ عَيْنٍ، وَأَصْلِحْ لِي شَأْنِي كُلَّهُ، لَا إِلَٰهَ إِلَّا أَنْتَ.',
    ),

    // —— الدين والرزق ——
    WorshipItem(
      id: 'dua_dhikr_33',
      categoryId: 'dua_dhikr',
      title: 'دعاء قضاء الدين',
      sortOrder: 32,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه الترمذي',
      body:
          'اللَّهُمَّ اكْفِنِي بِحَلَالِكَ عَنْ حَرَامِكَ، وَأَغْنِنِي بِفَضْلِكَ عَمَّنْ سِوَاكَ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_34',
      categoryId: 'dua_dhikr',
      title: 'دعاء الفقر والحاجة',
      sortOrder: 33,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه أبو داود',
      body:
          'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْفَقْرِ وَالْقِلَّةِ وَالذِّلَّةِ، وَأَعُوذُ بِكَ مِنْ أَنْ أَظْلِمَ أَوْ أُظْلَمَ.',
    ),

    // —— رؤية المبتلى ——
    WorshipItem(
      id: 'dua_dhikr_35',
      categoryId: 'dua_dhikr',
      title: 'دعاء من رأى مبتلى',
      sortOrder: 34,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه الترمذي',
      body:
          'الْحَمْدُ لِلَّهِ الَّذِي عَافَانِي مِمَّا ابْتَلَاكَ بِهِ، وَفَضَّلَنِي عَلَىٰ كَثِيرٍ مِمَّنْ خَلَقَ تَفْضِيلًا.',
    ),

    // —— العطاس والتثاؤب ——
    WorshipItem(
      id: 'dua_dhikr_36',
      categoryId: 'dua_dhikr',
      title: 'ما يقول العاطس',
      sortOrder: 35,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه البخاري',
      body: 'الْحَمْدُ لِلَّهِ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_37',
      categoryId: 'dua_dhikr',
      title: 'ردّ من سمع العاطس',
      sortOrder: 36,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه البخاري',
      body: 'يَرْحَمُكَ اللَّهُ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_38',
      categoryId: 'dua_dhikr',
      title: 'ردّ العاطس على من حمد الله',
      sortOrder: 37,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه البخاري',
      body: 'يَهْدِيكُمُ اللَّهُ وَيُصْلِحُ بَالَكُمْ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_39',
      categoryId: 'dua_dhikr',
      title: 'دعاء التثاؤب',
      sortOrder: 38,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه مسلم',
      body: 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ.',
    ),

    // —— الكابوس والفزع ——
    WorshipItem(
      id: 'dua_dhikr_40',
      categoryId: 'dua_dhikr',
      title: 'دعاء الفزع في النوم',
      sortOrder: 39,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه أبو داود',
      body:
          'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ غَضَبِهِ وَعِقَابِهِ، وَشَرِّ عِبَادِهِ، وَمِنْ هَمَزَاتِ الشَّيَاطِينِ وَأَنْ يَحْضُرُونِ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_41',
      categoryId: 'dua_dhikr',
      title: 'دعاء من رأى الرؤيا',
      sortOrder: 40,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه البخاري',
      body:
          'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ عِلْمٍ لَا يَنْفَعُ، وَمِنْ قَلْبٍ لَا يَخْشَعُ، وَمِنْ نَفْسٍ لَا تَشْبَعُ، وَمِنْ دَعْوَةٍ لَا يُسْتَجَابُ لَهَا.',
    ),

    // —— الأذان ——
    WorshipItem(
      id: 'dua_dhikr_42',
      categoryId: 'dua_dhikr',
      title: 'ما يقول عند سماع الأذان',
      sortOrder: 41,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه مسلم',
      body:
          'يُردِّدُ مِثْلَ مَا يَقُولُ الْمُؤَذِّنُ إِلَّا فِي «حَيَّ عَلَى الصَّلَاةِ» وَ«حَيَّ عَلَى الْفَلَاحِ» فَيَقُولُ: لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_43',
      categoryId: 'dua_dhikr',
      title: 'دعاء بعد الأذان',
      sortOrder: 42,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه مسلم',
      body:
          'اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ، وَالصَّلَاةِ الْقَائِمَةِ، آتِ مُحَمَّدًا الْوَسِيلَةَ وَالْفَضِيلَةَ، وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_44',
      categoryId: 'dua_dhikr',
      title: 'الصلاة على النبي بعد الأذان',
      sortOrder: 43,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه مسلم',
      body:
          'اللَّهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ وَعَلَىٰ آلِ مُحَمَّدٍ، كَمَا صَلَّيْتَ عَلَىٰ إِبْرَاهِيمَ وَعَلَىٰ آلِ إِبْرَاهِيمَ، إِنَّكَ حَمِيدٌ مَجِيدٌ. اللَّهُمَّ بَارِكْ عَلَىٰ مُحَمَّدٍ وَعَلَىٰ آلِ مُحَمَّدٍ، كَمَا بَارَكْتَ عَلَىٰ إِبْرَاهِيمَ وَعَلَىٰ آلِ إِبْرَاهِيمَ، إِنَّكَ حَمِيدٌ مَجِيدٌ.',
    ),

    // —— المسجد ——
    WorshipItem(
      id: 'dua_dhikr_45',
      categoryId: 'dua_dhikr',
      title: 'دعاء الخروج من المسجد',
      sortOrder: 44,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه مسلم',
      body: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ.',
    ),

    // —— عيادة المريض ——
    WorshipItem(
      id: 'dua_dhikr_46',
      categoryId: 'dua_dhikr',
      title: 'تسلية المريض',
      sortOrder: 45,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه البخاري',
      body: 'لَا بَأْسَ، طَهُورٌ إِنْ شَاءَ اللَّهُ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_47',
      categoryId: 'dua_dhikr',
      title: 'دعاء عيادة المريض',
      sortOrder: 46,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه أبو داود والترمذي',
      repeatHint: '٧ مرات',
      body:
          'أَسْأَلُ اللَّهَ الْعَظِيمَ رَبَّ الْعَرْشِ الْعَظِيمِ أَنْ يَشْفِيَكَ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_48',
      categoryId: 'dua_dhikr',
      title: 'دعاء للمريض — اللهم رب الناس',
      sortOrder: 47,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'متفق عليه',
      body:
          'اللَّهُمَّ رَبَّ النَّاسِ، أَذْهِبِ الْبَأْسَ، اشْفِ أَنْتَ الشَّافِي، لَا شِفَاءَ إِلَّا شِفَاؤُكَ، شِفَاءً لَا يُغَادِرُ سَقَمًا.',
    ),
    WorshipItem(
      id: 'dua_dhikr_49',
      categoryId: 'dua_dhikr',
      title: 'دعاء من اشتهى الموت لمرضه',
      sortOrder: 48,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه البخاري ومسلم',
      body:
          'اللَّهُمَّ أَحْيِنِي مَا كَانَتِ الْحَيَاةُ خَيْرًا لِي، وَتَوَفَّنِي إِذَا كَانَتِ الْوَفَاةُ خَيْرًا لِي.',
    ),

    // —— التهنئة والتعزية ——
    WorshipItem(
      id: 'dua_dhikr_50',
      categoryId: 'dua_dhikr',
      title: 'دعاء التهنئة بالزواج',
      sortOrder: 49,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه أبو داود',
      body:
          'بَارَكَ اللَّهُ لَكَ، وَبَارَكَ عَلَيْكَ، وَجَمَعَ بَيْنَكُمَا فِي خَيْرٍ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_51',
      categoryId: 'dua_dhikr',
      title: 'دعاء ليلة الزفاف',
      sortOrder: 50,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه أبو داود',
      body:
          'اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَهَا وَخَيْرَ مَا جَبَلْتَهَا عَلَيْهِ، وَأَعُوذُ بِكَ مِنْ شَرِّهَا وَشَرِّ مَا جَبَلْتَهَا عَلَيْهِ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_52',
      categoryId: 'dua_dhikr',
      title: 'دعاء التعزية في المصيبة',
      sortOrder: 51,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'متفق عليه',
      body:
          'إِنَّ لِلَّهِ مَا أَخَذَ وَلَهُ مَا أَعْطَىٰ، وَكُلُّ شَيْءٍ عِنْدَهُ بِأَجَلٍ مُسَمًّى، فَلْتَصْبِرْ وَلْتَحْتَسِبْ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_53',
      categoryId: 'dua_dhikr',
      title: 'دعاء التعزية — أعظم الله أجرك',
      sortOrder: 52,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه الترمذي',
      body: 'أَعْظَمَ اللَّهُ أَجْرَكَ، وَأَحْسَنَ عَزَاءَكَ، وَغَفَرَ لِمَيِّتِكَ.',
    ),

    // —— المولود ——
    WorshipItem(
      id: 'dua_dhikr_54',
      categoryId: 'dua_dhikr',
      title: 'دعاء التهنئة بالمولود',
      sortOrder: 53,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه الترمذي',
      body:
          'بَارَكَ اللَّهُ لَكَ فِي الْمَوْهُوبِ لَكَ، وَشَكَرْتَ الْوَاهِبَ، وَبَلَغَ أَشُدَّهُ، وَرُزِقْتَ بِرَّهُ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_55',
      categoryId: 'dua_dhikr',
      title: 'دعاء التحنيك',
      sortOrder: 54,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه البخاري ومسلم',
      body:
          'بِسْمِ اللَّهِ، اللَّهُمَّ إِنِّي أُحَذِّرُكَ أُمَّتَكَ مُحَمَّدٍ ﷺ (يُسَمَّى بِاسْمِهِ) مِنْ شَرِّ كُلِّ ذِي شَرٍّ أَنْتَ آخِذٌ بِنَاصِيَتِهِ، اللَّهُمَّ إِنِّي أُحَذِّرُكَ أُمَّتَكَ مُحَمَّدٍ ﷺ (يُسَمَّى بِاسْمِهِ) مِنْ شَرِّ كُلِّ ذِي شَرٍّ أَنْتَ آخِذٌ بِنَاصِيَتِهِ.',
    ),

    // —— الكسوف والخسوف ——
    WorshipItem(
      id: 'dua_dhikr_56',
      categoryId: 'dua_dhikr',
      title: 'دعاء الكسوف والخسوف',
      sortOrder: 55,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه البخاري ومسلم',
      body:
          'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ عَذَابِ الْقَبْرِ، وَمِنْ عَذَابِ جَهَنَّمَ، وَمِنْ فِتْنَةِ الْمَحْيَا وَالْمَمَاتِ، وَمِنْ شَرِّ فِتْنَةِ الْمَسِيحِ الدَّجَّالِ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_57',
      categoryId: 'dua_dhikr',
      title: 'دعاء عند رؤية الهلال',
      sortOrder: 56,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه الترمذي',
      body:
          'اللَّهُ أَكْبَرُ، اللَّهُمَّ أَهِلَّهُ عَلَيْنَا بِالْأَمْنِ وَالْإِيمَانِ، وَالسَّلَامَةِ وَالْإِسْلَامِ، وَالتَّوْفِيقِ لِمَا تُحِبُّ وَتَرْضَىٰ، رَبُّنَا وَرَبُّكَ اللَّهُ.',
    ),

    // —— الاستخارة ——
    WorshipItem(
      id: 'dua_dhikr_58',
      categoryId: 'dua_dhikr',
      title: 'دعاء الاستخارة',
      sortOrder: 57,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه البخاري',
      body:
          'اللَّهُمَّ إِنِّي أَسْتَخِيرُكَ بِعِلْمِكَ، وَأَسْتَقْدِرُكَ بِقُدْرَتِكَ، وَأَسْأَلُكَ مِنْ فَضْلِكَ الْعَظِيمِ، فَإِنَّكَ تَقْدِرُ وَلَا أَقْدِرُ، وَتَعْلَمُ وَلَا أَعْلَمُ، وَأَنْتَ عَلَّامُ الْغُيُوبِ. اللَّهُمَّ إِنْ كُنْتَ تَعْلَمُ أَنَّ هَذَا الْأَمْرَ خَيْرٌ لِي فِي دِينِي وَمَعَاشِي وَعَاقِبَةِ أَمْرِي، فَاقْدُرْهُ لِي وَيَسِّرْهُ لِي ثُمَّ بَارِكْ لِي فِيهِ، وَإِنْ كُنْتَ تَعْلَمُ أَنَّ هَذَا الْأَمْرَ شَرٌّ لِي فِي دِينِي وَمَعَاشِي وَعَاقِبَةِ أَمْرِي، فَاصْرِفْهُ عَنِّي وَاصْرِفْنِي عَنْهُ، وَاقْدُرْ لِي الْخَيْرَ حَيْثُ كَانَ ثُمَّ أَرْضِنِي بِهِ.',
    ),

    // —— السوق والغضب ——
    WorshipItem(
      id: 'dua_dhikr_59',
      categoryId: 'dua_dhikr',
      title: 'دعاء دخول السوق',
      sortOrder: 58,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه الترمذي',
      body:
          'لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، يُحْيِي وَيُمِيتُ وَهُوَ حَيٌّ لَا يَمُوتُ، بِيَدِهِ الْخَيْرُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_60',
      categoryId: 'dua_dhikr',
      title: 'دعاء الغضب',
      sortOrder: 59,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه البخاري ومسلم',
      body: 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ.',
    ),

    // —— الذبح والإفطار ——
    WorshipItem(
      id: 'dua_dhikr_61',
      categoryId: 'dua_dhikr',
      title: 'دعاء الذبح',
      sortOrder: 60,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه مسلم',
      body: 'بِسْمِ اللَّهِ، اللَّهُ أَكْبَرُ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_62',
      categoryId: 'dua_dhikr',
      title: 'دعاء الإفطار',
      sortOrder: 61,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه أبو داود',
      body:
          'ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللَّهُ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_63',
      categoryId: 'dua_dhikr',
      title: 'دعاء عند الإفطار عند أحد',
      sortOrder: 62,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه أبو داود',
      body:
          'أَفْطَرَ عِنْدَكُمُ الصَّائِمُونَ، وَأَكَلَ طَعَامَكُمُ الْأَبْرَارُ، وَصَلَّتْ عَلَيْكُمُ الْمَلَائِكَةُ.',
    ),

    // —— الألم والمرض ——
    WorshipItem(
      id: 'dua_dhikr_64',
      categoryId: 'dua_dhikr',
      title: 'دعاء من وجد ألمًا في جسده',
      sortOrder: 63,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه مسلم',
      repeatHint: '٧ مرات',
      body:
          'أَعُوذُ بِعِزَّةِ اللَّهِ وَقُدْرَتِهِ مِنْ شَرِّ مَا أَجِدُ وَأُحَاذِرُ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_65',
      categoryId: 'dua_dhikr',
      title: 'دعاء من أصيب بمصيبة',
      sortOrder: 64,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه مسلم',
      body:
          'إِنَّا لِلَّهِ وَإِنَّا إِلَيْهِ رَاجِعُونَ، اللَّهُمَّ أَجِرْنِي فِي مُصِيبَتِي وَأَخْلِفْ لِي خَيْرًا مِنْهَا.',
    ),

    // —— المدح والثناء ——
    WorshipItem(
      id: 'dua_dhikr_66',
      categoryId: 'dua_dhikr',
      title: 'دعاء من قيل له جزاك الله خيرًا',
      sortOrder: 65,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه الترمذي',
      body:
          'وَفِيكَ بَارَكَ اللَّهُ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_67',
      categoryId: 'dua_dhikr',
      title: 'دعاء من مدحه أحد',
      sortOrder: 66,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه أبو داود',
      body:
          'اللَّهُمَّ لَا تُؤَاخِذْنِي بِمَا يَقُولُونَ، وَاغْفِرْ لِي مَا لَا يَعْلَمُونَ، وَاجْعَلْنِي خَيْرًا مِمَّا يَظُنُّونَ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_68',
      categoryId: 'dua_dhikr',
      title: 'دعاء من قال له بارك الله فيك',
      sortOrder: 67,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه البخاري',
      body: 'اللَّهُمَّ أَجِرْنِي مِنَ النَّارِ.',
    ),

    // —— البشرى والخير ——
    WorshipItem(
      id: 'dua_dhikr_69',
      categoryId: 'dua_dhikr',
      title: 'دعاء عند سماع البشرى',
      sortOrder: 68,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه الترمذي',
      body:
          'الْحَمْدُ لِلَّهِ الَّذِي بِنِعْمَتِهِ تَتِمُّ الصَّالِحَاتُ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_70',
      categoryId: 'dua_dhikr',
      title: 'دعاء لمن قدم إليه هدية',
      sortOrder: 69,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه الترمذي',
      body:
          'جَزَاكَ اللَّهُ خَيْرًا.',
    ),

    // —— الجنازة ——
    WorshipItem(
      id: 'dua_dhikr_71',
      categoryId: 'dua_dhikr',
      title: 'دعاء عند رؤية الجنازة',
      sortOrder: 70,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه أبو داود',
      body:
          'اللَّهُمَّ لَا تَحْرِمْنَا أَجْرَهَا، وَلَا تَفْتِنَّا بَعْدَهَا.',
    ),
    WorshipItem(
      id: 'dua_dhikr_72',
      categoryId: 'dua_dhikr',
      title: 'دعاء المشيع للجنازة',
      sortOrder: 71,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه مسلم',
      body:
          'اللَّهُمَّ اغْفِرْ لِحَيِّنَا وَمَيِّتِنَا، وَشَاهِدِنَا وَغَائِبِنَا، وَصَغِيرِنَا وَكَبِيرِنَا، وَذَكَرِنَا وَأُنْثَانَا، اللَّهُمَّ مَنْ أَحْيَيْتَهُ مِنَّا فَأَحْيِهِ عَلَى الْإِسْلَامِ، وَمَنْ تَوَفَّيْتَهُ مِنَّا فَتَوَفَّهُ عَلَى الْإِيمَانِ.',
    ),

    // —— أذكار متفرقة ——
    WorshipItem(
      id: 'dua_dhikr_73',
      categoryId: 'dua_dhikr',
      title: 'دعاء من أراد أن يمدح أخاه',
      sortOrder: 72,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه مسلم',
      body:
          'أَحْسِبُ فُلَانًا (يُسَمَّى) وَاللَّهُ حَسِيبُهُ، وَلَا أُزَكِّي عَلَى اللَّهِ أَحَدًا.',
    ),
    WorshipItem(
      id: 'dua_dhikr_74',
      categoryId: 'dua_dhikr',
      title: 'دعاء من رأى مكروهًا في نفسه',
      sortOrder: 73,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه البخاري ومسلم',
      body:
          'الْحَمْدُ لِلَّهِ الَّذِي عَافَانِي مِمَّا ابْتَلَاكَ بِهِ، وَفَضَّلَنِي عَلَىٰ كَثِيرٍ مِمَّنْ خَلَقَ تَفْضِيلًا.',
    ),
    WorshipItem(
      id: 'dua_dhikr_75',
      categoryId: 'dua_dhikr',
      title: 'دعاء من أصابه همّ',
      sortOrder: 74,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه أبو داود',
      body:
          'اللَّهُمَّ إِنِّي عَبْدُكَ، ابْنُ عَبْدِكَ، ابْنُ أَمَتِكَ، نَاصِيَتِي بِيَدِكَ، مَاضٍ فِيَّ حُكْمُكَ، عَدْلٌ فِيَّ قَضَاؤُكَ، أَسْأَلُكَ بِكُلِّ اسْمٍ هُوَ لَكَ سَمَّيْتَ بِهِ نَفْسَكَ، أَوْ أَنْزَلْتَهُ فِي كِتَابِكَ، أَوْ عَلَّمْتَهُ أَحَدًا مِنْ خَلْقِكَ، أَوِ اسْتَأْثَرْتَ بِهِ فِي عِلْمِ الْغَيْبِ عِنْدَكَ، أَنْ تَجْعَلَ الْقُرْآنَ رَبِيعَ قَلْبِي، وَنُورَ صَدْرِي، وَجَلَاءَ حُزْنِي، وَذَهَابَ هَمِّي.',
    ),
    WorshipItem(
      id: 'dua_dhikr_76',
      categoryId: 'dua_dhikr',
      title: 'دعاء لقاء العدو أو الحاكم',
      sortOrder: 75,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه أبو داود',
      body:
          'اللَّهُمَّ إِنَّا نَجْعَلُكَ فِي نُحُورِهِمْ، وَنَعُوذُ بِكَ مِنْ شُرُورِهِمْ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_77',
      categoryId: 'dua_dhikr',
      title: 'دعاء من خاف ظلم السلطان',
      sortOrder: 76,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه أبو داود',
      body:
          'اللَّهُمَّ رَبَّ السَّمَاوَاتِ السَّبْعِ وَرَبَّ الْعَرْشِ الْعَظِيمِ، كُنْ لِي جَارًا مِنْ فُلَانِ بْنِ فُلَانٍ (يُسَمَّى)، وَأَحْزَابِهِ مِنْ جِبَالِكَ وَأَنْصَارِكَ وَمَلَائِكَتِكَ، حَتَّىٰ تُجِيرَنِي مِنْهُمْ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_78',
      categoryId: 'dua_dhikr',
      title: 'دعاء من خاف قومًا',
      sortOrder: 77,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه أبو داود',
      body:
          'اللَّهُمَّ اكْفِنِيهِمْ بِمَا شِئْتَ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_79',
      categoryId: 'dua_dhikr',
      title: 'دعاء من أراد أن يطيع الله',
      sortOrder: 78,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه أحمد',
      body:
          'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْهُدَىٰ وَالتُّقَىٰ وَالْعَفَافَ وَالْغِنَىٰ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_80',
      categoryId: 'dua_dhikr',
      title: 'دعاء طلب العلم',
      sortOrder: 79,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه الترمذي',
      body:
          'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا.',
    ),
    WorshipItem(
      id: 'dua_dhikr_81',
      categoryId: 'dua_dhikr',
      title: 'دعاء من أصابته نعمة',
      sortOrder: 80,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه أبو داود',
      body:
          'اللَّهُمَّ لَا طَيْرَ إِلَّا طَيْرُكَ، وَلَا خَيْرَ إِلَّا خَيْرُكَ، وَلَا إِلَٰهَ غَيْرُكَ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_82',
      categoryId: 'dua_dhikr',
      title: 'دعاء من رأى أهل بلاة',
      sortOrder: 81,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه الترمذي',
      body:
          'الْحَمْدُ لِلَّهِ الَّذِي عَافَانِي مِمَّا ابْتَلَاكُمْ بِهِ، وَفَضَّلَنِي عَلَىٰ كَثِيرٍ مِمَّنْ خَلَقَ تَفْضِيلًا.',
    ),
    WorshipItem(
      id: 'dua_dhikr_83',
      categoryId: 'dua_dhikr',
      title: 'دعاء الاستسقاء',
      sortOrder: 82,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه البخاري',
      body:
          'اللَّهُمَّ اسْقِنَا غَيْثًا مُغِيثًا مَرِيئًا مَرِيعًا، نَافِعًا غَيْرَ ضَارٍّ، عَاجِلًا غَيْرَ آجِلٍ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_84',
      categoryId: 'dua_dhikr',
      title: 'دعاء من سمع صياح الديك',
      sortOrder: 83,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه البخاري',
      body:
          'إِذَا سَمِعْتَ صِيَاحَ الدِّيكَةِ فَاسْأَلِ اللَّهَ مِنْ فَضْلِهِ، فَإِنَّهَا رَأَتْ مَلَكًا.',
    ),
    WorshipItem(
      id: 'dua_dhikr_85',
      categoryId: 'dua_dhikr',
      title: 'دعاء من سمع نباح الكلب بالليل',
      sortOrder: 84,
      kind: 'dhikr',
      meta: {'tab': 'dhikr'},
      reference: 'رواه البخاري',
      body:
          'إِذَا سَمِعْتَ نُبَاحَ الْكِلَابِ بِاللَّيْلِ فَتَعَوَّذْ بِاللَّهِ مِنْهُنَّ، فَإِنَّهَا تَرَى مَا لَا تَرَى.',
    ),
    WorshipItem(
      id: 'dua_dhikr_86',
      categoryId: 'dua_dhikr',
      title: 'دعاء المرور على المقابر',
      sortOrder: 85,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه مسلم',
      body:
          'السَّلَامُ عَلَيْكُمْ أَهْلَ الدِّيَارِ مِنَ الْمُؤْمِنِينَ، وَإِنَّا إِنْ شَاءَ اللَّهُ بِكُمْ لَلَاحِقُونَ، يَرْحَمُ اللَّهُ الْمُسْتَقْدِمِينَ مِنَّا وَالْمُسْتَأْخِرِينَ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_87',
      categoryId: 'dua_dhikr',
      title: 'دعاء عند نزول المطر في المقبرة',
      sortOrder: 86,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه الشافعي',
      body:
          'اللَّهُمَّ اجْعَلْهُ صَيِّبًا هَنِيئًا.',
    ),
    WorshipItem(
      id: 'dua_dhikr_88',
      categoryId: 'dua_dhikr',
      title: 'دعاء من أراد أن يحفظ الله أهله',
      sortOrder: 87,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه أبو داود',
      body:
          'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ.',
    ),
    WorshipItem(
      id: 'dua_dhikr_89',
      categoryId: 'dua_dhikr',
      title: 'دعاء الاغتسال',
      sortOrder: 88,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه الترمذي',
      body:
          'اللَّهُمَّ اغْسِلْنِي مِنْ خَطَايَايَ، وَطَهِّرْنِي مِنْ ذُنُوبِي.',
    ),
    WorshipItem(
      id: 'dua_dhikr_90',
      categoryId: 'dua_dhikr',
      title: 'دعاء قبل الجماع',
      sortOrder: 89,
      kind: 'dua',
      meta: {'tab': 'dua'},
      reference: 'رواه البخاري ومسلم',
      body:
          'بِسْمِ اللَّهِ، اللَّهُمَّ جَنِّبْنَا الشَّيْطَانَ، وَجَنِّبِ الشَّيْطَانَ مَا رَزَقْتَنَا.',
    ),
  ];
}
