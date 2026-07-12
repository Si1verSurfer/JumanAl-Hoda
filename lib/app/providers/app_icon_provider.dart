import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_icon_plus/flutter_dynamic_icon_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/data/app_icon_storage.dart';

final appIconStorageProvider = Provider((ref) => AppIconStorage());

final appIconProvider =
    AsyncNotifierProvider<AppIconNotifier, String>(AppIconNotifier.new);

class AppIconNotifier extends AsyncNotifier<String> {
  AppIconStorage get _storage => ref.read(appIconStorageProvider);

  @override
  Future<String> build() => _storage.load();

  Future<bool> setIcon(String iconId) async {
    final option = AppIconOption.byId(iconId);
    try {
      final supported = await FlutterDynamicIconPlus.supportsAlternateIcons;
      if (!supported) {
        state = AsyncData(option.id);
        await _storage.save(option.id);
        return false;
      }

      await FlutterDynamicIconPlus.setAlternateIconName(
        iconName: option.nativeName,
        blacklistBrands: const ['Redmi'],
        blacklistManufactures: const ['Xiaomi'],
        blacklistModels: const ['Redmi 200A'],
      );

      state = AsyncData(option.id);
      await _storage.save(option.id);
      return true;
    } on PlatformException catch (error) {
      debugPrint('App icon change failed: $error');
      return false;
    } catch (error) {
      debugPrint('App icon change failed: $error');
      return false;
    }
  }
}
