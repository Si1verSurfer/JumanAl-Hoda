import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import 'goman_svg_icon.dart';

/// App-wide search field — clean, compact, RTL-friendly.
class GomanSearchField extends StatefulWidget {
  const GomanSearchField({
    super.key,
    required this.controller,
    required this.isDark,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.hintText = 'ابحث...',
    this.height = GomanSearchField.preferredHeight,
    this.hintStyle,
    this.textStyle,
    this.iconAsset,
    this.suffix,
    this.autofocus = false,
  });

  static const double preferredHeight = 48;
  static const double borderRadius = 16;
  static const double _borderWidth = 1.25;
  static const double _iconBoxSize = 32;
  static const double _horizontalPadding = 8;

  final TextEditingController controller;
  final bool isDark;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final String hintText;
  final double height;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final String? iconAsset;
  final Widget? suffix;
  final bool autofocus;

  @override
  State<GomanSearchField> createState() => _GomanSearchFieldState();
}

class _GomanSearchFieldState extends State<GomanSearchField> {
  FocusNode? _ownedFocusNode;
  late FocusNode _focusNode;
  bool _focused = false;

  FocusNode get focusNode => widget.focusNode ?? _ownedFocusNode!;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _ownedFocusNode = FocusNode();
    }
    _focusNode = widget.focusNode ?? _ownedFocusNode!;
    _focused = _focusNode.hasFocus;
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant GomanSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      _focusNode.removeListener(_handleFocusChange);
      _ownedFocusNode?.dispose();
      _ownedFocusNode = null;
      if (widget.focusNode == null) {
        _ownedFocusNode = FocusNode();
      }
      _focusNode = widget.focusNode ?? _ownedFocusNode!;
      _focused = _focusNode.hasFocus;
      _focusNode.addListener(_handleFocusChange);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    final focused = _focusNode.hasFocus;
    if (_focused != focused) {
      setState(() => _focused = focused);
    }
  }

  void _clear() {
    widget.controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([widget.controller, _focusNode]),
      builder: (context, _) {
        final hasQuery = widget.controller.text.trim().isNotEmpty;
        final textColor =
            widget.isDark ? AppColors.surfaceLight : AppColors.primary;
        final muted = textColor.withValues(alpha: 0.42);
        final fieldHeight = widget.height;

        final resolvedHintStyle = widget.hintStyle ??
            GoogleFonts.tajawal(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: muted,
              height: 1.2,
            );

        final resolvedTextStyle = widget.textStyle ??
            GoogleFonts.notoNaskhArabic(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textColor,
              height: 1.2,
            );

        final borderColor = _focused
            ? AppColors.secondary.withValues(alpha: 0.5)
            : AppColors.borderOnCard(widget.isDark, alphaLight: 0.1);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          height: fieldHeight,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.cardSurface(widget.isDark),
            borderRadius:
                BorderRadius.circular(GomanSearchField.borderRadius),
            border: Border.all(
              color: borderColor,
              width: GomanSearchField._borderWidth,
            ),
            boxShadow: _focused
                ? null
                : [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: GomanSearchField._horizontalPadding,
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              inputDecorationTheme: const InputDecorationTheme(
                filled: false,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _SearchIconBadge(
                  isDark: widget.isDark,
                  focused: _focused,
                  iconAsset: widget.iconAsset,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: focusNode,
                    autofocus: widget.autofocus,
                    onChanged: widget.onChanged,
                    onSubmitted: widget.onSubmitted,
                    textInputAction: TextInputAction.search,
                    textAlign: TextAlign.right,
                    textAlignVertical: TextAlignVertical.center,
                    style: resolvedTextStyle,
                    cursorColor: AppColors.secondary,
                    cursorWidth: 1.5,
                    decoration: InputDecoration(
                      isCollapsed: true,
                      hintText: widget.hintText,
                      hintStyle: resolvedHintStyle,
                      hintMaxLines: 1,
                      border: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                if (hasQuery)
                  _ClearButton(onPressed: _clear)
                else if (widget.suffix != null) ...[
                  const SizedBox(width: 6),
                  SizedBox(
                    height: GomanSearchField._iconBoxSize,
                    child: Center(child: widget.suffix),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SearchIconBadge extends StatelessWidget {
  const _SearchIconBadge({
    required this.isDark,
    required this.focused,
    required this.iconAsset,
  });

  final bool isDark;
  final bool focused;
  final String? iconAsset;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      width: GomanSearchField._iconBoxSize,
      height: GomanSearchField._iconBoxSize,
      decoration: BoxDecoration(
        color: focused
            ? AppColors.secondary
            : AppColors.secondary.withValues(alpha: isDark ? 0.16 : 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: iconAsset != null
            ? GomanSvgIcon(
                asset: iconAsset!,
                size: 16,
                color: focused
                    ? AppColors.onPrimary
                    : AppColors.secondary.withValues(alpha: 0.88),
              )
            : Icon(
                Icons.search_rounded,
                size: 18,
                color: focused
                    ? AppColors.onPrimary
                    : AppColors.secondary.withValues(alpha: 0.88),
              ),
      ),
    );
  }
}

class _ClearButton extends StatelessWidget {
  const _ClearButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 2),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          child: SizedBox(
            width: GomanSearchField._iconBoxSize,
            height: GomanSearchField._iconBoxSize,
            child: Center(
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 14,
                  color: AppColors.secondary.withValues(alpha: 0.75),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
