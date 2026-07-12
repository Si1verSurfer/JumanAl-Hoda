import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/worship_category_route.dart';

/// Handles navigation when the user taps a local notification.
abstract final class PrayerNotificationNavigation {
  static GlobalKey<NavigatorState>? _navigatorKey;

  static void bind(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  static void handlePayload(String? payload) {
    if (payload == null || payload.isEmpty) return;

    final context = _navigatorKey?.currentContext;
    if (context == null || !context.mounted) return;

    final route = switch (payload) {
      'morning' => worshipRouteFor('morning'),
      'evening' => worshipRouteFor('evening'),
      _ => null,
    };
    if (route == null) return;
    context.go(route);
  }
}
