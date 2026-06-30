import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/feature_placeholder_content.dart';

class PrayerTimesScreen extends HookConsumerWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const FeaturePlaceholderContent(
      title: AppStrings.prayerTimes,
      subtitle: AppStrings.prayerTimesSubtitle,
      icon: Icons.access_time_rounded,
    );
  }
}
