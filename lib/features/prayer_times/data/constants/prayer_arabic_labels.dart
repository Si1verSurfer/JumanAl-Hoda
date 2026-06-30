import '../models/daily_prayer_schedule.dart';

/// Arabic labels with full tashkeel for prayer times UI.
abstract final class PrayerArabicLabels {
  static const String timesTitle = 'مَوَاقِيتُ الصَّلَاةِ';
  static const String nextPrayer = 'الصَّلَاةُ القَادِمَةُ';
  static const String remaining = 'مُتَبَقٍّ';
  static const String nextBadge = 'التَّالِيَةُ';
  static const String changeLocation = 'تَغْيِيرُ المَوْقِعِ';
  static const String useMyLocation = 'اسْتِخْدَامُ مَوْقِعِي';
  static const String searchCity = 'ابْحَثْ عَنْ مَدِينَةٍ';
  static const String popularCities = 'مَدِنٌ شَائِعَةٌ';
  static const String loadingLocation = 'جَارٍ تَحْدِيدُ المَوْقِعِ…';
  static const String hijriSuffix = 'هـ';
  static const String notificationSettingsTitle = 'تَنْبِيهَاتُ الصَّلَاةِ';
  static const String notificationMaster = 'تَفْعِيلُ التَّنْبِيهَاتِ';
  static const String notificationMasterSubtitle =
      'إِشْعَارٌ عِنْدَ حِينِ كُلِّ صَلَاةٍ';
  static const String notificationPermissionDenied =
      'يُرْجَى السَّمَاحُ بِالتَّنْبِيهَاتِ مِنْ إِعْدَادَاتِ الجِهَازِ';
  static const String notificationExactAlarmHint =
      'لِدِقَّةِ التَّنْبِيهَاتِ، فَعِّلِ السَّمَاحَ بِمُنَبِّهَاتِ التَّوْقِيتِ الدَّقِيقَةِ';

  static const String fajr = 'الفَجْرُ';
  static const String sunrise = 'الشُّرُوقُ';
  static const String dhuhr = 'الظُّهْرُ';
  static const String asr = 'العَصْرُ';
  static const String maghrib = 'المَغْرِبُ';
  static const String isha = 'العِشَاءُ';

  /// Decorative display names with kashida for the prayer list.
  static const String fajrDisplay = 'الفجــــر';
  static const String sunriseDisplay = 'الشـــروق';
  static const String dhuhrDisplay = 'الظهــــر';
  static const String asrDisplay = 'العصــــر';
  static const String maghribDisplay = 'المغـــرب';
  static const String ishaDisplay = 'العشــــاء';

  static const Map<PrayerTimeKind, String> prayerNames = {
    PrayerTimeKind.fajr: fajr,
    PrayerTimeKind.sunrise: sunrise,
    PrayerTimeKind.dhuhr: dhuhr,
    PrayerTimeKind.asr: asr,
    PrayerTimeKind.maghrib: maghrib,
    PrayerTimeKind.isha: isha,
  };

  static const Map<PrayerTimeKind, String> prayerDisplayNames = {
    PrayerTimeKind.fajr: fajrDisplay,
    PrayerTimeKind.sunrise: sunriseDisplay,
    PrayerTimeKind.dhuhr: dhuhrDisplay,
    PrayerTimeKind.asr: asrDisplay,
    PrayerTimeKind.maghrib: maghribDisplay,
    PrayerTimeKind.isha: ishaDisplay,
  };

  static const Map<int, String> hijriMonths = {
    1: 'مُحَرَّم',
    2: 'صَفَر',
    3: 'رَبِيع الأَوَّل',
    4: 'رَبِيع الآخِر',
    5: 'جُمَادى الأولى',
    6: 'جُمَادى الآخِرة',
    7: 'رَجَب',
    8: 'شَعْبَان',
    9: 'رَمَضَان',
    10: 'شَوَّال',
    11: 'ذُو القَعْدَة',
    12: 'ذُو الحِجَّة',
  };

  static const Map<String, String> weekdays = {
    'الأحد': 'الأَحَد',
    'الاحد': 'الأَحَد',
    'الاثنين': 'الإثْنَين',
    'الإثنين': 'الإثْنَين',
    'الثلاثاء': 'الثُّلَاثَاء',
    'الثلاثا': 'الثُّلَاثَاء',
    'الأربعاء': 'الأَرْبِعَاء',
    'الاربعاء': 'الأَرْبِعَاء',
    'الخميس': 'الخَمِيس',
    'الجمعة': 'الجُمُعَة',
    'السبت': 'السَّبْت',
  };

  static String prayerName(PrayerTimeKind kind) => prayerNames[kind] ?? fajr;

  static String prayerDisplayName(PrayerTimeKind kind) =>
      prayerDisplayNames[kind] ?? fajrDisplay;

  static String hijriMonth(int month) =>
      hijriMonths[month] ?? hijriMonths[1]!;

  static String weekday(String rawWeekday) {
    final normalized = rawWeekday.trim();
    return weekdays[normalized] ??
        weekdays[normalized.replaceAll(' ', '')] ??
        normalized;
  }
}
