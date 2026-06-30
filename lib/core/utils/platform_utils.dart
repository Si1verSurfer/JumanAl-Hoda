import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

abstract final class PlatformUtils {
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
}
