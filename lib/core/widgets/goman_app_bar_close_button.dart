import 'package:flutter/material.dart';
import '../haptics/goman_haptics.dart';
import '../navigation/goman_navigation.dart';

/// Close control for app bars — replaces the default back arrow.
class GomanAppBarCloseButton extends StatelessWidget {
  const GomanAppBarCloseButton({
    super.key,
    this.color,
    this.tooltip = 'إغلاق',
  });

  final Color? color;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: () => context.popAnimated(haptic: GomanHapticKind.success),
      icon: Icon(
        Icons.close_rounded,
        color: color ??
            Theme.of(context).appBarTheme.foregroundColor ??
            Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
