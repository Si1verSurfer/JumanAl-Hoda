import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'khutbah_constants.dart';
import 'khutbah_models.dart';

abstract final class KhutbahIndexLoader {
  static Box<String>? _box;

  static Future<void> init() async {
    if (!Hive.isBoxOpen(KhutbahConstants.hiveBoxName)) {
      _box = await Hive.openBox<String>(KhutbahConstants.hiveBoxName);
    } else {
      _box = Hive.box<String>(KhutbahConstants.hiveBoxName);
    }
  }

  static Future<List<KhutbahIndexEntry>> loadIndex() async {
    await init();
    final box = _box!;
    final version =
        int.tryParse(box.get(KhutbahConstants.hiveVersionKey) ?? '') ?? 0;
    final cached = box.get(KhutbahConstants.hiveDataKey);

    if (version >= KhutbahConstants.indexVersion && cached != null) {
      return _parseEntries(cached);
    }

    final raw = await rootBundle.loadString(KhutbahConstants.indexAssetPath);
    await box.put(KhutbahConstants.hiveDataKey, raw);
    await box.put(
      KhutbahConstants.hiveVersionKey,
      '${KhutbahConstants.indexVersion}',
    );
    return _parseEntries(raw);
  }

  static List<KhutbahIndexEntry> _parseEntries(String raw) {
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => KhutbahIndexEntry.fromJson(e as Map<String, dynamic>))
        .where(
          (entry) =>
              entry.hasPdf &&
              !KhutbahConstants.excludedCategories
                  .contains(entry.categoryText.trim()),
        )
        .toList(growable: false);
  }
}
