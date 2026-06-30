import 'package:flutter/material.dart';

import '../../../core/constants/app_nav_icons.dart';
import '../../../core/constants/app_strings.dart';
import 'models/goman_nav_item.dart';

const List<GomanNavItem> kNavBarItems = [
  GomanNavItem(
    icon: Icons.auto_awesome_outlined,
    selectedIcon: Icons.auto_awesome_rounded,
    label: AppStrings.navAdhkar,
  ),
  GomanNavItem(
    iconAsset: AppNavIcons.quran,
    label: AppStrings.navQuran,
  ),
  GomanNavItem(
    iconAsset: AppNavIcons.duas,
    label: AppStrings.navDuas,
  ),
  GomanNavItem(
    iconAsset: AppNavIcons.prayerTimes,
    label: AppStrings.navPrayerTimes,
  ),
];
