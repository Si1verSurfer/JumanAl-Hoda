import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/goman_app.dart';
import 'features/prayer_times/background/prayer_background_tasks.dart';
import 'features/prayer_times/data/prayer_times_cache_storage.dart';
import 'features/prayer_times/notifications/prayer_notification_service.dart';
import 'features/prayer_times/notifications/prayer_timezone.dart';
import 'features/prayer_times/presentation/widgets/prayer_schedule_lifecycle_listener.dart';
import 'features/quran/data/quran_ayah_library_storage.dart';
import 'features/quran/data/quran_tafseer_cache.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar');
  await QuranTafseerCache.init();
  await QuranAyahLibraryStorage.init();
  await PrayerTimesCacheStorage.init();
  await PrayerNotificationService.init();
  await PrayerTimezone.configure();
  await PrayerBackgroundTasks.initialize();
  runApp(
    const ProviderScope(
      child: PrayerScheduleLifecycleListener(
        child: GomanApp(),
      ),
    ),
  );
}
