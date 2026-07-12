abstract final class AppWebsite {
  /// Production website for legal pages and marketing.
  static const String baseUrl = 'https://jumanahjumanalhoda.com';

  static const String privacyPolicyPath = '/privacy';
  static const String termsAndConditionsPath = '/terms';

  static String _embedded(String path) => '$baseUrl$path?embed=1';

  static String get privacyPolicy => _embedded(privacyPolicyPath);
  static String get termsAndConditions => _embedded(termsAndConditionsPath);
}
