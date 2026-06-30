import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';

enum AyahCardGallerySaveResult {
  saved,
  shared,
  denied,
  unavailable,
}

abstract final class QuranAyahCardGalleryService {
  static bool get isSupported =>
      !kIsWeb && (Platform.isIOS || Platform.isAndroid);

  static Future<AyahCardGallerySaveResult> saveToGallery(
    String imagePath,
  ) async {
    final file = File(imagePath);
    if (!await file.exists()) return AyahCardGallerySaveResult.unavailable;

    if (!isSupported) {
      return AyahCardGallerySaveResult.unavailable;
    }

    try {
      final hasAccess = await Gal.hasAccess(toAlbum: true);
      if (!hasAccess) {
        await Gal.requestAccess(toAlbum: true);
      }

      if (!await Gal.hasAccess(toAlbum: true)) {
        return AyahCardGallerySaveResult.denied;
      }

      await Gal.putImage(imagePath, album: 'بطاقات القرآن');
      return AyahCardGallerySaveResult.saved;
    } on MissingPluginException {
      return _shareFallback(imagePath);
    } on PlatformException {
      return _shareFallback(imagePath);
    }
  }

  static Future<AyahCardGallerySaveResult> _shareFallback(
    String imagePath,
  ) async {
    try {
      await Share.shareXFiles(
        [XFile(imagePath)],
        subject: 'بطاقة قرآنية',
      );
      return AyahCardGallerySaveResult.shared;
    } on MissingPluginException {
      return AyahCardGallerySaveResult.unavailable;
    } on PlatformException {
      return AyahCardGallerySaveResult.unavailable;
    }
  }
}
