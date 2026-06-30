import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/providers/prayer_schedule_sync_provider.dart';

class PrayerScheduleLifecycleListener extends ConsumerStatefulWidget {
  const PrayerScheduleLifecycleListener({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  ConsumerState<PrayerScheduleLifecycleListener> createState() =>
      _PrayerScheduleLifecycleListenerState();
}

class _PrayerScheduleLifecycleListenerState
    extends ConsumerState<PrayerScheduleLifecycleListener>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(prayerScheduleSyncProvider.notifier).syncIfStale();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(prayerScheduleSyncProvider.notifier).syncIfStale();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
