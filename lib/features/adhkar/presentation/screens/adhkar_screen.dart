import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/constants/app_nav_constants.dart';
import '../../../../core/navigation/goman_navigation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/platform_utils.dart';
import '../../../../core/widgets/animated_entrance.dart';
import '../../../../app/router/worship_category_route.dart';
import '../providers/worship_provider.dart';
import '../theme/worship_page_style.dart';
import '../widgets/tasbih_home_button.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/worship_category_chip.dart';
import '../../../qiblah/presentation/widgets/qiblah_home_button.dart';

class AdhkarScreen extends ConsumerWidget {
  const AdhkarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = PlatformUtils.isIOS
        ? AppNavConstants.floatingBottomPadding(context)
        : 24.0;
    final appBarHeight = HomeAppBar.totalHeight(context);

    return Container(
      color: WorshipPageStyle.background(isDark),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: appBarHeight)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AnimatedEntrance(
                        child: QiblahHomeButton(
                          isDark: isDark,
                          onTap: () => context.pushAnimated(
                            Routes.qiblah,
                            haptic: null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      AnimatedEntrance(
                        delay: const Duration(milliseconds: 30),
                        child: TasbihHomeButton(
                          isDark: isDark,
                          onTap: () => context.pushAnimated(
                            Routes.tasbih,
                            haptic: null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      AnimatedEntrance(
                        delay: const Duration(milliseconds: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'أبواب العبادة',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.tajawal(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.surfaceLight
                                        .withValues(alpha: 0.78)
                                    : AppColors.secondary
                                        .withValues(alpha: 0.75),
                              ),
                            ),
                            const SizedBox(height: 10),
                            WorshipGuidesGrid(
                              categories:
                                  ref.watch(worshipGuideCategoriesProvider),
                              isDark: isDark,
                              onCategoryTap: (category) {
                                context.pushAnimated(
                                  worshipRouteFor(category.id),
                                  haptic: null,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      AnimatedEntrance(
                        delay: const Duration(milliseconds: 60),
                        child: WorshipCategoryGrid(
                          categories:
                              ref.watch(worshipMainCategoriesProvider),
                          isDark: isDark,
                          onCategoryTap: (category) {
                            context.pushAnimated(
                              worshipRouteFor(category.id),
                              haptic: null,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: bottomPadding),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: HomeAppBar(
              isDark: isDark,
              onSettingsTap: () => context.pushAnimated(
                Routes.settings,
                haptic: null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
