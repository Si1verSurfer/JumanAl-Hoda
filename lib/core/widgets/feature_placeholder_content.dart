import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/animated_entrance.dart';
import '../../../../core/widgets/goman_button.dart';
import '../../../../core/widgets/goman_card.dart';
import '../../../../core/widgets/goman_scaffold.dart';

class FeaturePlaceholderContent extends HookConsumerWidget {
  const FeaturePlaceholderContent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GomanScaffold(
      title: title,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: AnimatedEntrance(
            child: GomanCard(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 36,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: (isDark
                                  ? AppColors.surfaceLight
                                  : AppColors.onSurfaceLight)
                              .withValues(alpha: 0.7),
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.comingSoon,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.secondary,
                        ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GomanButton(
                        label: AppStrings.explore,
                        onPressed: () {},
                      ),
                      const SizedBox(width: 12),
                      GomanButton(
                        label: AppStrings.learnMore,
                        variant: GomanButtonVariant.outlined,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
