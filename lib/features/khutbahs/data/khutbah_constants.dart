abstract final class KhutbahConstants {
  static const indexAssetPath = 'assets/khutbahs/khutbahs_index.json';
  static const hiveBoxName = 'khutbahs_index_v1';
  static const hiveDataKey = '__index__';
  static const hiveVersionKey = '__version__';
  static const indexVersion = 2;

  static const excludedCategories = {
    'أديان ومذاهب وفرق',
    'الجهاد',
    'السياسة والشأن العام',
  };

  /// Maximum topic categories shown on the khutbahs home grid.
  static const maxCategories = 8;

  static const githubPdfBase =
      'https://raw.githubusercontent.com/rn0x/khutbahs-api/main/database/files';

  static const cacheDirName = 'khutbahs_cache';
  static const maxCachedFiles = 20;
  static const maxCacheBytes = 500 * 1024 * 1024;
  static const downloadTimeout = Duration(seconds: 60);
  static const minValidPdfBytes = 1024;
}
