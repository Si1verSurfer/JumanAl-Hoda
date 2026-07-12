import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:pdfrx/pdfrx.dart';

import 'app/goman_app.dart';
import 'core/widgets/goman_splash_screen.dart';
import 'features/adhkar/data/worship_database.dart';
import 'features/prayer_times/background/prayer_background_tasks.dart';
import 'features/prayer_times/data/prayer_times_cache_storage.dart';
import 'features/prayer_times/notifications/prayer_notification_service.dart';
import 'features/prayer_times/notifications/prayer_timezone.dart';
import 'features/prayer_times/presentation/widgets/prayer_schedule_lifecycle_listener.dart';
import 'features/quran/data/quran_ayah_library_storage.dart';
import 'features/quran/data/quran_tafseer_cache.dart';
import 'features/khutbahs/data/khutbah_index_loader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await pdfrxFlutterInitialize();
  await initializeDateFormatting('ar');
  await QuranTafseerCache.init();
  await QuranAyahLibraryStorage.init();
  await PrayerTimesCacheStorage.init();
  await WorshipDatabase.init();
  await KhutbahIndexLoader.init();
  await PrayerNotificationService.init();
  await PrayerTimezone.configure();
  await PrayerBackgroundTasks.initialize();
  runApp(
    const ProviderScope(
      child: GomanSplashGate(
        child: PrayerScheduleLifecycleListener(
          child: GomanApp(),
        ),
      ),
    ),
  );
}
