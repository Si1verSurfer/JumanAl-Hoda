import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

import 'prayer_background_callback.dart';

abstract final class PrayerBackgroundTasks {
  static const midnightTask = 'prayerMidnightRefresh';
  static const bootTask = 'prayerBootReschedule';
  static const midnightUniqueName =
      'jumanahjumanalhoda.com.prayerMidnightRefresh';
  static const _bootUniqueName = 'prayer_boot_reschedule';

  static DateTime? _scheduledMidnightTarget;

  static Future<void> initialize() async {
    await Workmanager().initialize(
      prayerBackgroundCallbackDispatcher,
      isInDebugMode: kDebugMode,
    );
    await registerBootReschedule();
  }

  /// Chains a one-off task after local midnight to refresh cache + notifications.
  ///
  /// Android only. iOS BGTaskScheduler rejects duplicate pending tasks (Code=1),
  /// especially in debug/simulator. Prayer times still refresh whenever the app
  /// resumes via [PrayerScheduleLifecycleListener].
  static Future<void> registerMidnightRefresh() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;

    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final delay = nextMidnight.difference(now);
    if (delay.isNegative) return;

    if (_scheduledMidnightTarget == nextMidnight) return;

    try {
      await Workmanager().registerOneOffTask(
        midnightUniqueName,
        midnightTask,
        initialDelay: delay,
        existingWorkPolicy: ExistingWorkPolicy.replace,
      );
      _scheduledMidnightTarget = nextMidnight;
    } catch (error, stackTrace) {
      debugPrint('Prayer midnight refresh scheduling failed: $error');
      debugPrint('$stackTrace');
    }
  }

  /// Registered from the native boot receiver when the device restarts.
  static Future<void> registerBootReschedule() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;

    try {
      await Workmanager().registerOneOffTask(
        _bootUniqueName,
        bootTask,
        existingWorkPolicy: ExistingWorkPolicy.replace,
      );
    } catch (error, stackTrace) {
      debugPrint('Prayer boot reschedule scheduling failed: $error');
      debugPrint('$stackTrace');
    }
  }
}
