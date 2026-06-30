import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/haptics/goman_haptics.dart';
import '../../../core/utils/platform_utils.dart';
import '../../../core/widgets/goman_ambient_background.dart';
import 'providers/nav_index_provider.dart';
import 'widgets/android_material_nav.dart';
import 'widgets/ios_liquid_glass_nav.dart';

class ShellScreen extends ConsumerWidget {
  const ShellScreen({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  void _onTabTap(int index, WidgetRef ref) {
    if (index != navigationShell.currentIndex) {
      GomanHaptics.confirm();
    }
    ref.read(navIndexProvider.notifier).state = index;
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = navigationShell.currentIndex;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!PlatformUtils.isIOS) {
      return Scaffold(
        extendBody: true,
        body: navigationShell,
        bottomNavigationBar: AndroidMaterialNav(
          currentIndex: currentIndex,
          onTap: (index) => _onTabTap(index, ref),
          isDark: isDark,
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          GomanAmbientBackground(isDark: isDark),
          navigationShell,
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IosLiquidGlassNav(
              currentIndex: currentIndex,
              onTap: (index) => _onTabTap(index, ref),
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }
}
