import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goman_alhoda/core/constants/app_strings.dart';
import 'package:goman_alhoda/features/khutbahs/data/khutbah_models.dart';
import 'package:goman_alhoda/features/khutbahs/presentation/providers/khutbah_providers.dart';
import 'package:goman_alhoda/features/khutbahs/presentation/screens/khutbahs_screen.dart';
import 'package:goman_alhoda/features/khutbahs/presentation/widgets/khutbah_category_grid.dart';

final _samples = [
  KhutbahIndexEntry(
    id: 1,
    title: 'يتخوضون في مال الله',
    slug: 'slug-1',
    categoryText: 'المعاملات',
    authorName: 'الشيخ عبدالعزيز',
    pdfFileName: 'يتخوضون_في_مال_الله.pdf',
    createdAt: '2024-08-20 09:10:09',
  ),
  KhutbahIndexEntry(
    id: 2,
    title: 'الجنة دار الكرامة',
    slug: 'slug-2',
    categoryText: 'الحياة الآخرة',
    authorName: 'الشيخ محمد',
    pdfFileName: 'الجنة_دار_الكرامة.pdf',
    createdAt: '2024-07-01 09:10:09',
  ),
];

void main() {
  testWidgets('KhutbahsScreen shows category grid by default', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          khutbahIndexProvider.overrideWith((ref) async => _samples),
        ],
        child: const MaterialApp(
          locale: Locale('ar'),
          home: Scaffold(
            body: KhutbahsScreen(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text(AppStrings.khutbahs), findsOneWidget);
    expect(find.byType(KhutbahCategoryGrid), findsOneWidget);
    expect(find.text('المعاملات'), findsOneWidget);
    expect(find.text('الحياة الآخرة'), findsOneWidget);
    expect(find.text('يتخوضون في مال الله'), findsNothing);
    expect(find.text('الجنة دار الكرامة'), findsNothing);
  });

  testWidgets('KhutbahsScreen opens category list on tap', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          khutbahIndexProvider.overrideWith((ref) async => _samples),
        ],
        child: const MaterialApp(
          locale: Locale('ar'),
          home: Scaffold(
            body: KhutbahsScreen(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('المعاملات'));
    await tester.pumpAndSettle();

    expect(find.text('يتخوضون في مال الله'), findsOneWidget);
    expect(find.text('الجنة دار الكرامة'), findsNothing);
    expect(find.byType(KhutbahCategoryGrid), findsNothing);
  });

  testWidgets('KhutbahsScreen filters on search', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          khutbahIndexProvider.overrideWith((ref) async => _samples),
        ],
        child: const MaterialApp(
          locale: Locale('ar'),
          home: Scaffold(
            body: KhutbahsScreen(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'الجنة');
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('الجنة دار الكرامة'), findsOneWidget);
    expect(find.text('يتخوضون في مال الله'), findsNothing);
    expect(find.byType(KhutbahCategoryGrid), findsNothing);
  });

  testWidgets('KhutbahsScreen clears search immediately', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          khutbahIndexProvider.overrideWith((ref) async => _samples),
        ],
        child: const MaterialApp(
          locale: Locale('ar'),
          home: Scaffold(
            body: KhutbahsScreen(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'الجنة');
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('الجنة دار الكرامة'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();

    expect(find.byType(KhutbahCategoryGrid), findsOneWidget);
    expect(find.text('الجنة دار الكرامة'), findsNothing);
  });
}
