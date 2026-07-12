abstract final class AppBrandAssets {
  static const _appLogoBase = 'assets/appLogo/ios';

  /// Centered logo on the animated splash screen.
  static const splashLogo = '$_appLogoBase/AppIcon@3x.png';

  /// Home app bar — light mode.
  static const homeLogoLight = 'assets/icons/IMG_2887.jpg';

  /// Home app bar — dark mode (official app icon).
  static const homeLogoDark = '$_appLogoBase/AppIcon@3x.png';

  static String homeLogoFor({required bool isDark}) =>
      isDark ? homeLogoDark : homeLogoLight;
}
