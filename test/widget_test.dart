import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goman_alhoda/app/goman_app.dart';
import 'package:goman_alhoda/core/constants/app_strings.dart';
import 'package:goman_alhoda/features/adhkar/data/worship_database.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp('worship_widget_test');
    Hive.init(tempDir.path);
    await WorshipDatabase.init(useFlutterPath: false);
  });

  tearDownAll(() async {
    if (Hive.isBoxOpen('worship_library_v1')) {
      await Hive.box<String>('worship_library_v1').close();
    }
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });
  testWidgets('GomanApp renders Arabic nav labels', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: GomanApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.navHome), findsWidgets);
    expect(find.text(AppStrings.navQuran), findsOneWidget);
    expect(find.text(AppStrings.navKhutbahs), findsOneWidget);
    expect(find.text(AppStrings.navPrayerTimes), findsOneWidget);
    expect(find.text(AppStrings.home), findsWidgets);
    expect(find.text('أذكار الصباح'), findsOneWidget);
    expect(find.text('أذكار المساء'), findsOneWidget);
  });
}
