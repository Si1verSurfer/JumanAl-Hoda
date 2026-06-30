import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../../core/navigation/goman_navigation.dart';
import '../../../../core/theme/app_colors.dart';
import '../utils/quran_search_parser.dart';
import 'quran_search_field.dart';
import 'quran_search_result_tile.dart';

typedef QuranSearchNavigate = void Function(int surahNumber, int verseNumber);

Future<void> showQuranSearchSheet(
  BuildContext context, {
  required QuranSearchNavigate onNavigate,
}) {
  return showGomanModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return _QuranSearchSheet(
        onNavigate: (surah, verse) {
          Navigator.of(sheetContext).pop();
          onNavigate(surah, verse);
        },
      );
    },
  );
}

class _QuranSearchSheet extends StatefulWidget {
  const _QuranSearchSheet({required this.onNavigate});

  final QuranSearchNavigate onNavigate;

  @override
  State<_QuranSearchSheet> createState() => _QuranSearchSheetState();
}

class _QuranSearchSheetState extends State<_QuranSearchSheet> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  QuranSearchResults _results = const QuranSearchResults();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onQueryChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onQueryChanged)
      ..dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    setState(() {
      _results = searchQuran(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final query = _controller.text.trim();

    return DraggableScrollableSheet(
      initialChildSize: 0.82,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: isDark ? 0.18 : 0.08),
            ),
            boxShadow: AppColors.cardShadow(isDark: isDark),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'بحث',
                      style: GoogleFonts.notoNaskhArabic(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.surfaceLight
                            : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ابحث عن سورة أو آية — مثل: ٢:٢٥٥ أو البقرة',
                      style: GoogleFonts.notoNaskhArabic(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: (isDark
                                ? AppColors.surfaceLight
                                : AppColors.primary)
                            .withValues(alpha: 0.55),
                      ),
                    ),
                    const SizedBox(height: 12),
                    QuranSearchField(
                      controller: _controller,
                      focusNode: _focusNode,
                      isDark: isDark,
                      hintText: 'اسم السورة أو رقم الآية',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: query.isEmpty
                    ? _EmptySearchHint(isDark: isDark)
                    : ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        children: _buildResultSections(isDark),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildResultSections(bool isDark) {
    final sections = <Widget>[];

    final direct = _results.directAyah;
    if (direct != null) {
      sections.add(QuranSearchSectionTitle(label: 'انتقال مباشر', isDark: isDark));
      sections.add(
        QuranSearchResultTile(
          isDark: isDark,
          title:
              '${getSurahNameArabic(direct.surahNumber)} · ${convertToArabicNumber('${direct.surahNumber}')}:${convertToArabicNumber('${direct.verseNumber}')}',
          subtitle: 'الذهاب إلى الآية',
          onTap: () => widget.onNavigate(
            direct.surahNumber,
            direct.verseNumber,
          ),
        ),
      );
      sections.add(const SizedBox(height: 12));
    }

    if (_results.surahs.isNotEmpty) {
      sections.add(QuranSearchSectionTitle(label: 'السور', isDark: isDark));
      for (final match in _results.surahs.take(20)) {
        final n = match.surahNumber;
        sections.add(
          QuranSearchResultTile(
            isDark: isDark,
            title: getSurahNameArabic(n),
            subtitle:
                'سورة ${convertToArabicNumber('$n')} · ${getVerseCount(n)} آية',
            onTap: () => widget.onNavigate(n, 1),
          ),
        );
      }
      sections.add(const SizedBox(height: 12));
    }

    if (_results.ayahTextMatches.isNotEmpty) {
      sections.add(
        QuranSearchSectionTitle(label: 'نتائج في آيات القرآن', isDark: isDark),
      );
      for (final match in _results.ayahTextMatches.take(30)) {
        final s = match.surahNumber;
        final v = match.verseNumber;
        sections.add(
          QuranSearchResultTile(
            isDark: isDark,
            title:
                '${getSurahNameArabic(s)} · ${convertToArabicNumber('$s')}:${convertToArabicNumber('$v')}',
            subtitle: _versePreview(s, v),
            onTap: () => widget.onNavigate(s, v),
          ),
        );
      }
    }

    if (sections.isEmpty) {
      sections.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Text(
            'لا توجد نتائج',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoNaskhArabic(
              fontSize: 15,
              color: AppColors.secondary,
            ),
          ),
        ),
      );
    }

    return sections;
  }

  String _versePreview(int surah, int verse) {
    try {
      final text = getVerse(surah, verse);
      if (text.length <= 72) return text;
      return '${text.substring(0, 72)}…';
    } catch (_) {
      return '';
    }
  }
}

class _EmptySearchHint extends StatelessWidget {
  const _EmptySearchHint({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Text(
          'اكتب اسم السورة، رقمها، أو مرجع الآية\nمثال: ٢:٢٥٥ أو الرحمن',
          textAlign: TextAlign.center,
          style: GoogleFonts.notoNaskhArabic(
            fontSize: 15,
            height: 1.7,
            color: (isDark ? AppColors.surfaceLight : AppColors.primary)
                .withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
