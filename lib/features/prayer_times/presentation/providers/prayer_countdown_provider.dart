import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final prayerCountdownProvider =
    StateNotifierProvider<PrayerCountdownNotifier, PrayerCountdownState>(
  (ref) => PrayerCountdownNotifier(ref),
);

class PrayerCountdownNotifier extends StateNotifier<PrayerCountdownState> {
  PrayerCountdownNotifier(this._ref) : super(PrayerCountdownState.empty) {
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  final Ref _ref;
  Timer? _timer;

  void _tick() {
    final schedule = _ref.read(prayerScheduleProvider);
    if (schedule == null) {
      state = PrayerCountdownState.empty;
      return;
    }

    final repository = _ref.read(prayerTimesRepositoryProvider);
    final remaining = schedule.nextSalahTime.difference(DateTime.now());
    state = PrayerCountdownState(
      remaining: remaining.isNegative ? Duration.zero : remaining,
      label: repository.formatCountdown(
        remaining.isNegative ? Duration.zero : remaining,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
