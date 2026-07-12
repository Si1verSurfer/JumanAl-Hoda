import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_nav_constants.dart';
import '../../features/shell/presentation/models/goman_nav_item.dart';

class GomanNavIcon extends StatelessWidget {
  const GomanNavIcon({
    super.key,
    required this.item,
    required this.selected,
    required this.color,
  });

  final GomanNavItem item;
  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final size =
        selected ? AppNavConstants.selectedIconSize : AppNavConstants.iconSize;

    if (item.iconAsset != null) {
      final picture = SvgPicture.asset(
        item.iconAsset!,
        width: size,
        height: size,
        colorFilter: item.preserveOriginalColors
            ? null
            : ColorFilter.mode(color, BlendMode.srcIn),
      );

      if (!item.preserveOriginalColors) return picture;

      return Opacity(
        opacity: selected ? 1 : 0.72,
        child: picture,
      );
    }

    return Icon(
      selected ? item.selectedIcon! : item.icon!,
      size: size,
      color: color,
    );
  }
}
