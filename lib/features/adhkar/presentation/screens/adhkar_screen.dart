import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/feature_placeholder_content.dart';

class AdhkarScreen extends HookConsumerWidget {
  const AdhkarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const FeaturePlaceholderContent(
      title: AppStrings.adhkar,
      subtitle: AppStrings.adhkarSubtitle,
      icon: Icons.auto_awesome_rounded,
    );
  }
}
