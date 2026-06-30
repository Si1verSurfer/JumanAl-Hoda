import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

import '../data/constants/prayer_arabic_labels.dart';
import '../data/models/cached_prayer_day.dart';
import '../data/models/daily_prayer_schedule.dart';
import '../data/models/prayer_notification_settings.dart';
import 'prayer_notification_ids.dart';
import 'prayer_notification_scheduler.dart';
import 'prayer_timezone.dart';

class PrayerNotificationPermissionStatus {
  const PrayerNotificationPermissionStatus({
    required this.notificationsGranted,
    required this.exactAlarmsGranted,
  });

  final bool notificationsGranted;
  final bool exactAlarmsGranted;

  bool get canSchedule => notificationsGranted;

  bool get needsExactAlarmSettings =>
      defaultTargetPlatform == TargetPlatform.android && !exactAlarmsGranted;
}

abstract final class PrayerNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _androidChannel = AndroidNotificationChannel(
    'prayer_adhan',
    'مواقيت الصلاة',
    description: 'تنبيهات مواقيت الصلاة',
    importance: Importance.high,
  );

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);
    await PrayerTimezone.configure();
  }

  static Future<PrayerNotificationPermissionStatus> permissionStatus() async {
    final notificationStatus = await Permission.notification.status;
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    var notificationsGranted = notificationStatus.isGranted;
    if (defaultTargetPlatform == TargetPlatform.android) {
      notificationsGranted = notificationsGranted ||
          (await androidPlugin?.areNotificationsEnabled() ?? false);
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final iosSettings = await iosPlugin?.checkPermissions();
      notificationsGranted = iosSettings?.isEnabled ?? notificationsGranted;
    }

    var exactAlarmsGranted = true;
    if (defaultTargetPlatform == TargetPlatform.android) {
      exactAlarmsGranted =
          await androidPlugin?.canScheduleExactNotifications() ?? true;
    }

    return PrayerNotificationPermissionStatus(
      notificationsGranted: notificationsGranted,
      exactAlarmsGranted: exactAlarmsGranted,
    );
  }

  static Future<bool> hasPermissions() async {
    final status = await permissionStatus();
    return status.canSchedule;
  }

  static Future<bool> requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.notification.request();
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.requestNotificationsPermission();
      await requestExactAlarmPermissionIfNeeded();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else {
      await Permission.notification.request();
    }
    return hasPermissions();
  }

  static Future<void> requestExactAlarmPermissionIfNeeded() async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return;
    final canExact = await androidPlugin.canScheduleExactNotifications();
    if (canExact == true) return;
    await androidPlugin.requestExactAlarmsPermission();
  }

  static Future<void> openExactAlarmSettings() async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    await openAppSettings();
  }

  static Future<int> pendingNotificationCount() async {
    final pending = await _plugin.pendingNotificationRequests();
    return pending.length;
  }

  static Future<bool> shouldRefreshPendingNotifications(
    PrayerNotificationSettings settings,
  ) async {
    if (!settings.masterEnabled) return false;
    if (!await hasPermissions()) return false;
    final pending = await pendingNotificationCount();
    return PrayerNotificationScheduler.shouldRefreshPending(
      pendingCount: pending,
      settings: settings,
    );
  }

  static Future<void> cancelAllPrayerNotifications() async {
    for (final id in PrayerNotificationIds.allIds()) {
      await _plugin.cancel(id);
    }
    final pending = await _plugin.pendingNotificationRequests();
    for (final request in pending) {
      if (request.id <= PrayerNotificationIds.maxId) {
        await _plugin.cancel(request.id);
      }
    }
  }

  static Future<int> schedulePrayerNotifications({
    required List<CachedPrayerDay> days,
    required PrayerNotificationSettings settings,
    required String locationLabel,
  }) async {
    await cancelAllPrayerNotifications();
    if (!settings.masterEnabled) return 0;

    final permissions = await permissionStatus();
    if (!permissions.notificationsGranted) {
      debugPrint('Prayer notifications skipped: permission not granted.');
      return 0;
    }

    final scheduleMode = await _androidScheduleMode(permissions);
    final maxCount = PrayerNotificationScheduler.maxSchedulableNotifications(
      settings: settings,
    );
    final now = DateTime.now();
    var scheduled = 0;

    for (var dayIndex = 0; dayIndex < days.length; dayIndex++) {
      final day = days[dayIndex];
      for (final kind in PrayerTimeKind.values) {
        if (scheduled >= maxCount) return scheduled;
        final key = kind.name;
        if (!settings.isEnabledFor(key)) continue;
        final time = day.timeFor(kind);
        if (time == null || !time.isAfter(now)) continue;

        final displayName = PrayerArabicLabels.prayerDisplayName(kind);
        final id = PrayerNotificationIds.forDayAndKind(dayIndex, kind);
        final scheduledTime = tz.TZDateTime.from(time, PrayerTimezone.local);

        try {
          await _plugin.zonedSchedule(
            id,
            'حان وقت $displayName',
            'موعد $displayName · $locationLabel',
            scheduledTime,
            NotificationDetails(
              android: AndroidNotificationDetails(
                _androidChannel.id,
                _androidChannel.name,
                channelDescription: _androidChannel.description,
                importance: Importance.high,
                priority: Priority.high,
              ),
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
            androidScheduleMode: scheduleMode,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );
          scheduled++;
        } catch (error, stackTrace) {
          debugPrint(
            'Prayer notification schedule failed (id=$id): $error',
          );
          debugPrint('$stackTrace');
        }
      }
    }

    if (scheduled == 0 && permissions.notificationsGranted) {
      debugPrint('Prayer notifications: nothing future to schedule.');
    }
  return scheduled;
  }

  static Future<AndroidScheduleMode> _androidScheduleMode(
    PrayerNotificationPermissionStatus permissions,
  ) async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return AndroidScheduleMode.exactAllowWhileIdle;
    }
    if (permissions.exactAlarmsGranted) {
      return AndroidScheduleMode.exactAllowWhileIdle;
    }
    return AndroidScheduleMode.inexactAllowWhileIdle;
  }
}
