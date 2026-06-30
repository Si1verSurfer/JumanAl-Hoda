import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/feature_placeholder_content.dart';

class DuasScreen extends HookConsumerWidget {
  const DuasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const FeaturePlaceholderContent(
      title: AppStrings.duas,
      subtitle: AppStrings.duasSubtitle,
      icon: Icons.favorite_rounded,
    );
  }
}
