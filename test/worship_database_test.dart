import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:goman_alhoda/features/adhkar/data/worship_database.dart';
import 'package:goman_alhoda/features/adhkar/data/worship_repository.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp('worship_test');
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

  test('seeds worship categories and items', () {
    final repository = WorshipRepository();
    final categories = repository.getCategories();

    expect(categories.length, greaterThanOrEqualTo(25));
    expect(categories.first.title, 'أذكاري');
    expect(
      repository.getItemsForCategory('morning').length,
      greaterThanOrEqualTo(23),
    );
    expect(
      repository.getItemsForCategory('evening').length,
      greaterThanOrEqualTo(24),
    );
    expect(
      repository.getItemsForCategory('sleep').length,
      greaterThanOrEqualTo(13),
    );
    expect(
      repository.getItemsForCategory('allah_names').length,
      99,
    );
    final firstName = repository
        .getItemsForCategory('allah_names')
        .firstWhere((i) => i.id == 'name_02');
    expect(firstName.quranReference, isNotNull);
    expect(firstName.benefit, isNotNull);
    expect(firstName.invocation, isNotNull);
  });

  test('guide categories exist with correct layout', () {
    final repository = WorshipRepository();
    final guides = repository
        .getCategories()
        .where((c) => c.group == 'guides')
        .toList();

    expect(guides.length, 7);
    expect(
      guides.map((c) => c.id).toList(),
      containsAll([
        'rawatib',
        'jumuah',
        'duha',
        'forbidden_times',
        'dua_dhikr',
        'dua_etiquette',
        'qada_ramadan',
      ]),
    );

    final qada = repository.getCategory('qada_ramadan');
    expect(qada?.fullWidth, isTrue);
    expect(qada?.group, 'guides');
  });

  test('guide sections have minimum item counts', () {
    final repository = WorshipRepository();

    expect(repository.getItemsForCategory('rawatib').length, greaterThanOrEqualTo(12));
    expect(repository.getItemsForCategory('jumuah').length, greaterThanOrEqualTo(18));
    expect(repository.getItemsForCategory('duha').length, greaterThanOrEqualTo(6));
    expect(
      repository.getItemsForCategory('forbidden_times').length,
      greaterThanOrEqualTo(8),
    );
    expect(
      repository.getItemsForCategory('dua_etiquette').length,
      greaterThanOrEqualTo(15),
    );
    expect(
      repository.getItemsForCategory('qada_ramadan').length,
      greaterThanOrEqualTo(8),
    );
    expect(
      repository.getItemsForCategory('dua_dhikr').length,
      greaterThanOrEqualTo(75),
    );
  });

  test('no duplicate worship item ids', () {
    final repository = WorshipRepository();
    final ids = repository.getAllItems().map((e) => e.id).toList();
    expect(ids.length, ids.toSet().length);
  });

  test('dua_dhikr items have tab meta', () {
    final repository = WorshipRepository();
    final items = repository.getItemsForCategory('dua_dhikr');

    expect(items, isNotEmpty);
    for (final item in items) {
      expect(item.metaString('tab'), isIn(['dua', 'dhikr']));
    }
  });

  test('rawatib covers all five prayers', () {
    final repository = WorshipRepository();
    final keys = repository
        .getItemsForCategory('rawatib')
        .map((e) => e.metaString('prayerKey'))
        .whereType<String>()
        .toSet();

    expect(keys, containsAll(['fajr', 'dhuhr', 'asr', 'maghrib', 'isha']));
  });

  test('favorites can be toggled', () async {
    final repository = WorshipRepository();
    expect(repository.isFavorite('evening_01'), isFalse);

    await repository.toggleFavorite('evening_01');
    expect(repository.isFavorite('evening_01'), isTrue);
    expect(repository.getFavoriteItems(), isNotEmpty);

    await repository.toggleFavorite('evening_01');
    expect(repository.isFavorite('evening_01'), isFalse);
  });
}
