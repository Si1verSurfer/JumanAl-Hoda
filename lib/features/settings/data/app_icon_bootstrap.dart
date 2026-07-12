import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_icon_plus/flutter_dynamic_icon_plus.dart';

import 'app_icon_storage.dart';

/// Ensures the default launcher icon is active (alternate icon UI was removed).
abstract final class AppIconBootstrap {
  static bool _started = false;

  /// Runs after the first frame so iOS is ready to accept icon changes.
  static void scheduleEnsureDefaultIcon() {
    if (_started) return;
    _started = true;
    Future<void>.delayed(const Duration(milliseconds: 900), ensureDefaultIcon);
  }

  static Future<void> ensureDefaultIcon() async {
    try {
      final supported = await FlutterDynamicIconPlus.supportsAlternateIcons;
      if (!supported) {
        await AppIconStorage().save(AppIconOption.classic.id);
        return;
      }

      final currentName = await FlutterDynamicIconPlus.alternateIconName;
      if (currentName == null) {
        await AppIconStorage().save(AppIconOption.classic.id);
        return;
      }

      await _resetToDefaultIcon();
      await AppIconStorage().save(AppIconOption.classic.id);
    } on PlatformException catch (error) {
      debugPrint('App icon reset failed: $error');
    } catch (error) {
      debugPrint('App icon reset failed: $error');
    }
  }

  static Future<void> _resetToDefaultIcon() async {
    const resetArgs = (
      iconName: null as String?,
      blacklistBrands: ['Redmi'],
      blacklistManufactures: ['Xiaomi'],
      blacklistModels: ['Redmi 200A'],
    );

    try {
      await FlutterDynamicIconPlus.setAlternateIconName(
        iconName: resetArgs.iconName,
        blacklistBrands: resetArgs.blacklistBrands,
        blacklistManufactures: resetArgs.blacklistManufactures,
        blacklistModels: resetArgs.blacklistModels,
      );
    } on PlatformException {
      // iOS may reject rapid icon changes at launch — retry once after a pause.
      await Future<void>.delayed(const Duration(seconds: 2));
      await FlutterDynamicIconPlus.setAlternateIconName(
        iconName: resetArgs.iconName,
        blacklistBrands: resetArgs.blacklistBrands,
        blacklistManufactures: resetArgs.blacklistManufactures,
        blacklistModels: resetArgs.blacklistModels,
      );
    }
  }
}
