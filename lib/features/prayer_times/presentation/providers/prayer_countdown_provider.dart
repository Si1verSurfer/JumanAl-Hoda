import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'prayer_location_provider.dart';
import 'prayer_times_provider.dart';

class PrayerCountdownState {
  const PrayerCountdownState({
    required this.remaining,
    required this.label,
  });

  final Duration remaining;
  final String label;

  static const empty = PrayerCountdownState(
    remaining: Duration.zero,
    label: '٠٠:٠٠:٠٠',
  );
}

/// Emits the current time once per second for live countdown updates.
final prayerSecondTickerProvider = StreamProvider<DateTime>((ref) {
  ref.keepAlive();

  final controller = StreamController<DateTime>();
  controller.add(DateTime.now());

  final timer = Timer.periodic(const Duration(seconds: 1), (_) {
    if (!controller.isClosed) {
      controller.add(DateTime.now());
    }
  });

  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  return controller.stream;
});

/// Rolls the schedule forward when the current next-prayer time has passed.
final prayerScheduleAutoRefreshProvider = Provider<void>((ref) {
  ref.watch(prayerSecondTickerProvider);

  final schedule = ref.read(prayerScheduleProvider);
  if (schedule == null) return;

  final locationState = ref.read(prayerLocationProvider);
  if (locationState is! PrayerLocationReady) return;

  final repository = ref.read(prayerTimesRepositoryProvider);
  final now = repository.cityNow(locationState.location);
  if (!schedule.nextSalahTime.isAfter(now)) {
    ref.invalidate(prayerScheduleProvider);
  }
});

final prayerCountdownProvider = Provider<PrayerCountdownState>((ref) {
  ref.watch(prayerScheduleAutoRefreshProvider);
  ref.watch(prayerSecondTickerProvider);

  final schedule = ref.watch(prayerScheduleProvider);
  if (schedule == null) {
    return PrayerCountdownState.empty;
  }

  final locationState = ref.watch(prayerLocationProvider);
  if (locationState is! PrayerLocationReady) {
    return PrayerCountdownState.empty;
  }

  final repository = ref.read(prayerTimesRepositoryProvider);
  final now = repository.cityNow(locationState.location);
  final remaining = schedule.nextSalahTime.difference(now);
  final clamped =
      remaining.isNegative ? Duration.zero : remaining;

  return PrayerCountdownState(
    remaining: clamped,
    label: repository.formatCountdown(clamped),
  );
});
