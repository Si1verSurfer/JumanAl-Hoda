import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/haptics/goman_haptics.dart';
import '../../../../core/navigation/goman_navigation.dart';

/// Back control for full-screen routes — returns to the previous screen.
class GomanAppBarBackButton extends StatelessWidget {
  const GomanAppBarBackButton({
    super.key,
    this.color,
    this.tooltip = 'رجوع',
  });

  final Color? color;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final iconColor = color ??
        Theme.of(context).appBarTheme.foregroundColor ??
        Theme.of(context).colorScheme.onSurface;

    return IconButton(
      tooltip: tooltip,
      onPressed: () => context.popAnimated(haptic: GomanHapticKind.tap),
      icon: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 18,
        color: iconColor,
      ),
    );
  }
}

/// App bar title styled for Arabic khutbah screens.
class GomanAppBarArabicTitle extends StatelessWidget {
  const GomanAppBarArabicTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.notoNaskhArabic(
        fontWeight: FontWeight.w700,
        color: Theme.of(context).appBarTheme.foregroundColor ??
            Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
