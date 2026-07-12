import 'package:flutter_test/flutter_test.dart';
import 'package:goman_alhoda/core/utils/prayer_time_formatter.dart';

void main() {
  group('PrayerTimeFormatter', () {
    test('formats 24-hour clock with Arabic digits', () {
      final label = PrayerTimeFormatter.format(
        DateTime(2026, 6, 15, 14, 5),
        is24Hour: true,
      );
      expect(label, '١٤:٠٥');
    });

    test('formats 12-hour clock with Arabic digits and period', () {
      final am = PrayerTimeFormatter.format(
        DateTime(2026, 6, 15, 4, 30),
        is24Hour: false,
      );
      expect(am, '٠٤:٣٠ ص');

      final pm = PrayerTimeFormatter.format(
        DateTime(2026, 6, 15, 14, 5),
        is24Hour: false,
      );
      expect(pm, '٠٢:٠٥ م');

      final noon = PrayerTimeFormatter.format(
        DateTime(2026, 6, 15, 12, 0),
        is24Hour: false,
      );
      expect(noon, '١٢:٠٠ م');

      final midnight = PrayerTimeFormatter.format(
        DateTime(2026, 6, 15, 0, 15),
        is24Hour: false,
      );
      expect(midnight, '١٢:١٥ ص');
    });
  });
}
