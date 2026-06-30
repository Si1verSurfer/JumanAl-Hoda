import 'package:flutter/material.dart';

import '../constants/app_nav_constants.dart';
import '../utils/platform_utils.dart';

class GomanScaffold extends StatelessWidget {
  const GomanScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = PlatformUtils.isIOS
        ? AppNavConstants.floatingBottomPadding(context)
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: body,
      ),
    );
  }
}
