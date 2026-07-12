import 'models/worship_category.dart';
import 'models/worship_item.dart';
import 'seeds/worship_seed_allah_names.dart';
import 'seeds/worship_seed_after_prayer.dart';
import 'seeds/worship_seed_dua_dhikr.dart';
import 'seeds/worship_seed_dua_etiquette.dart';
import 'seeds/worship_seed_duha.dart';
import 'seeds/worship_seed_evening.dart';
import 'seeds/worship_seed_forbidden_times.dart';
import 'seeds/worship_seed_jumuah.dart';
import 'seeds/worship_seed_morning.dart';
import 'seeds/worship_seed_prayer.dart';
import 'seeds/worship_seed_qada_ramadan.dart';
import 'seeds/worship_seed_rawatib.dart';
import 'seeds/worship_seed_sleep.dart';
import 'seeds/worship_seed_waking.dart';

/// Built-in worship catalog — categories and adhkar/dua content from حصن المسلم.
abstract final class WorshipSeedData {
  static const seedVersion = 8;

  static const categories = <WorshipCategory>[
    WorshipCategory(
      id: 'my_adhkar',
      title: 'أذكاري',
      accentColorArgb: 0xFF00897B,
      sortOrder: 0,
    ),
    WorshipCategory(
      id: 'allah_names',
      title: 'أسماء الله الحسنى',
      accentColorArgb: 0xFF6B1E23,
      sortOrder: 1,
    ),
    WorshipCategory(
      id: 'morning',
      title: 'أذكار الصباح',
      accentColorArgb: 0xFF42A5F5,
      sortOrder: 2,
    ),
    WorshipCategory(
      id: 'evening',
      title: 'أذكار المساء',
      accentColorArgb: 0xFFE53935,
      sortOrder: 3,
    ),
    WorshipCategory(
      id: 'prayer',
      title: 'أذكار الصلاة',
      accentColorArgb: 0xFFA1887F,
      sortOrder: 4,
    ),
    WorshipCategory(
      id: 'after_prayer',
      title: 'أذكار بعد الصلاة',
      accentColorArgb: 0xFF1E88E5,
      sortOrder: 5,
    ),
    WorshipCategory(
      id: 'sleep',
      title: 'أذكار النوم',
      accentColorArgb: 0xFFAB47BC,
      sortOrder: 6,
    ),
    WorshipCategory(
      id: 'waking',
      title: 'أذكار الاستيقاظ',
      accentColorArgb: 0xFF7E57C2,
      sortOrder: 7,
    ),
    WorshipCategory(
      id: 'quran_duas',
      title: 'أدعية من القرآن',
      accentColorArgb: 0xFF757575,
      sortOrder: 8,
    ),
    WorshipCategory(
      id: 'prophet_duas',
      title: 'من دعاء الرسول ﷺ',
      accentColorArgb: 0xFFF9A825,
      sortOrder: 9,
    ),
    WorshipCategory(
      id: 'ruqyah_sunnah',
      title: 'الرقية بالسنة',
      accentColorArgb: 0xFF7CB342,
      sortOrder: 10,
    ),
    WorshipCategory(
      id: 'ruqyah_quran',
      title: 'الرقية بالقرآن',
      accentColorArgb: 0xFFFB8C00,
      sortOrder: 11,
    ),
    WorshipCategory(
      id: 'tasbeeh',
      title: 'تسابيح',
      accentColorArgb: 0xFF2196F3,
      sortOrder: 12,
    ),
    WorshipCategory(
      id: 'hamd',
      title: 'الحمد والثناء',
      accentColorArgb: 0xFF8D6E63,
      sortOrder: 13,
    ),
    WorshipCategory(
      id: 'istighfar',
      title: 'الاستغفار',
      accentColorArgb: 0xFF78909C,
      sortOrder: 14,
    ),
    WorshipCategory(
      id: 'more',
      title: 'المزيد',
      accentColorArgb: 0xFF9E9D24,
      sortOrder: 15,
    ),
    WorshipCategory(
      id: 'comprehensive',
      title: 'أدعية شاملة',
      accentColorArgb: 0xFF2C0F12,
      sortOrder: 16,
      fullWidth: true,
    ),
    WorshipCategory(
      id: 'deceased',
      title: 'أدعية الميت',
      accentColorArgb: 0xFF2C0F12,
      sortOrder: 17,
    ),
    WorshipCategory(
      id: 'verse_tafsir',
      title: 'آية وتفسير',
      accentColorArgb: 0xFF2C0F12,
      sortOrder: 18,
    ),
    WorshipCategory(
      id: 'rawatib',
      title: 'السنن الرواتب',
      accentColorArgb: 0xFF2C0F12,
      sortOrder: 19,
      group: 'guides',
    ),
    WorshipCategory(
      id: 'jumuah',
      title: 'الجمعة',
      accentColorArgb: 0xFF2C0F12,
      sortOrder: 20,
      group: 'guides',
    ),
    WorshipCategory(
      id: 'duha',
      title: 'صلاة الضحى',
      accentColorArgb: 0xFF2C0F12,
      sortOrder: 21,
      group: 'guides',
    ),
    WorshipCategory(
      id: 'forbidden_times',
      title: 'أوقات النهي',
      accentColorArgb: 0xFF2C0F12,
      sortOrder: 22,
      group: 'guides',
    ),
    WorshipCategory(
      id: 'dua_dhikr',
      title: 'الدعاء والذكر',
      accentColorArgb: 0xFF2C0F12,
      sortOrder: 23,
      group: 'guides',
    ),
    WorshipCategory(
      id: 'dua_etiquette',
      title: 'آداب الدعاء',
      accentColorArgb: 0xFF2C0F12,
      sortOrder: 24,
      group: 'guides',
    ),
    WorshipCategory(
      id: 'qada_ramadan',
      title: 'قضاء رمضان',
      accentColorArgb: 0xFF2C0F12,
      sortOrder: 25,
      group: 'guides',
      fullWidth: true,
    ),
  ];

  static final items = <WorshipItem>[
    ...WorshipSeedMorning.items,
    ...WorshipSeedEvening.items,
    ...WorshipSeedSleep.items,
    ...WorshipSeedWaking.items,
    ...WorshipSeedAfterPrayer.items,
    ...WorshipSeedPrayer.items,
    ...WorshipSeedAllahNames.items,
    ...WorshipSeedRawatib.items,
    ...WorshipSeedJumuah.items,
    ...WorshipSeedDuha.items,
    ...WorshipSeedForbiddenTimes.items,
    ...WorshipSeedDuaDhikr.items,
    ...WorshipSeedDuaEtiquette.items,
    ...WorshipSeedQadaRamadan.items,
    ..._miscItems,
  ];

  static const _miscItems = <WorshipItem>[
    // —— Istighfar ——
    WorshipItem(
      id: 'istighfar_1',
      categoryId: 'istighfar',
      title: 'سيد الاستغفار',
      sortOrder: 0,
      repeatHint: 'مرة واحدة',
      reference: 'متفق عليه',
      body:
          'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَٰهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ لَكَ بِذَنْبِي، فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ.',
    ),
    WorshipItem(
      id: 'istighfar_2',
      categoryId: 'istighfar',
      title: 'الاستغفار المختصر',
      sortOrder: 1,
      repeatHint: '١٠٠ مرة في اليوم',
      body: 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ وَأَتُوبُ إِلَيْهِ.',
    ),
    WorshipItem(
      id: 'istighfar_3',
      categoryId: 'istighfar',
      title: 'استغفار نبي الله ﷺ',
      sortOrder: 2,
      repeatHint: 'مرة واحدة',
      reference: 'رواه البخاري',
      body:
          'رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ.',
    ),
    WorshipItem(
      id: 'istighfar_4',
      categoryId: 'istighfar',
      title: 'الاستغفار والتوبة',
      sortOrder: 3,
      repeatHint: '١٠٠ مرة',
      reference: 'رواه أبو داود والترمذي',
      body: 'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ.',
    ),

    // —— Tasbeeh ——
    WorshipItem(
      id: 'tasbeeh_1',
      categoryId: 'tasbeeh',
      title: 'التسبيحات الأربع',
      sortOrder: 0,
      body:
          'سُبْحَانَ اللَّهِ، وَالْحَمْدُ لِلَّهِ، وَلَا إِلَٰهَ إِلَّا اللَّهُ، وَاللَّهُ أَكْبَرُ.',
    ),
    WorshipItem(
      id: 'tasbeeh_2',
      categoryId: 'tasbeeh',
      title: 'تسبيح بعد الصلاة',
      sortOrder: 1,
      repeatHint: '٣٣ + ٣٣ + ٣٤',
      reference: 'رواه مسلم',
      body:
          'سُبْحَانَ اللَّهِ (٣٣)، وَالْحَمْدُ لِلَّهِ (٣٣)، وَاللَّهُ أَكْبَرُ (٣٤).',
    ),
    WorshipItem(
      id: 'tasbeeh_3',
      categoryId: 'tasbeeh',
      title: 'سبحان الله وبحمده',
      sortOrder: 2,
      repeatHint: '١٠٠ مرة',
      reference: 'رواه مسلم',
      body: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ.',
    ),

    // —— Hamd ——
    WorshipItem(
      id: 'hamd_1',
      categoryId: 'hamd',
      title: 'الحمد لله',
      sortOrder: 0,
      body: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ.',
    ),
    WorshipItem(
      id: 'hamd_2',
      categoryId: 'hamd',
      title: 'حمد الله على كل حال',
      sortOrder: 1,
      reference: 'رواه مسلم',
      body:
          'الْحَمْدُ لِلَّهِ الَّذِي عَافَانِي فِيمَا ابْتَلَى بِهِ فَضْلًا عَنْ كَثِيرٍ مِمَّنْ خَلَقَ تَفْضِيلًا.',
    ),

    // —— Prophet duas ——
    WorshipItem(
      id: 'prophet_1',
      categoryId: 'prophet_duas',
      title: 'دعاء الكرب',
      sortOrder: 0,
      reference: 'رواه البخاري',
      body:
          'لَا إِلَٰهَ إِلَّا اللَّهُ الْعَظِيمُ الْحَلِيمُ، لَا إِلَٰهَ إِلَّا اللَّهُ رَبُّ الْعَرْشِ الْعَظِيمِ، لَا إِلَٰهَ إِلَّا اللَّهُ رَبُّ السَّمَاوَاتِ وَرَبُّ الْأَرْضِ وَرَبُّ الْعَرْشِ الْكَرِيمِ.',
    ),
    WorshipItem(
      id: 'prophet_2',
      categoryId: 'prophet_duas',
      title: 'دعاء الهم والحزن',
      sortOrder: 1,
      reference: 'رواه البخاري',
      body:
          'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَالْعَجْزِ وَالْكَسَلِ، وَالْبُخْلِ وَالْجُبْنِ، وَضَلَعِ الدَّيْنِ، وَغَلَبَةِ الرِّجَالِ.',
    ),
    WorshipItem(
      id: 'prophet_3',
      categoryId: 'prophet_duas',
      title: 'دعاء التوبة',
      sortOrder: 2,
      reference: 'رواه الترمذي',
      body:
          'اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي.',
    ),

    // —— Quran duas ——
    WorshipItem(
      id: 'quran_1',
      categoryId: 'quran_duas',
      title: 'دعاء آدم عليه السلام',
      sortOrder: 0,
      reference: 'سورة الأعراف ٢٣',
      body:
          'رَبَّنَا ظَلَمْنَا أَنْفُسَنَا وَإِنْ لَمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُونَنَّ مِنَ الْخَاسِرِينَ.',
    ),
    WorshipItem(
      id: 'quran_2',
      categoryId: 'quran_duas',
      title: 'دعاء يونس عليه السلام',
      sortOrder: 1,
      reference: 'سورة الأنبياء ٨٧',
      body:
          'لَا إِلَٰهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ.',
    ),
    WorshipItem(
      id: 'quran_3',
      categoryId: 'quran_duas',
      title: 'دعاء الذكر والشكر',
      sortOrder: 2,
      reference: 'سورة آل عمران ٨',
      body:
          'رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِنْ لَدُنْكَ رَحْمَةً ۚ إِنَّكَ أَنْتَ الْوَهَّابُ.',
    ),

    // —— Ruqyah sunnah ——
    WorshipItem(
      id: 'ruqyah_s_1',
      categoryId: 'ruqyah_sunnah',
      title: 'رقية النبي ﷺ لأسماء',
      sortOrder: 0,
      reference: 'رواه البخاري',
      body:
          'بِسْمِ اللَّهِ أَرْقِيكَ، مِنْ كُلِّ شَيْءٍ يُؤْذِيكَ، مِنْ شَرِّ كُلِّ نَفْسٍ أَوْ عَيْنِ حَاسِدٍ، اللَّهُ يَشْفِيكَ، بِسْمِ اللَّهِ أَرْقِيكَ.',
    ),

    // —— Ruqyah quran ——
    WorshipItem(
      id: 'ruqyah_q_1',
      categoryId: 'ruqyah_quran',
      title: 'الفاتحة',
      sortOrder: 0,
      body:
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ ۝ الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ ۝ الرَّحْمَٰنِ الرَّحِيمِ ۝ مَالِكِ يَوْمِ الدِّينِ ۝ إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ ۝ اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ ۝ صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ.',
    ),
    WorshipItem(
      id: 'ruqyah_q_2',
      categoryId: 'ruqyah_quran',
      title: 'المعوذات',
      sortOrder: 1,
      body:
          'قُلْ هُوَ اللَّهُ أَحَدٌ ۝ اللَّهُ الصَّمَدُ ۝ لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ.\n\nقُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ۝ مِنْ شَرِّ مَا خَلَقَ ۝ وَمِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ ۝ وَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ۝ وَمِنْ شَرِّ حَاسِدٍ إِذَا حَسَدَ.\n\nقُلْ أَعُوذُ بِرَبِّ النَّاسِ ۝ مَلِكِ النَّاسِ ۝ إِلَٰهِ النَّاسِ ۝ مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ۝ الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ ۝ مِنَ الْجِنَّةِ وَالنَّاسِ.',
    ),

    // —— Comprehensive ——
    WorshipItem(
      id: 'comp_1',
      categoryId: 'comprehensive',
      title: 'دعاء لكل خير',
      sortOrder: 0,
      reference: 'رواه الترمذي',
      body:
          'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ خَيْرِ مَا سَأَلَكَ مِنْهُ نَبِيُّكَ مُحَمَّدٌ ﷺ، وَأَعُوذُ بِكَ مِنْ شَرِّ مَا اسْتَعَاذَ مِنْهُ نَبِيُّكَ مُحَمَّدٌ ﷺ، وَأَنْتَ الْمُسْتَعَانُ، وَعَلَيْكَ الْبَلَاغُ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ.',
    ),
    WorshipItem(
      id: 'comp_2',
      categoryId: 'comprehensive',
      title: 'دعاء جامع',
      sortOrder: 1,
      reference: 'رواه ابن حبان',
      body:
          'اللَّهُمَّ اهْدِنِي فِيمَنْ هَدَيْتَ، وَعَافِنِي فِيمَنْ عَافَيْتَ، وَتَوَلَّنِي فِيمَنْ تَوَلَّيْتَ، وَبَارِكْ لِي فِيمَا أَعْطَيْتَ، وَقِنِي شَرَّ مَا قَضَيْتَ، فَإِنَّكَ تَقْضِي وَلَا يُقْضَى عَلَيْكَ، إِنَّهُ لَا يَذِلُّ مَنْ وَالَيْتَ، وَلَا يَعِزُّ مَنْ عَادَيْتَ، تَبَارَكْتَ رَبَّنَا وَتَعَالَيْتَ.',
    ),

    // —— Deceased ——
    WorshipItem(
      id: 'deceased_1',
      categoryId: 'deceased',
      title: 'دعاء للميت',
      sortOrder: 0,
      reference: 'رواه مسلم',
      body:
          'اللَّهُمَّ اغْفِرْ لَهُ وَارْحَمْهُ، وَعَافِهِ وَاعْفُ عَنْهُ، وَأَكْرِمْ نُزُلَهُ، وَوَسِّعْ مُدْخَلَهُ، وَاغْسِلْهُ بِالْمَاءِ وَالثَّلْجِ وَالْبَرَدِ، وَنَقِّهِ مِنَ الْخَطَايَا كَمَا نَقَّيْتَ الثَّوْبَ الْأَبْيَضَ مِنَ الدَّنَسِ.',
    ),
    WorshipItem(
      id: 'deceased_2',
      categoryId: 'deceased',
      title: 'الدعاء عند زيارة القبور',
      sortOrder: 1,
      reference: 'رواه مسلم',
      body:
          'السَّلَامُ عَلَيْكُمْ أَهْلَ الدِّيَارِ مِنَ الْمُؤْمِنِينَ وَالْمُسْلِمِينَ، وَإِنَّا إِنْ شَاءَ اللَّهُ بِكُمْ لَاحِقُونَ، نَسْأَلُ اللَّهَ لَنَا وَلَكُمُ الْعَافِيَةَ.',
    ),

    // —— Verse & tafsir ——
    WorshipItem(
      id: 'verse_1',
      categoryId: 'verse_tafsir',
      title: 'آية الكرسي',
      sortOrder: 0,
      reference: 'سورة البقرة ٢٥٥',
      body:
          'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ.\n\n﴿لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ﴾ أي لا يغلبه نعاس ولا نوم؛ لأنه قيوم على خلقه في تدبيرهم.',
    ),
    WorshipItem(
      id: 'verse_2',
      categoryId: 'verse_tafsir',
      title: 'آخر آيتين من البقرة',
      sortOrder: 1,
      reference: 'سورة البقرة ٢٨٥-٢٨٦',
      body:
          'آمَنَ الرَّسُولُ بِمَا أُنْزِلَ إِلَيْهِ مِنْ رَبِّهِ وَالْمُؤْمِنُونَ ۚ كُلٌّ آمَنَ بِاللَّهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ لَا نُفَرِّقُ بَيْنَ أَحَدٍ مِنْ رُسُلِهِ ۚ وَقَالُوا سَمِعْنَا وَأَطَعْنَا ۖ غُفْرَانَكَ رَبَّنَا وَإِلَيْكَ الْمَصِيرُ.',
    ),

    // —— More ——
    WorshipItem(
      id: 'more_1',
      categoryId: 'more',
      title: 'دعاء دخول المنزل',
      sortOrder: 0,
      reference: 'رواه أبو داود',
      body:
          'بِسْمِ اللَّهِ وَلَجْنَا، وَبِسْمِ اللَّهِ خَرَجْنَا، وَعَلَى رَبِّنَا تَوَكَّلْنَا.',
    ),
    WorshipItem(
      id: 'more_2',
      categoryId: 'more',
      title: 'دعاء الخروج من المنزل',
      sortOrder: 1,
      reference: 'رواه أبو داود',
      body:
          'بِسْمِ اللَّهِ، تَوَكَّلْتُ عَلَى اللَّهِ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ.',
    ),
    WorshipItem(
      id: 'more_3',
      categoryId: 'more',
      title: 'دعاء دخول المسجد',
      sortOrder: 2,
      reference: 'رواه مسلم',
      body: 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ.',
    ),
  ];
}
