import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/ayah_tafseer.dart';
import '../utils/quran_tafseer_html_parser.dart';

class QuranTafseerScrollContent extends StatelessWidget {
  const QuranTafseerScrollContent({
    super.key,
    required this.tafseer,
    required this.isLoading,
    required this.isDark,
    required this.scrollController,
  });

  final AyahTafseer? tafseer;
  final bool isLoading;
  final bool isDark;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Skeletonizer(
              enabled: isLoading,
              effect: ShimmerEffect(
                baseColor:
                    AppColors.secondary.withValues(alpha: isDark ? 0.14 : 0.07),
                highlightColor: AppColors.secondary
                    .withValues(alpha: isDark ? 0.24 : 0.14),
                duration: const Duration(milliseconds: 1500),
              ),
              child: tafseer != null
                  ? _TafseerContentBlocks(tafseer: tafseer!, isDark: isDark)
                  : const _TafseerPlaceholderBlocks(),
            ),
          ),
        );
      },
    );
  }
}

class _TafseerPlaceholderBlocks extends StatelessWidget {
  const _TafseerPlaceholderBlocks();

  static const _lineStyle = TextStyle(fontSize: 16, height: 1.9);
  static const _badgeStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.w700);
  static const _placeholder =
      'الله الذي لا يستحق الألوهية والعبودية إلا هو الحي القائم على كل شيء';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: const Text('التفسير الميسر', style: _badgeStyle),
          ),
        ),
        const SizedBox(height: 14),
        const _PlaceholderParagraph(
          lines: [1, 0.96, 0.9, 0.78],
          style: _lineStyle,
        ),
        const SizedBox(height: 14),
        const _PlaceholderParagraph(
          lines: [0.98, 0.94, 0.86, 0.7, 0.42],
          style: _lineStyle,
        ),
        const SizedBox(height: 14),
        const _PlaceholderParagraph(
          lines: [0.92, 0.88, 0.8],
          style: _lineStyle,
        ),
      ],
    );
  }
}

class _PlaceholderParagraph extends StatelessWidget {
  const _PlaceholderParagraph({
    required this.lines,
    required this.style,
  });

  final List<double> lines;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final widthFactor in lines)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: FractionallySizedBox(
              widthFactor: widthFactor,
              alignment: Alignment.centerRight,
              child: Text(
                _TafseerPlaceholderBlocks._placeholder,
                maxLines: 1,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: style,
              ),
            ),
          ),
      ],
    );
  }
}

class _TafseerContentBlocks extends StatelessWidget {
  const _TafseerContentBlocks({
    required this.tafseer,
    required this.isDark,
  });

  final AyahTafseer tafseer;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final paragraphs = QuranTafseerHtmlParser.parse(tafseer.text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (tafseer.resourceName.isNotEmpty) ...[
          _ResourceBadge(label: tafseer.resourceName, isDark: isDark),
          const SizedBox(height: 14),
        ],
        ...paragraphs.map(
          (paragraph) => Padding(
            padding: EdgeInsets.only(
              bottom: paragraph.isHeading ? 10 : 14,
              top: paragraph.isHeading ? 4 : 0,
            ),
            child: _TafseerParagraphView(
              paragraph: paragraph,
              isDark: isDark,
            ),
          ),
        ),
      ],
    );
  }
}

class _ResourceBadge extends StatelessWidget {
  const _ResourceBadge({
    required this.label,
    required this.isDark,
  });

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: isDark ? 0.16 : 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.22),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.notoNaskhArabic(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.secondary.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}

class _TafseerParagraphView extends StatelessWidget {
  const _TafseerParagraphView({
    required this.paragraph,
    required this.isDark,
  });

  final TafseerParagraph paragraph;
  final bool isDark;

  TextStyle _baseStyle() {
    if (paragraph.isHeading) {
      return GoogleFonts.notoNaskhArabic(
        fontSize: 17,
        height: 1.6,
        fontWeight: FontWeight.w800,
        color: isDark ? AppColors.surfaceLight : AppColors.primary,
      );
    }

    return GoogleFonts.notoNaskhArabic(
      fontSize: 16,
      height: 1.9,
      fontWeight: FontWeight.w500,
      color: isDark
          ? AppColors.surfaceLight.withValues(alpha: 0.92)
          : AppColors.primary.withValues(alpha: 0.9),
    );
  }

  TextStyle _styleFor(TafseerSpanKind kind) {
    final base = _baseStyle();

    return switch (kind) {
      TafseerSpanKind.body => base,
      TafseerSpanKind.label => base.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.secondary.withValues(alpha: isDark ? 0.95 : 0.92),
        ),
      TafseerSpanKind.quote => base.copyWith(
          fontWeight: FontWeight.w700,
          color: isDark
              ? AppColors.surfaceLight
              : AppColors.primary.withValues(alpha: 0.98),
        ),
      TafseerSpanKind.ayah => base.copyWith(
          fontWeight: FontWeight.w700,
          color: const Color(0xFF2F6B4F),
        ),
      TafseerSpanKind.reference => base.copyWith(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: (isDark ? AppColors.surfaceLight : AppColors.primary)
              .withValues(alpha: 0.62),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    if (paragraph.isHeading) {
      return Text(
        paragraph.spans.map((span) => span.text).join(),
        textAlign: TextAlign.right,
        style: _baseStyle(),
      );
    }

    return SelectableText.rich(
      TextSpan(
        children: paragraph.spans.map((span) {
          if (span.text == '\n') {
            return const TextSpan(text: '\n');
          }
          return TextSpan(
            text: span.text,
            style: _styleFor(span.kind),
          );
        }).toList(),
      ),
      textAlign: TextAlign.justify,
      textDirection: TextDirection.rtl,
    );
  }
}
