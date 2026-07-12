import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/prayer_time_format_provider.dart';
import '../../../../core/utils/prayer_time_formatter.dart';

typedef PrayerTimeLabelFormatter = String Function(DateTime time);

final prayerTimeLabelProvider = Provider<PrayerTimeLabelFormatter>((ref) {
  final is24Hour = ref.watch(prayerTimeFormatProvider).valueOrNull ?? false;
  return (DateTime time) =>
      PrayerTimeFormatter.format(time, is24Hour: is24Hour);
});
