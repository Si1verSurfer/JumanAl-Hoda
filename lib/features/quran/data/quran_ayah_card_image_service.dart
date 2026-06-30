import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import 'models/ayah_card.dart';
import '../presentation/widgets/quran_ayah_card_preview.dart';

abstract final class QuranAyahCardImageService {
  static const captureWidth = 300.0;

  static Future<String?> captureAndSave({
    required BuildContext context,
    required SavedAyahCard card,
  }) async {
    final overlay = Overlay.of(context, rootOverlay: true);
    final boundaryKey = GlobalKey();
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) {
        return Positioned(
          left: -4000,
          top: 0,
          child: RepaintBoundary(
            key: boundaryKey,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                size: const Size(captureWidth, 1600),
                textScaler: TextScaler.noScaling,
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Material(
                  color: Colors.transparent,
                  child: QuranAyahCardPreview(
                    surahNumber: card.surahNumber,
                    verseNumbers: card.verseNumbers,
                    width: captureWidth,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(entry);

    try {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      await WidgetsBinding.instance.endOfFrame;
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final boundary = boundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      final dir = await getApplicationDocumentsDirectory();
      final cardsDir = Directory('${dir.path}/ayah_cards');
      if (!await cardsDir.exists()) {
        await cardsDir.create(recursive: true);
      }

      final file = File('${cardsDir.path}/ayah_card_${card.id}_v3.png');
      await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);
      return file.path;
    } finally {
      entry.remove();
    }
  }

  static Future<void> deleteIfExists(String? path) async {
    if (path == null) return;
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
