import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/ayah_card.dart';
import '../../data/models/ayah_highlight.dart';
import '../../data/quran_ayah_card_gallery_service.dart';
import '../providers/quran_ayah_cards_provider.dart';
import '../utils/ayah_highlight_colors.dart';
import 'quran_ayah_card_preview.dart';

class QuranAyahCardTile extends ConsumerStatefulWidget {
  const QuranAyahCardTile({
    super.key,
    required this.card,
    required this.isDark,
    required this.onTap,
    required this.onRemove,
  });

  final SavedAyahCard card;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  ConsumerState<QuranAyahCardTile> createState() => _QuranAyahCardTileState();
}

class _QuranAyahCardTileState extends ConsumerState<QuranAyahCardTile> {
  bool _savingToGallery = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureImage());
  }

  @override
  void didUpdateWidget(covariant QuranAyahCardTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.card.id != widget.card.id ||
        oldWidget.card.imagePath != widget.card.imagePath ||
        oldWidget.card.verseNumbers.length != widget.card.verseNumbers.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _ensureImage());
    }
  }

  void _ensureImage() {
    if (!mounted) return;

    final path = widget.card.imagePath;
    final hasValidImage = path != null && File(path).existsSync();
    if (hasValidImage) return;

    final generating = ref
        .read(quranAyahCardsProvider.notifier)
        .isGenerating(widget.card.id);
    if (generating) return;

    ref.read(quranAyahCardsProvider.notifier).generateImageForCard(
          context: context,
          card: widget.card,
        );
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.tajawal(fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      ),
    );
  }

  Future<void> _saveToGallery() async {
    if (_savingToGallery) return;

    final imagePath = widget.card.imagePath;
    if (imagePath == null || !File(imagePath).existsSync()) {
      _showSnack('جاري تجهيز البطاقة، حاول مرة أخرى بعد لحظات');
      return;
    }

    setState(() => _savingToGallery = true);

    try {
      final result = await QuranAyahCardGalleryService.saveToGallery(imagePath);
      if (!mounted) return;

      final message = switch (result) {
        AyahCardGallerySaveResult.saved => 'تم حفظ البطاقة في مكتبة الصور',
        AyahCardGallerySaveResult.shared =>
          'اختر «حفظ الصورة» من قائمة المشاركة',
        AyahCardGallerySaveResult.denied => 'لم يتم منح إذن حفظ الصور',
        AyahCardGallerySaveResult.unavailable =>
          'أعد تشغيل التطبيق بالكامل ثم حاول مرة أخرى',
      };
      _showSnack(message);
    } finally {
      if (mounted) {
        setState(() => _savingToGallery = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    final isDark = widget.isDark;
    final imagePath = card.imagePath;
    final hasImage = imagePath != null && File(imagePath).existsSync();
    ref.watch(quranAyahCardsProvider);
    final generating = ref
        .read(quranAyahCardsProvider.notifier)
        .isGenerating(card.id);
    final cardWidth = MediaQuery.sizeOf(context).width.clamp(280.0, 340.0) - 48;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: cardWidth),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(18),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: isDark
                          ? null
                          : [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.07),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Stack(
                        children: [
                          if (hasImage)
                            Image.file(
                              File(imagePath),
                              width: cardWidth,
                              fit: BoxFit.fitWidth,
                            )
                          else
                            _CardLoadingPlaceholder(
                              width: cardWidth,
                              card: card,
                              isDark: isDark,
                            ),
                          if (generating && !hasImage)
                            Positioned.fill(
                              child: ColoredBox(
                                color: Colors.black.withValues(alpha: 0.03),
                                child: Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.secondary
                                          .withValues(alpha: 0.65),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (card.verseNumbers.length > 1)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: AppColors.secondary
                                      .withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 3,
                                  ),
                                  child: Text(
                                    '${convertToArabicNumber('${card.verseNumbers.length}')} آيات',
                                    style: GoogleFonts.tajawal(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.surfaceLight,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceDarkElevated
                      : AppColors.glassLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _CardFooterAction(
                        icon: Icons.ios_share_rounded,
                        label: 'حفظ',
                        isDark: isDark,
                        loading: _savingToGallery,
                        onTap: _saveToGallery,
                      ),
                      _footerDivider(isDark),
                      _CardFooterAction(
                        icon: Icons.menu_book_rounded,
                        label: 'فتح',
                        isDark: isDark,
                        onTap: widget.onTap,
                      ),
                      _footerDivider(isDark),
                      _CardFooterAction(
                        icon: Icons.delete_outline_rounded,
                        label: 'حذف',
                        isDark: isDark,
                        onTap: widget.onRemove,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _footerDivider(bool isDark) {
    return Container(
      width: 1,
      height: 18,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      color: AppColors.secondary.withValues(alpha: isDark ? 0.2 : 0.14),
    );
  }
}

class _CardLoadingPlaceholder extends StatelessWidget {
  const _CardLoadingPlaceholder({
    required this.width,
    required this.card,
    required this.isDark,
  });

  final double width;
  final SavedAyahCard card;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: QuranAyahCardPreview(
        surahNumber: card.surahNumber,
        verseNumbers: card.verseNumbers,
        width: width,
      ),
    );
  }
}

class _CardFooterAction extends StatelessWidget {
  const _CardFooterAction({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.onTap,
    this.loading = false,
  });

  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (loading)
              SizedBox(
                width: 13,
                height: 13,
                child: CircularProgressIndicator(
                  strokeWidth: 1.6,
                  color: AppColors.secondary.withValues(alpha: 0.75),
                ),
              )
            else
              Icon(
                icon,
                size: 14,
                color: AppColors.secondary.withValues(alpha: 0.85),
              ),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.tajawal(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.surfaceLight : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuranAyahHighlightTile extends StatelessWidget {
  const QuranAyahHighlightTile({
    super.key,
    required this.highlight,
    required this.isDark,
    required this.onTap,
    required this.onRemove,
  });

  final SavedAyahHighlight highlight;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final surahName = getSurahNameArabicWithTashkeel(highlight.surahNumber);
    final ayahText = getVerse(highlight.surahNumber, highlight.verseNumber);
    final ayahLabel =
        '${convertToArabicNumber('${highlight.surahNumber}')}:${convertToArabicNumber('${highlight.verseNumber}')}';
    final color = AyahHighlightColors.chip(highlight.color);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.14 : 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.45)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 10, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$surahName · $ayahLabel · ${AyahHighlightColors.label(highlight.color)}',
                          style: GoogleFonts.tajawal(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ayahText,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: GoogleFonts.notoNaskhArabic(
                            fontSize: 16,
                            height: 1.75,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.surfaceLight
                                : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onRemove,
                    icon: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: AppColors.secondary.withValues(alpha: 0.7),
                    ),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
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
