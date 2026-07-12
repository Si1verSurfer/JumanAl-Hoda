import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/general_icon_assets.dart';
import '../../../../core/widgets/goman_scaffold.dart';
import '../../../../core/widgets/goman_svg_icon.dart';
import '../providers/tasbih_provider.dart';
import '../theme/worship_page_style.dart';
import '../widgets/electronic_tasbih_panel.dart';

class TasbihScreen extends ConsumerWidget {
  const TasbihScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tasbih = ref.watch(tasbihProvider).valueOrNull;

    return GomanScaffold(
      title: AppStrings.electronicTasbih,
      actions: tasbih == null
          ? null
          : [
              IconButton(
                tooltip: AppStrings.tasbihCustomize,
                onPressed: () => showTasbihCustomizeSheet(
                  context: context,
                  ref: ref,
                  isDark: isDark,
                  initial: tasbih,
                ),
                icon: GomanSvgIcon(
                  asset: GeneralIconAssets.settings,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 22,
                ),
              ),
            ],
      body: ColoredBox(
        color: WorshipPageStyle.background(isDark),
        child: ElectronicTasbihPanel(isDark: isDark),
      ),
    );
  }
}
