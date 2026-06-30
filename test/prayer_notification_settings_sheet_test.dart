import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goman_alhoda/features/prayer_times/data/models/prayer_notification_settings.dart';
import 'package:goman_alhoda/features/prayer_times/presentation/widgets/prayer_notification_settings_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('notification settings sheet shows sunrise toggle off by default',
      (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          locale: Locale('ar'),
          home: Scaffold(
            body: PrayerNotificationSettingsSheet(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final settings = PrayerNotificationSettings();
    expect(settings.sunrise, isFalse);

    final switches = tester.widgetList<Switch>(find.byType(Switch));
    expect(switches.length, greaterThan(1));
  });
}
