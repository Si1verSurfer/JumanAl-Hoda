import 'package:flutter/services.dart';

/// Central haptic feedback for the app.
abstract final class GomanHaptics {
  static const _doubleGap = Duration(milliseconds: 48);

  /// Light tap — toggles, chips, secondary actions.
  static Future<void> tap() => HapticFeedback.selectionClick();

  /// Two quick pulses — navigation, opening pages, primary cards.
  static Future<void> confirm() async {
    await HapticFeedback.lightImpact();
    await Future<void>.delayed(_doubleGap);
    await HapticFeedback.lightImpact();
  }

  /// Stronger double pulse — closing a screen or completing an action.
  static Future<void> success() async {
    await HapticFeedback.mediumImpact();
    await Future<void>.delayed(_doubleGap);
    await HapticFeedback.lightImpact();
  }

  static void fire(GomanHapticKind kind) {
    switch (kind) {
      case GomanHapticKind.tap:
        tap();
      case GomanHapticKind.confirm:
        confirm();
      case GomanHapticKind.success:
        success();
    }
  }
}

enum GomanHapticKind {
  tap,
  confirm,
  success;

  void fire() => GomanHaptics.fire(this);
}

extension GomanHapticVoidCallback on VoidCallback {
  VoidCallback withHaptic([GomanHapticKind kind = GomanHapticKind.confirm]) {
    return () {
      kind.fire();
      this();
    };
  }
}

extension GomanHapticNullableVoidCallback on VoidCallback? {
  VoidCallback? withHaptic([GomanHapticKind kind = GomanHapticKind.confirm]) {
    final callback = this;
    if (callback == null) return null;
    return callback.withHaptic(kind);
  }
}
