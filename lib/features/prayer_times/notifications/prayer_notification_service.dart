import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

import '../data/constants/prayer_arabic_labels.dart';
import '../data/models/cached_prayer_day.dart';
import '../data/models/daily_prayer_schedule.dart';
import '../data/models/prayer_notification_settings.dart';
import 'prayer_notification_ids.dart';
import 'prayer_notification_navigation.dart';
import 'prayer_notification_scheduler.dart';
import 'prayer_reminder_scheduler.dart';
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

@pragma('vm:entry-point')
void prayerNotificationTapBackground(NotificationResponse response) {
  PrayerNotificationNavigation.handlePayload(response.payload);
}

abstract final class PrayerNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _prayerChannelId = 'prayer_azan_channel';
  static const _prayerChannelName = 'أوقات الصلاة والأذان';
  static const _remindersChannelId = 'reminders_channel';
  static const _remindersChannelName = 'تذكيرات الأذكار والقراءة';

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: false,
      requestSoundPermission: true,
    );
    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: prayerNotificationTapBackground,
    );
    if (defaultTargetPlatform == TargetPlatform.android) {
      await _createAndroidChannels('azano');
    }
    await PrayerTimezone.configure();
  }

  static void _onNotificationTapped(NotificationResponse response) {
    PrayerNotificationNavigation.handlePayload(response.payload);
  }

  static Future<void> _createAndroidChannels(String azanSound) async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;

    final prayerChannel = AndroidNotificationChannel(
      _prayerChannelId,
      _prayerChannelName,
      description: 'إشعارات مواقيت الصلاة والأذان',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(azanSound),
      enableVibration: true,
      enableLights: true,
    );
    await android.createNotificationChannel(prayerChannel);

    const remindersChannel = AndroidNotificationChannel(
      _remindersChannelId,
      _remindersChannelName,
      description: 'أذكار الصباح والمساء وسورة الكهف',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      enableLights: true,
    );
    await android.createNotificationChannel(remindersChannel);
  }

  static Future<void> _ensurePrayerChannel(String azanSound) async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;

    await android.deleteNotificationChannel(_prayerChannelId);
    await _createAndroidChannels(azanSound);
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
        badge: false,
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
    for (final id in PrayerNotificationIds.reminderIds) {
      await _plugin.cancel(id);
    }
    final pending = await _plugin.pendingNotificationRequests();
    for (final request in pending) {
      if (request.id <= PrayerNotificationIds.maxId ||
          PrayerNotificationIds.reminderIds.contains(request.id)) {
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

    final azanSound = settings.resolvedAzanSound;
    if (defaultTargetPlatform == TargetPlatform.android) {
      await _ensurePrayerChannel(azanSound);
    }

    final scheduleMode = await _androidScheduleMode(permissions);
    final maxCount = PrayerNotificationScheduler.maxPrayerNotifications(
      settings: settings,
    );
    final now = DateTime.now();
    var scheduled = 0;

    for (var dayIndex = 0; dayIndex < days.length; dayIndex++) {
      final day = days[dayIndex];
      for (final kind in PrayerTimeKind.values) {
        if (scheduled >= maxCount) break;
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
            displayName,
            'حان وقت $displayName · $locationLabel',
            scheduledTime,
            NotificationDetails(
              android: AndroidNotificationDetails(
                _prayerChannelId,
                _prayerChannelName,
                channelDescription: 'إشعارات الأذان',
                importance: Importance.max,
                priority: Priority.high,
                playSound: true,
                sound: RawResourceAndroidNotificationSound(azanSound),
                enableVibration: true,
                enableLights: true,
                icon: '@mipmap/ic_launcher',
              ),
              iOS: DarwinNotificationDetails(
                sound: '$azanSound.caf',
                presentAlert: true,
                presentBadge: false,
                presentSound: true,
                interruptionLevel: InterruptionLevel.timeSensitive,
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

    await _scheduleReminders(
      days: days,
      settings: settings,
      now: now,
    );

    if (scheduled == 0 && permissions.notificationsGranted) {
      debugPrint('Prayer notifications: nothing future to schedule.');
    }
    return scheduled;
  }

  static Future<void> _scheduleReminders({
    required List<CachedPrayerDay> days,
    required PrayerNotificationSettings settings,
    required DateTime now,
  }) async {
    if (days.isEmpty) return;

    final today = days.first;
    final tomorrow = days.length > 1 ? days[1] : null;
    CachedPrayerDay? fridayDay;
    for (final day in days) {
      final parsed = DateTime.tryParse('${day.dayKey}T12:00:00');
      if (parsed != null && parsed.weekday == DateTime.friday) {
        fridayDay = day;
        break;
      }
    }

    if (settings.azkarEvening) {
      final evening = PrayerReminderScheduler.nextEveningAzkarTime(
        today: today,
        tomorrow: tomorrow,
        now: now,
      );
      if (evening != null) {
        await _scheduleReminder(
          id: PrayerNotificationIds.azkarEvening,
          title: 'أذكار المساء',
          body: 'اختم نهارك بذكر الله',
          scheduledDate: evening,
          payload: PrayerReminderPayloads.evening,
        );
      }
    }

    if (settings.azkarMorning) {
      final morning = PrayerReminderScheduler.nextMorningAzkarTime(
        today: today,
        tomorrow: tomorrow,
        now: now,
      );
      if (morning != null) {
        await _scheduleReminder(
          id: PrayerNotificationIds.azkarMorning,
          title: 'أذكار الصباح',
          body: 'إبدأ يومك بذكر الله',
          scheduledDate: morning,
          payload: PrayerReminderPayloads.morning,
        );
      }
    }

    if (settings.kahfFriday) {
      final fridayTime = PrayerReminderScheduler.nextFridayDhuhr(
        now: now,
        fridayDay: fridayDay,
      );
      if (fridayTime != null) {
        await _scheduleReminder(
          id: PrayerNotificationIds.kahfFriday,
          title: 'قراءة سورة الكهف',
          body: 'تذكير بقراءة سورة الكهف يوم الجمعة',
          scheduledDate: fridayTime,
        );
      }
    }
  }

  static Future<void> _scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, PrayerTimezone.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            _remindersChannelId,
            _remindersChannelName,
            channelDescription: 'أذكار الصباح والمساء وسورة الكهف',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            enableLights: true,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: false,
            presentSound: true,
            interruptionLevel: InterruptionLevel.timeSensitive,
          ),
        ),
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (error) {
      debugPrint('Reminder schedule failed ($title): $error');
    }
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
