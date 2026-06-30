import 'package:flutter/material.dart';
import 'package:qcf_quran/qcf_quran.dart';

class HeaderWidget extends StatelessWidget {
  final int suraNumber;

  /// Optional theme configuration for customizing header appearance.
  /// If null, uses default theme values.
  final QcfThemeData? theme;

  const HeaderWidget({
    super.key,
    required this.suraNumber,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final effectiveTheme = theme ?? const QcfThemeData();

    if (effectiveTheme.customHeaderBuilder != null) {
      return effectiveTheme.customHeaderBuilder!(suraNumber);
    }

    final frameWidth = isPortrait
        ? getScreenType(context) == ScreenType.large
            ? effectiveTheme.headerWidthLarge
            : effectiveTheme.headerWidthSmall
        : MediaQuery.of(context).size.width * 0.8;

    final frameHeight = frameWidth / QcfHeaderFrameImage.aspectRatio;

    return SizedBox(
      width: frameWidth,
      height: frameHeight,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          QcfHeaderFrameImage(
            width: frameWidth,
            theme: effectiveTheme,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "surah${suraNumber.toString().padLeft(3, '0')}",
              style: TextStyle(
                fontFamily: SurahFontHelper.fontFamily,
                package: 'qcf_quran',
                fontSize: isPortrait
                    ? getScreenType(context) == ScreenType.large
                        ? effectiveTheme.headerFontSizeLarge
                        : effectiveTheme.headerFontSizeSmall
                    : MediaQuery.of(context).size.width * 0.05,
                color: QcfHeaderFrameImage.surahNameColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
