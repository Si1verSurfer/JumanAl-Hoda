import '../../../core/constants/app_nav_icons.dart';
import '../../../core/constants/app_strings.dart';
import 'models/goman_nav_item.dart';

const List<GomanNavItem> kNavBarItems = [
  GomanNavItem(
    iconAsset: AppNavIcons.home,
    label: AppStrings.navHome,
  ),
  GomanNavItem(
    iconAsset: AppNavIcons.quran,
    label: AppStrings.navQuran,
  ),
  GomanNavItem(
    iconAsset: AppNavIcons.khutbahs,
    label: AppStrings.navKhutbahs,
  ),
  GomanNavItem(
    iconAsset: AppNavIcons.prayerTimes,
    label: AppStrings.navPrayerTimes,
  ),
];
