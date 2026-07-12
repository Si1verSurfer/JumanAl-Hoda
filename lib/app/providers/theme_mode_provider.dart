import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/data/theme_mode_storage.dart';

final themeModeStorageProvider = Provider((ref) => ThemeModeStorage());

final themeModeProvider =
    AsyncNotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class ThemeModeNotifier extends AsyncNotifier<ThemeMode> {
  ThemeModeStorage get _storage => ref.read(themeModeStorageProvider);

  @override
  Future<ThemeMode> build() => _storage.load();

  Future<void> setThemeMode(ThemeMode mode) async {
    state = AsyncData(mode);
    await _storage.save(mode);
  }
}
