import 'package:flutter/material.dart';

import '../haptics/goman_haptics.dart';

enum GomanButtonVariant { filled, outlined }

class GomanButton extends StatelessWidget {
  const GomanButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = GomanButtonVariant.filled,
  });

  final String label;
  final VoidCallback? onPressed;
  final GomanButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      GomanButtonVariant.filled => FilledButton(
          onPressed: onPressed?.withHaptic(GomanHapticKind.confirm),
          child: Text(label),
        ),
      GomanButtonVariant.outlined => OutlinedButton(
          onPressed: onPressed?.withHaptic(GomanHapticKind.tap),
          child: Text(label),
        ),
    };
  }
}
