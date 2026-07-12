import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goman_alhoda/features/prayer_times/data/constants/prayer_arabic_labels.dart';
import 'package:goman_alhoda/features/prayer_times/data/models/prayer_location.dart';
import 'package:goman_alhoda/features/prayer_times/presentation/providers/prayer_countdown_provider.dart';
import 'package:goman_alhoda/features/prayer_times/presentation/providers/prayer_location_provider.dart';
import 'package:goman_alhoda/features/prayer_times/presentation/providers/prayer_schedule_sync_provider.dart';
import 'package:goman_alhoda/features/prayer_times/presentation/screens/prayer_times_screen.dart';
import 'package:goman_alhoda/features/prayer_times/presentation/widgets/prayer_date_header.dart';
import 'package:intl/date_symbol_data_local.dart';

class _NoOpPrayerScheduleSyncNotifier extends PrayerScheduleSyncNotifier {
  @override
  Future<void> build() async {}

  @override
  Future<void> syncAll() async {}

  @override
  Future<void> syncIfStale() async {}
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ar');
  });

  testWidgets('PrayerTimesScreen renders hijri header and prayer names', (
    tester,
  ) async {
    const location = PrayerLocation(
      latitude: 24.7136,
      longitude: 46.6753,
      label: 'الرياض',
      source: PrayerLocationSource.manual,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          prayerLocationSeedProvider.overrideWithValue(location),
          prayerSecondTickerProvider.overrideWith(
            (ref) => Stream.value(DateTime(2026, 3, 15, 10, 0)),
          ),
          prayerScheduleSyncProvider.overrideWith(_NoOpPrayerScheduleSyncNotifier.new),
        ],
        child: const MaterialApp(
          locale: Locale('ar'),
          home: PrayerTimesScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text(PrayerArabicLabels.fajrDisplay), findsWidgets);
    expect(find.text(PrayerArabicLabels.dhuhrDisplay), findsWidgets);
    expect(find.textContaining('الرياض'), findsWidgets);
    expect(find.byType(PrayerDateHeader), findsOneWidget);
  });
}
