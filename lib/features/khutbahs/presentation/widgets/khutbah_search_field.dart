import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/goman_search_field.dart';

class KhutbahSearchField extends StatefulWidget {
  const KhutbahSearchField({
    super.key,
    required this.controller,
    required this.isDark,
    required this.onQueryChanged,
    this.focusNode,
  });

  static const double preferredHeight = GomanSearchField.preferredHeight;

  final TextEditingController controller;
  final bool isDark;
  final ValueChanged<String> onQueryChanged;
  final FocusNode? focusNode;

  @override
  State<KhutbahSearchField> createState() => _KhutbahSearchFieldState();
}

class _KhutbahSearchFieldState extends State<KhutbahSearchField> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _handleChanged(String value) {
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      widget.onQueryChanged('');
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 200), () {
      widget.onQueryChanged(value);
    });
  }

  void _handleSubmitted(String value) {
    _debounce?.cancel();
    widget.onQueryChanged(value.trim());
  }

  @override
  Widget build(BuildContext context) {
    final hintColor = (widget.isDark ? AppColors.surfaceLight : AppColors.primary)
        .withValues(alpha: 0.55);

    return GomanSearchField(
      controller: widget.controller,
      isDark: widget.isDark,
      focusNode: widget.focusNode,
      onChanged: _handleChanged,
      onSubmitted: _handleSubmitted,
      hintText: AppStrings.khutbahsSearchHint,
      height: KhutbahSearchField.preferredHeight,
      hintStyle: GoogleFonts.tajawal(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: hintColor,
        height: 1.3,
      ),
    );
  }
}
