import 'package:shared_preferences/shared_preferences.dart';

const _appIconKey = 'app_launcher_icon_v1';

/// Stored launcher icon id. `classic` = default, `gold` = alternate.
class AppIconStorage {
  Future<String> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_appIconKey) ?? AppIconOption.classic.id;
  }

  Future<void> save(String iconId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_appIconKey, iconId);
  }
}

class AppIconOption {
  const AppIconOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.previewAsset,
    this.nativeName,
  });

  final String id;
  final String title;
  final String subtitle;
  final String previewAsset;

  /// Platform alternate icon name (`null` = primary/default).
  final String? nativeName;

  static const classic = AppIconOption(
    id: 'classic',
    title: 'الأيقونة الكلاسيكية',
    subtitle: 'أيقونة التطبيق الرسمية',
    previewAsset: 'assets/appLogo/ios/AppIcon@3x.png',
    nativeName: null,
  );

  static const gold = AppIconOption(
    id: 'gold',
    title: 'الأيقونة الذهبية',
    subtitle: 'شعار جُمانُ الهُدَى الفاتح',
    previewAsset: 'assets/icons/IMG_2887.jpg',
    nativeName: 'icon_gold',
  );

  static const options = [classic, gold];

  static AppIconOption byId(String id) {
    return options.firstWhere(
      (option) => option.id == id,
      orElse: () => classic,
    );
  }
}
