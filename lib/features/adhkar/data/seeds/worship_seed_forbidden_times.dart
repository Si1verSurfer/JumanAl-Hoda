import '../models/worship_item.dart';

/// أوقات النهي عن الصلاة — من حصن المسلم (باب أوقات النهي عن الصلاة).
abstract final class WorshipSeedForbiddenTimes {
  static const items = <WorshipItem>[
    WorshipItem(
      id: 'forbidden_times_01',
      categoryId: 'forbidden_times',
      title: 'النهي عن الصلاة بعد الفجر',
      sortOrder: 0,
      kind: 'time_window',
      meta: {'windowKey': 'after_fajr'},
      reference: 'رواه مسلم',
      body:
          'لَا صَلَاةَ بَعْدَ صَلَاةِ الصُّبْحِ حَتَّى تَطْلُعَ الشَّمْسُ، وَلَا صَلَاةَ بَعْدَهَا حَتَّى تَزُولَ.',
    ),
    WorshipItem(
      id: 'forbidden_times_02',
      categoryId: 'forbidden_times',
      title: 'وقت طلوع الشمس',
      sortOrder: 1,
      kind: 'time_window',
      meta: {'windowKey': 'after_fajr'},
      reference: 'رواه مسلم',
      body:
          'يُنْهَى عَنِ الصَّلَاةِ مِنْ طُلُوعِ الْفَجْرِ حَتَّى تَطْلُعَ الشَّمْسُ بِعَيْنِهَا، وَيَسْتَثْنَى مِنْ ذَلِكَ صَلَاةُ الْفَجْرِ الْمَفْرُوضَةُ وَسُنَّتُهَا.',
    ),
    WorshipItem(
      id: 'forbidden_times_03',
      categoryId: 'forbidden_times',
      title: 'النهي عن الصلاة عند زوال الشمس',
      sortOrder: 2,
      kind: 'time_window',
      meta: {'windowKey': 'zenith'},
      reference: 'رواه مسلم',
      body:
          'لَا صَلَاةَ عِنْدَ طُلُوعِ الشَّمْسِ وَلَا عِنْدَ غُرُوبِهَا. وَيُنْهَى عَنِ الصَّلَاةِ عِنْدَ زَوَالِ الشَّمْسِ حَتَّى تَمِيلَ قَلِيلًا.',
    ),
    WorshipItem(
      id: 'forbidden_times_04',
      categoryId: 'forbidden_times',
      title: 'وقت الظهيرة — زوال الشمس',
      sortOrder: 3,
      kind: 'time_window',
      meta: {'windowKey': 'zenith'},
      reference: 'رواه مسلم',
      body:
          'يُنْهَى عَنِ الصَّلَاةِ عِنْدَ زَوَالِ الشَّمْسِ؛ لِأَنَّهَا تَطْلُعُ بَيْنَ قَرْنَيِ الشَّيْطَانِ حِينَئِذٍ، وَيُسْتَثْنَى صَلَاةُ الْعَصْرِ يَوْمَ الْجُمُعَةِ لِمَنْ لَمْ يُصَلِّ الْجُمُعَةَ.',
    ),
    WorshipItem(
      id: 'forbidden_times_05',
      categoryId: 'forbidden_times',
      title: 'النهي عن الصلاة بعد العصر',
      sortOrder: 4,
      kind: 'time_window',
      meta: {'windowKey': 'after_asr'},
      reference: 'رواه مسلم',
      body:
          'لَا صَلَاةَ بَعْدَ الْعَصْرِ حَتَّى تَغْرُبَ الشَّمْسُ. وَيَسْتَثْنَى مِنْ ذَلِكَ صَلَاةُ الْعَصْرِ الْمَفْرُوضَةُ وَقَضَاءُ الْفَوَائِتِ.',
    ),
    WorshipItem(
      id: 'forbidden_times_06',
      categoryId: 'forbidden_times',
      title: 'وقت غروب الشمس',
      sortOrder: 5,
      kind: 'time_window',
      meta: {'windowKey': 'after_asr'},
      reference: 'رواه مسلم',
      body:
          'يُنْهَى عَنِ الصَّلَاةِ عِنْدَ غُرُوبِ الشَّمْسِ حَتَّى تَغِيبَ بِكُلِّهَا، وَيَسْتَثْنَى صَلَاةُ الْمَغْرِبِ الْمَفْرُوضَةُ.',
    ),
    WorshipItem(
      id: 'forbidden_times_07',
      categoryId: 'forbidden_times',
      title: 'حديث جابر — ثلاثة أوقات',
      sortOrder: 6,
      kind: 'virtue',
      reference: 'رواه مسلم',
      body:
          'قَالَ جَابِرُ بْنُ عَبْدِ اللَّهِ: قَالَ رَسُولُ اللَّهِ ﷺ: «إِنَّ الشَّمْسَ تَطْلُعُ بَيْنَ قَرْنَيِ الشَّيْطَانِ، فَإِذَا طَلَعَتْ فَاجْتَنِبُوا الصَّلَاةَ، حَتَّى تَرْتَفِعَ، فَإِذَا ارْتَفَعَتْ فَصَلُّوا، فَإِنَّهَا تَطْلُعُ حِينَئِذٍ بَيْنَ قَرْنَيِ الشَّيْطَانِ، فَإِذَا زَالَتِ الشَّمْسُ فَاجْتَنِبُوا الصَّلَاةَ حَتَّى تَغِيبَ، فَإِنَّهَا تَغْرُبُ بَيْنَ قَرْنَيِ الشَّيْطَانِ».',
    ),
    WorshipItem(
      id: 'forbidden_times_08',
      categoryId: 'forbidden_times',
      title: 'ما يُستثنى من أوقات النهي',
      sortOrder: 7,
      kind: 'virtue',
      reference: 'من فقه السنة',
      body:
          'يُسْتَثْنَى مِنْ أَوْقَاتِ النَّهْيِ: الصَّلَوَاتُ الْمَفْرُوضَةُ، وَقَضَاءُ الْفَوَائِتِ، وَصَلَاةُ الطَّوَافِ، وَصَلَاةُ الْكُسُوفِ وَالْخُسُوفِ، وَصَلَاةُ اسْتِقْبَالِ الْقِبْلَةِ بَعْدَ تَحْوِيلِهَا.',
    ),
    WorshipItem(
      id: 'forbidden_times_09',
      categoryId: 'forbidden_times',
      title: 'صلاة الكسوف والخسوف',
      sortOrder: 8,
      kind: 'virtue',
      reference: 'رواه البخاري ومسلم',
      body:
          'صَلَاةُ الْكُسُوفِ وَالْخُسُوفِ مِنَ الْمُسْتَثْنَيَاتِ مِنْ أَوْقَاتِ النَّهْيِ، وَتُصَلَّى رَكْعَتَيْنِ فِيهَا بِقِرَاءَةٍ طَوِيلَةٍ وَرُكُوعٍ وَسُجُودٍ مُطَوَّلٍ.',
    ),
    WorshipItem(
      id: 'forbidden_times_10',
      categoryId: 'forbidden_times',
      title: 'حكمة النهي عن الصلاة في هذه الأوقات',
      sortOrder: 9,
      kind: 'virtue',
      reference: 'من فقه السنة',
      body:
          'حِكْمَةُ النَّهْيِ عَنِ الصَّلَاةِ فِي هَذِهِ الْأَوْقَاتِ: تَعْظِيمُ شَعَائِرِ اللَّهِ، وَاجْتِنَابُ مَوَاطِنِ عِبَادَةِ الْمُشْرِكِينَ، وَالْحَذَرُ مِنْ أَوْقَاتِ طُلُوعِ الشَّيْطَانِ وَغُرُوبِهِ.',
    ),
  ];
}
