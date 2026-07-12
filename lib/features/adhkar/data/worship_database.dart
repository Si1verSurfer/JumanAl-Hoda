import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import 'models/worship_category.dart';
import 'models/worship_item.dart';
import 'worship_seed_data.dart';

abstract final class WorshipDatabase {
  static const _boxName = 'worship_library_v1';
  static const _seedVersionKey = '__seed_version__';
  static const _categoriesKey = '__categories__';
  static const _itemsKey = '__items__';
  static const _favoritesKey = '__favorites__';

  static Box<String>? _box;

  static Future<void> init({bool useFlutterPath = true}) async {
    if (!Hive.isBoxOpen(_boxName)) {
      if (useFlutterPath) {
        await Hive.initFlutter();
      }
      _box ??= await Hive.openBox<String>(_boxName);
    }
    await _seedIfNeeded();
  }

  static Future<void> _seedIfNeeded() async {
    final box = _box!;
    final currentVersion =
        int.tryParse(box.get(_seedVersionKey) ?? '') ?? 0;
    if (currentVersion >= WorshipSeedData.seedVersion &&
        box.get(_categoriesKey) != null &&
        box.get(_itemsKey) != null) {
      return;
    }

    await box.put(
      _categoriesKey,
      jsonEncode(
        WorshipSeedData.categories.map((c) => c.toJson()).toList(),
      ),
    );
    await box.put(
      _itemsKey,
      jsonEncode(WorshipSeedData.items.map((i) => i.toJson()).toList()),
    );
    await box.put(_seedVersionKey, '${WorshipSeedData.seedVersion}');
    if (box.get(_favoritesKey) == null) {
      await box.put(_favoritesKey, jsonEncode(<String>[]));
    }
  }

  static List<WorshipCategory> readCategories() {
    final raw = _box?.get(_categoriesKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => WorshipCategory.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  static List<WorshipItem> readItems() {
    final raw = _box?.get(_itemsKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => WorshipItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static List<String> readFavoriteIds() {
    final raw = _box?.get(_favoritesKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List<dynamic>).cast<String>();
  }

  static Future<void> writeFavoriteIds(List<String> ids) async {
    await init();
    await _box!.put(_favoritesKey, jsonEncode(ids));
  }
}
