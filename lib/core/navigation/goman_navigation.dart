import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../haptics/goman_haptics.dart';

extension GomanNavigation on BuildContext {
  void pushAnimated(
    String location, {
    Object? extra,
    GomanHapticKind? haptic = GomanHapticKind.confirm,
  }) {
    haptic?.fire();
    push(location, extra: extra);
  }

  void popAnimated({GomanHapticKind? haptic = GomanHapticKind.tap}) {
    haptic?.fire();
    pop();
  }
}

Future<T?> showGomanModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = false,
  bool useSafeArea = false,
  Color? backgroundColor,
  GomanHapticKind openHaptic = GomanHapticKind.confirm,
}) {
  openHaptic.fire();
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: useSafeArea,
    backgroundColor: backgroundColor ?? Colors.transparent,
    builder: builder,
  );
}
