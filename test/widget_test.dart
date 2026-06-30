import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goman_alhoda/app/goman_app.dart';
import 'package:goman_alhoda/core/constants/app_strings.dart';

void main() {
  testWidgets('GomanApp renders Arabic nav labels', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: GomanApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.navAdhkar), findsWidgets);
    expect(find.text(AppStrings.navQuran), findsOneWidget);
    expect(find.text(AppStrings.navDuas), findsOneWidget);
    expect(find.text(AppStrings.navPrayerTimes), findsOneWidget);
    expect(find.text(AppStrings.adhkar), findsWidgets);
  });
}
