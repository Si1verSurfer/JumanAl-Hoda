import 'package:flutter/material.dart';

class WorshipCategory {
  const WorshipCategory({
    required this.id,
    required this.title,
    required this.accentColorArgb,
    required this.sortOrder,
    this.fullWidth = false,
    this.group,
  });

  final String id;
  final String title;
  final int accentColorArgb;
  final int sortOrder;
  final bool fullWidth;
  /// `guides` = home guide block; null = main adhkar grid.
  final String? group;

  Color get accentColor => Color(accentColorArgb);

  bool get isGuide => group == 'guides';

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'accentColorArgb': accentColorArgb,
        'sortOrder': sortOrder,
        'fullWidth': fullWidth,
        if (group != null) 'group': group,
      };

  factory WorshipCategory.fromJson(Map<String, dynamic> json) {
    return WorshipCategory(
      id: json['id'] as String,
      title: json['title'] as String,
      accentColorArgb: json['accentColorArgb'] as int,
      sortOrder: json['sortOrder'] as int,
      fullWidth: json['fullWidth'] as bool? ?? false,
      group: json['group'] as String?,
    );
  }
}
