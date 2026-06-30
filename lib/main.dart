import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/goman_app.dart';
import 'features/quran/data/quran_ayah_library_storage.dart';
import 'features/quran/data/quran_tafseer_cache.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await QuranTafseerCache.init();
  await QuranAyahLibraryStorage.init();
  runApp(
    const ProviderScope(
      child: GomanApp(),
    ),
  );
}
