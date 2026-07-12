import '../models/worship_item.dart';

/// السنن الرواتب — من حصن المسلم (باب السنن الرواتب).
abstract final class WorshipSeedRawatib {
  static const items = <WorshipItem>[
    WorshipItem(
      id: 'rawatib_01',
      categoryId: 'rawatib',
      title: 'ركعتا الفجر قبل الفرض',
      sortOrder: 0,
      kind: 'ritual',
      meta: {
        'prayerKey': 'fajr',
        'timing': 'before',
        'rakahs': 2,
      },
      repeatHint: 'ركعتان قبل الفجر',
      reference: 'متفق عليه',
      body:
          'رَكْعَتَانِ قَبْلَ صَلَاةِ الْفَجْرِ مِنَ السُّنَنِ الرَّاتِبَةِ الْمُؤَكَّدَةِ، وَلَمْ يَكُنِ النَّبِيُّ ﷺ عَلَى شَيْءٍ مِنَ النَّوَافِلِ أَشَدَّ مُحَافَظَةً عَلَيْهِ مِنْهُمَا.',
    ),
    WorshipItem(
      id: 'rawatib_02',
      categoryId: 'rawatib',
      title: 'سنن الظهر قبل الفرض',
      sortOrder: 1,
      kind: 'ritual',
      meta: {
        'prayerKey': 'dhuhr',
        'timing': 'before',
        'rakahs': 4,
      },
      repeatHint: 'أربع ركعات قبل الظهر',
      reference: 'رواه مسلم',
      body:
          'أَرْبَعُ رَكَعَاتٍ قَبْلَ الظُّهْرِ، يُصَلِّيهِنَّ النَّبِيُّ ﷺ، وَيَقُولُ: «إِنَّ اللَّهَ عَزَّ وَجَلَّ جَعَلَ تِلْكَ الصَّلَوَاتِ فِرَضًا، وَجَعَلَ أَرْبَعَ رَكَعَاتٍ قَبْلَهَا تَطَوُّعًا».',
    ),
    WorshipItem(
      id: 'rawatib_03',
      categoryId: 'rawatib',
      title: 'سنن الظهر بعد الفرض',
      sortOrder: 2,
      kind: 'ritual',
      meta: {
        'prayerKey': 'dhuhr',
        'timing': 'after',
        'rakahs': 2,
      },
      repeatHint: 'ركعتان بعد الظهر',
      reference: 'رواه مسلم',
      body:
          'رَكْعَتَانِ بَعْدَ الظُّهْرِ مِنَ السُّنَنِ الرَّاتِبَةِ، وَكَانَ النَّبِيُّ ﷺ لَا يَدَعُهُمَا إِلَّا أَنْ يَكُونَ مُسَافِرًا.',
    ),
    WorshipItem(
      id: 'rawatib_04',
      categoryId: 'rawatib',
      title: 'سنن المغرب بعد الفرض',
      sortOrder: 3,
      kind: 'ritual',
      meta: {
        'prayerKey': 'maghrib',
        'timing': 'after',
        'rakahs': 2,
      },
      repeatHint: 'ركعتان بعد المغرب',
      reference: 'رواه البخاري ومسلم',
      body:
          'رَكْعَتَانِ بَعْدَ الْمَغْرِبِ مِنَ السُّنَنِ الرَّاتِبَةِ الْمُؤَكَّدَةِ.',
    ),
    WorshipItem(
      id: 'rawatib_05',
      categoryId: 'rawatib',
      title: 'سنن العشاء بعد الفرض',
      sortOrder: 4,
      kind: 'ritual',
      meta: {
        'prayerKey': 'isha',
        'timing': 'after',
        'rakahs': 2,
      },
      repeatHint: 'ركعتان بعد العشاء',
      reference: 'رواه البخاري ومسلم',
      body:
          'رَكْعَتَانِ بَعْدَ الْعِشَاءِ مِنَ السُّنَنِ الرَّاتِبَةِ، وَهُمَا مِنْ أَعْظَمِ السُّنَنِ الْمُحَافَظَ عَلَيْهَا النَّبِيُّ ﷺ.',
    ),
    WorshipItem(
      id: 'rawatib_06',
      categoryId: 'rawatib',
      title: 'لا راتبة للعصر',
      sortOrder: 5,
      kind: 'virtue',
      meta: {
        'prayerKey': 'asr',
      },
      reference: 'من فقه السنة',
      body:
          'لَيْسَ لِصَلَاةِ الْعَصْرِ سُنَّةٌ رَاتِبَةٌ قَبْلَهَا أَوْ بَعْدَهَا، وَمَا يُذْكَرُ مِنْ صَلَاةٍ قَبْلَ الْعَصْرِ فَهُوَ مِنَ النَّوَافِلِ الْمُطْلَقَةِ لَيْسَ مِنَ الرَّوَاتِبِ.',
    ),
    WorshipItem(
      id: 'rawatib_07',
      categoryId: 'rawatib',
      title: 'بيت في الجنة لمن حافظ على الرواتب',
      sortOrder: 6,
      kind: 'virtue',
      reference: 'رواه مسلم',
      benefit: 'بُنِيَ لَهُ بَيْتٌ فِي الْجَنَّةِ',
      body:
          'مَنْ صَلَّى اثْنَتَيْ عَشْرَةَ رَكْعَةً فِي يَوْمٍ وَلَيْلَةٍ بُنِيَ لَهُ بَيْتٌ فِي الْجَنَّةِ: أَرْبَعًا قَبْلَ الظُّهْرِ، وَرَكْعَتَيْنِ بَعْدَهَا، وَرَكْعَتَيْنِ بَعْدَ الْمَغْرِبِ، وَرَكْعَتَيْنِ بَعْدَ الْعِشَاءِ، وَرَكْعَتَيْنِ قَبْلَ صَلَاةِ الْفَجْرِ.',
    ),
    WorshipItem(
      id: 'rawatib_08',
      categoryId: 'rawatib',
      title: 'خير الصلاة صلاة المرء في بيته',
      sortOrder: 7,
      kind: 'virtue',
      reference: 'رواه البخاري ومسلم',
      body:
          'خَيْرُ الصَّلَاةِ صَلَاةُ الْمَرْءِ فِي بَيْتِهِ، إِلَّا الْمَكْتُوبَةَ. وَالسُّنَنُ الرَّاتِبَةُ أَفْضَلُ أَدَاؤُهَا فِي الْبَيْتِ إِلَّا رَكْعَتَيِ الْفَجْرِ.',
    ),
    WorshipItem(
      id: 'rawatib_09',
      categoryId: 'rawatib',
      title: 'ركعتا الفجر خير من الدنيا وما فيها',
      sortOrder: 8,
      kind: 'virtue',
      meta: {
        'prayerKey': 'fajr',
        'timing': 'before',
        'rakahs': 2,
      },
      reference: 'رواه مسلم',
      body:
          'رَكْعَتَا الْفَجْرِ خَيْرٌ مِنَ الدُّنْيَا وَمَا فِيهَا.',
    ),
    WorshipItem(
      id: 'rawatib_10',
      categoryId: 'rawatib',
      title: 'من صلى ركعتين قبل الفجر دخل الجنة',
      sortOrder: 9,
      kind: 'virtue',
      meta: {
        'prayerKey': 'fajr',
        'timing': 'before',
        'rakahs': 2,
      },
      reference: 'رواه أحمد والطبراني',
      body:
          'مَنْ صَلَّى رَكْعَتَيْنِ قَبْلَ صَلَاةِ الْفَجْرِ دَخَلَ الْجَنَّةَ.',
    ),
    WorshipItem(
      id: 'rawatib_11',
      categoryId: 'rawatib',
      title: 'الوتر بعد العشاء',
      sortOrder: 10,
      kind: 'ritual',
      meta: {
        'prayerKey': 'isha',
        'timing': 'after',
      },
      repeatHint: 'وتر واحد أو أكثر',
      reference: 'رواه البخاري ومسلم',
      body:
          'الْوِتْرُ صَلَاةٌ مُؤَكَّدَةٌ بَعْدَ الْعِشَاءِ، وَأَقَلُّهُ رَكْعَةٌ وَاحِدَةٌ، وَأَكْثَرُهُ إِحْدَى عَشْرَةَ رَكْعَةً. وَيُسْتَحَبُّ أَنْ يَخْتِمَ اللَّيْلَ بِالْوِتْرِ.',
    ),
    WorshipItem(
      id: 'rawatib_12',
      categoryId: 'rawatib',
      title: 'من حافظ على سنة الفجر أدركه الله بنوره',
      sortOrder: 11,
      kind: 'virtue',
      meta: {
        'prayerKey': 'fajr',
        'timing': 'before',
      },
      reference: 'رواه أبو داود والترمذي',
      body:
          'مَنْ صَلَّى الْفَجْرَ فَهُوَ فِي ذِمَّةِ اللَّهِ، وَمَنْ حَافَظَ عَلَى سُنَّةِ الْفَجْرِ أَدْرَكَهُ اللَّهُ بِنُورِهِ يَوْمَ الْقِيَامَةِ.',
    ),
    WorshipItem(
      id: 'rawatib_13',
      categoryId: 'rawatib',
      title: 'السنن الراتبة تُكَفِّرُ الخطايا',
      sortOrder: 12,
      kind: 'virtue',
      reference: 'رواه مسلم',
      body:
          'قَالَ ﷺ: «أَرَأَيْتُمْ لَوْ أَنَّ نَهْرًا بِبَابِ أَحَدِكُمْ يَغْتَسِلُ فِيهِ كُلَّ يَوْمٍ خَمْسَ مَرَّاتٍ، هَلْ يَبْقَى مِنْ دَرَنِهِ شَيْءٌ؟» قَالُوا: لَا. قَالَ: «فَذَلِكَ مَثَلُ الصَّلَوَاتِ الْخَمْسِ، يَمْحُو اللَّهُ بِهِنَّ الْخَطَايَا».',
    ),
    WorshipItem(
      id: 'rawatib_14',
      categoryId: 'rawatib',
      title: 'من صلى البردين دخل الجنة',
      sortOrder: 13,
      kind: 'virtue',
      reference: 'رواه البخاري ومسلم',
      body:
          'مَنْ صَلَّى الْبَرْدَيْنِ دَخَلَ الْجَنَّةَ: صَلَاةُ الْفَجْرِ وَصَلَاةُ الْعَصْرِ، وَمِنْ أَعْظَمِ مَا يُعِينُ عَلَى حِفْظِهِمَا حِفْظُ السُّنَنِ الرَّاتِبَةِ.',
    ),
  ];
}
