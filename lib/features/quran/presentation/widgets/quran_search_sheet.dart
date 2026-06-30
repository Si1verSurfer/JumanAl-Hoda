import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../../core/theme/app_colors.dart';
import '../utils/quran_search_parser.dart';

typedef QuranSearchNavigate = void Function(int surahNumber, int verseNumber);

Future<void> showQuranSearchSheet(
  BuildContext context, {
  required QuranSearchNavigate onNavigate,
}) {
  return showModalBottomSheet<void>(
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
                    TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.notoNaskhArabic(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.surfaceLight
                            : AppColors.primary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'اسم السورة أو رقم الآية',
                        hintStyle: GoogleFonts.notoNaskhArabic(
                          fontSize: 15,
                          color: AppColors.primary.withValues(alpha: 0.4),
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: AppColors.secondary.withValues(alpha: 0.8),
                        ),
                        suffixIcon: query.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () => _controller.clear(),
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: AppColors.secondary
                                      .withValues(alpha: 0.75),
                                ),
                              ),
                        filled: true,
                        fillColor: isDark
                            ? AppColors.surfaceDarkElevated
                            : AppColors.glassLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: AppColors.secondary.withValues(alpha: 0.25),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: AppColors.primary.withValues(alpha: 0.1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: AppColors.secondary,
                            width: 1.4,
                          ),
                        ),
                      ),
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
      sections.add(_SectionTitle('انتقال مباشر', isDark: isDark));
      sections.add(
        _SearchResultTile(
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
      sections.add(_SectionTitle('السور', isDark: isDark));
      for (final match in _results.surahs.take(20)) {
        final n = match.surahNumber;
        sections.add(
          _SearchResultTile(
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
      sections.add(_SectionTitle('نتائج في آيات القرآن', isDark: isDark));
      for (final match in _results.ayahTextMatches.take(30)) {
        final s = match.surahNumber;
        final v = match.verseNumber;
        sections.add(
          _SearchResultTile(
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label, {required this.isDark});

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        label,
        style: GoogleFonts.notoNaskhArabic(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({
    required this.isDark,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool isDark;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceDarkElevated
                  : AppColors.glassLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.primary.withValues(
                  alpha: isDark ? 0.14 : 0.08,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.notoNaskhArabic(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.surfaceLight
                                : AppColors.primary,
                          ),
                        ),
                        if (subtitle.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.notoNaskhArabic(
                              fontSize: 13,
                              height: 1.5,
                              color: (isDark
                                      ? AppColors.surfaceLight
                                      : AppColors.primary)
                                  .withValues(alpha: 0.58),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.secondary.withValues(alpha: 0.75),
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
