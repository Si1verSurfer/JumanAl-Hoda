import 'package:flutter/material.dart';

import 'qcf_theme_data.dart';

/// The ornate surah title frame from [assets/mainframe.png], tinted per theme.
class QcfHeaderFrameImage extends StatelessWidget {
  const QcfHeaderFrameImage({
    super.key,
    required this.width,
    required this.theme,
  });

  static const _asset = AssetImage(
    'assets/mainframe.png',
    package: 'qcf_quran',
  );

  /// Width:height of [mainframe.png] (2000×208 px).
  static const aspectRatio = 2000 / 208;

  /// Soft off-white for surah titles inside the ornate frame.
  static const surahNameColor = Color(0xFFE0DCD6);

  final double width;
  final QcfThemeData theme;

  @override
  Widget build(BuildContext context) {
    final frameColor = theme.headerFrameColor;
    final height = width / aspectRatio;

    return SizedBox(
      width: width,
      height: height,
      child: Image(
        image: _asset,
        width: width,
        height: height,
        fit: BoxFit.contain,
        color: frameColor,
        colorBlendMode:
            frameColor != null ? theme.headerFrameBlendMode : null,
      ),
    );
  }
}
