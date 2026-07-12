import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'goman_app_bar_close_button.dart';

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
    final canPop = GoRouter.of(context).canPop();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: canPop ? const GomanAppBarCloseButton() : null,
        title: Text(title),
        actions: actions,
      ),
      body: body,
    );
  }
}
