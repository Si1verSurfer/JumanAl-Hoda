import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/tasbih_state.dart';
import '../../data/tasbih_storage.dart';

final tasbihStorageProvider = Provider((ref) => TasbihStorage());

final tasbihProvider =
    AsyncNotifierProvider<TasbihNotifier, TasbihState>(TasbihNotifier.new);

class TasbihNotifier extends AsyncNotifier<TasbihState> {
  TasbihStorage get _storage => ref.read(tasbihStorageProvider);

  @override
  Future<TasbihState> build() => _storage.load();

  Future<void> _persist(TasbihState next) async {
    state = AsyncData(next);
    await _storage.save(next);
  }

  Future<void> increment() async {
    final current = state.valueOrNull ?? TasbihState.defaults;
    await _persist(current.copyWith(count: current.count + 1));
  }

  Future<void> resetCount() async {
    final current = state.valueOrNull ?? TasbihState.defaults;
    await _persist(current.copyWith(count: 0));
  }

  Future<void> toggleHaptics() async {
    final current = state.valueOrNull ?? TasbihState.defaults;
    await _persist(
      current.copyWith(hapticsEnabled: !current.hapticsEnabled),
    );
  }

  Future<void> updateSettings({required String dhikr, required int target}) async {
    final trimmed = dhikr.trim();
    if (trimmed.isEmpty || target < 1) return;

    final current = state.valueOrNull ?? TasbihState.defaults;
    await _persist(
      current.copyWith(
        dhikr: trimmed,
        target: target,
        count: 0,
      ),
    );
  }

  Future<void> applyPreset(TasbihPreset preset) async {
    await updateSettings(dhikr: preset.dhikr, target: preset.target);
  }
}
