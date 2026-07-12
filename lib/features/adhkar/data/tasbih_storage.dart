import 'package:shared_preferences/shared_preferences.dart';

import 'models/tasbih_state.dart';

const _dhikrKey = 'tasbih_dhikr_v1';
const _targetKey = 'tasbih_target_v1';
const _countKey = 'tasbih_count_v1';
const _hapticsKey = 'tasbih_haptics_v1';

class TasbihStorage {
  Future<TasbihState> load() async {
    final prefs = await SharedPreferences.getInstance();
    return TasbihState(
      dhikr: prefs.getString(_dhikrKey) ?? TasbihState.defaultDhikr,
      target: prefs.getInt(_targetKey) ?? TasbihState.defaultTarget,
      count: prefs.getInt(_countKey) ?? 0,
      hapticsEnabled: prefs.getBool(_hapticsKey) ?? true,
    );
  }

  Future<void> save(TasbihState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dhikrKey, state.dhikr);
    await prefs.setInt(_targetKey, state.target);
    await prefs.setInt(_countKey, state.count);
    await prefs.setBool(_hapticsKey, state.hapticsEnabled);
  }
}
