import 'package:flutter/material.dart';

import '../../../../core/constants/app_nav_constants.dart';
import '../nav_bar_items.dart';
import 'goman_floating_nav_bar.dart';

class IosLiquidGlassNav extends StatelessWidget {
  const IosLiquidGlassNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.isDark,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppNavConstants.horizontalMargin,
          0,
          AppNavConstants.horizontalMargin,
          AppNavConstants.bottomMargin,
        ),
        child: GomanFloatingNavBar(
          items: kNavBarItems,
          currentIndex: currentIndex,
          onTap: onTap,
          isDark: isDark,
          frosted: true,
        ),
      ),
    );
  }
}
