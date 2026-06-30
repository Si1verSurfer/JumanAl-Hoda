import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../../core/widgets/animated_entrance.dart';
import '../../../../core/theme/app_colors.dart';
import '../utils/quran_index_filter.dart';
import '../utils/quran_search_parser.dart';
import 'quran_division_filter_bar.dart';
import 'quran_index_grid_tiles.dart';
import 'quran_search_field.dart';
import 'quran_search_result_tile.dart';

typedef QuranSurahIndexTap = void Function(int surahNumber);
typedef QuranAyahIndexTap = void Function(int surahNumber, int verseNumber);

class QuranSurahIndexBody extends StatefulWidget {
  const QuranSurahIndexBody({
    super.key,
    required this.isDark,
    required this.onSurahTap,
    this.onAyahTap,
    this.scrollController,
    this.headerSlivers = const [],
    this.controlsPadding = const EdgeInsets.fromLTRB(20, 14, 20, 0),
    this.gridPadding = const EdgeInsets.fromLTRB(20, 14, 20, 24),
    this.showTitle = false,
  });

  final bool isDark;
  final QuranSurahIndexTap onSurahTap;
  final QuranAyahIndexTap? onAyahTap;
  final ScrollController? scrollController;
  final List<Widget> headerSlivers;
  final EdgeInsets controlsPadding;
  final EdgeInsets gridPadding;
  final bool showTitle;

  @override
  State<QuranSurahIndexBody> createState() => _QuranSurahIndexBodyState();
}

class _QuranSurahIndexBodyState extends State<QuranSurahIndexBody> {
  final _searchController = TextEditingController();
  final _headerKey = GlobalKey();
  QuranSearchResults _searchResults = const QuranSearchResults();
  QuranDivisionFilter _division = QuranDivisionFilter.all;
  int _juzNumber = 1;
  int _hizbNumber = 1;
  bool _stickyPinned = false;
  double _headerHeight = 0;
  ScrollController? _ownedScrollController;

  static const _stickyTopPadding = 20.0;
  static const _sectionGap = 12.0;
  static const _layoutBuffer = 4.0;

  static const _gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisSpacing: 18,
    crossAxisSpacing: 18,
    mainAxisExtent: 124,
  );

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    if (widget.scrollController == null) {
      _ownedScrollController = ScrollController();
    }
    (widget.scrollController ?? _ownedScrollController!)
        .addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeader());
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    (widget.scrollController ?? _ownedScrollController)?.removeListener(
      _handleScroll,
    );
    _ownedScrollController?.dispose();
    super.dispose();
  }

  void _measureHeader() {
    final renderObject = _headerKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;

    final height = renderObject.size.height;
    if ((height - _headerHeight).abs() > 0.5) {
      setState(() => _headerHeight = height);
    }
  }

  void _handleScroll() {
    final controller = widget.scrollController ?? _ownedScrollController;
    if (controller == null || !controller.hasClients) return;

    final pinned = _headerHeight > 0 && controller.offset >= _headerHeight - 1;
    if (pinned != _stickyPinned) {
      setState(() => _stickyPinned = pinned);
    }
  }

  double _controlsHeight() {
    return widget.controlsPadding.vertical +
        QuranSearchField.preferredHeight +
        _sectionGap +
        QuranDivisionFilterBar.preferredHeight(_division) +
        _layoutBuffer;
  }

  double _stickyControlsExtent(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final base = _controlsHeight();
    if (_stickyPinned) {
      return base -
          widget.controlsPadding.top +
          topInset +
          _stickyTopPadding;
    }
    return base;
  }

  void _onSearchChanged() {
    setState(() {
      _searchResults = searchQuran(_searchController.text);
    });
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

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim();
    final visibleSurahs = resolveVisibleSurahs(
      query: query,
      division: _division,
      juzNumber: _juzNumber,
      hizbNumber: _hizbNumber,
    );
    final showAyahResults =
        hasAyahSearchResults(query, _searchResults) && widget.onAyahTap != null;

    WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeader());

    return CustomScrollView(
      controller: widget.scrollController ?? _ownedScrollController,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        for (var i = 0; i < widget.headerSlivers.length; i++)
          if (widget.headerSlivers[i] case SliverToBoxAdapter(:final child) when i == 0)
            SliverToBoxAdapter(
              child: KeyedSubtree(
                key: _headerKey,
                child: child ?? const SizedBox.shrink(),
              ),
            )
          else
            widget.headerSlivers[i],
        if (widget.showTitle)
          SliverToBoxAdapter(
            child: Padding(
              padding: widget.controlsPadding.copyWith(bottom: 12),
              child: Row(
                children: [
                  Text(
                    'فهرس السور',
                    style: GoogleFonts.notoNaskhArabic(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: widget.isDark
                          ? AppColors.surfaceLight
                          : AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${convertToArabicNumber('$totalSurahCount')} سورة',
                    style: GoogleFonts.notoNaskhArabic(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        SliverPersistentHeader(
          pinned: true,
          delegate: _QuranIndexStickyControlsDelegate(
            isDark: widget.isDark,
            extent: _stickyControlsExtent(context),
            padding: widget.controlsPadding,
            stickyTopPadding: _stickyTopPadding,
            pinnedAtTop: _stickyPinned,
            searchController: _searchController,
            division: _division,
            juzNumber: _juzNumber,
            hizbNumber: _hizbNumber,
            onDivisionChanged: (division) =>
                setState(() => _division = division),
            onJuzChanged: (number) => setState(() => _juzNumber = number),
            onHizbChanged: (number) => setState(() => _hizbNumber = number),
          ),
        ),
        if (showAyahResults)
          ..._buildAyahResultSlivers(query, widget.controlsPadding.horizontal / 2),
        if (query.isNotEmpty && visibleSurahs.isEmpty && !showAyahResults)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                'لا توجد نتائج',
                textAlign: TextAlign.center,
                style: GoogleFonts.notoNaskhArabic(
                  fontSize: 15,
                  color: AppColors.secondary,
                ),
              ),
            ),
          ),
        if (visibleSurahs.isNotEmpty)
          SliverPadding(
            padding: widget.gridPadding.copyWith(top: 10),
            sliver: SliverGrid(
              gridDelegate: _gridDelegate,
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final surahNumber = visibleSurahs[index];
                  return AnimatedEntrance(
                    delay: Duration(milliseconds: (index % 12) * 30),
                    child: QuranSurahGridTile(
                      surahNumber: surahNumber,
                      badgeOnRight: index.isEven,
                      isDark: widget.isDark,
                      onTap: () => widget.onSurahTap(surahNumber),
                    ),
                  );
                },
                childCount: visibleSurahs.length,
              ),
            ),
          )
        else
          SliverPadding(padding: widget.gridPadding.copyWith(top: 0)),
      ],
    );
  }

  List<Widget> _buildAyahResultSlivers(String query, double horizontalPadding) {
    final onAyahTap = widget.onAyahTap!;
    final padding = EdgeInsets.symmetric(horizontal: horizontalPadding);
    final widgets = <Widget>[];
    final direct = _searchResults.directAyah;

    if (direct != null) {
      widgets.add(
        SliverPadding(
          padding: padding.copyWith(top: 14),
          sliver: SliverToBoxAdapter(
            child: QuranSearchSectionTitle(
              label: 'انتقال مباشر',
              isDark: widget.isDark,
            ),
          ),
        ),
      );
      widgets.add(
        SliverPadding(
          padding: padding,
          sliver: SliverToBoxAdapter(
            child: QuranSearchResultTile(
              isDark: widget.isDark,
              title:
                  '${getSurahNameArabic(direct.surahNumber)} · ${convertToArabicNumber('${direct.surahNumber}')}:${convertToArabicNumber('${direct.verseNumber}')}',
              subtitle: 'الذهاب إلى الآية',
              onTap: () => onAyahTap(direct.surahNumber, direct.verseNumber),
            ),
          ),
        ),
      );
    }

    final ayahMatches = _searchResults.ayahTextMatches;
    if (ayahMatches.isNotEmpty) {
      widgets.add(
        SliverPadding(
          padding: padding.copyWith(top: direct != null ? 8 : 14),
          sliver: SliverToBoxAdapter(
            child: QuranSearchSectionTitle(
              label: 'نتائج في آيات القرآن',
              isDark: widget.isDark,
            ),
          ),
        ),
      );
      widgets.add(
        SliverPadding(
          padding: padding,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final match = ayahMatches[index];
                final surah = match.surahNumber;
                final verse = match.verseNumber;
                return QuranSearchResultTile(
                  isDark: widget.isDark,
                  title:
                      '${getSurahNameArabic(surah)} · ${convertToArabicNumber('$surah')}:${convertToArabicNumber('$verse')}',
                  subtitle: _versePreview(surah, verse),
                  onTap: () => onAyahTap(surah, verse),
                );
              },
              childCount: ayahMatches.length > 20 ? 20 : ayahMatches.length,
            ),
          ),
        ),
      );
    }

    return widgets;
  }
}

class _QuranIndexStickyControlsDelegate extends SliverPersistentHeaderDelegate {
  _QuranIndexStickyControlsDelegate({
    required this.isDark,
    required this.extent,
    required this.padding,
    required this.stickyTopPadding,
    required this.pinnedAtTop,
    required this.searchController,
    required this.division,
    required this.juzNumber,
    required this.hizbNumber,
    required this.onDivisionChanged,
    required this.onJuzChanged,
    required this.onHizbChanged,
  });

  final bool isDark;
  final double extent;
  final EdgeInsets padding;
  final double stickyTopPadding;
  final bool pinnedAtTop;
  final TextEditingController searchController;
  final QuranDivisionFilter division;
  final int juzNumber;
  final int hizbNumber;
  final ValueChanged<QuranDivisionFilter> onDivisionChanged;
  final ValueChanged<int> onJuzChanged;
  final ValueChanged<int> onHizbChanged;

  @override
  double get minExtent => extent;

  @override
  double get maxExtent => extent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final background =
        isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final topInset = MediaQuery.paddingOf(context).top;
    final topPadding = pinnedAtTop ? topInset + stickyTopPadding : 0.0;

    return Material(
      color: background,
      elevation: pinnedAtTop ? 3 : 0,
      shadowColor: AppColors.primary.withValues(alpha: 0.12),
      child: SizedBox(
        height: extent,
        child: DecoratedBox(
          decoration: pinnedAtTop
              ? BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.06),
                    ),
                  ),
                )
              : const BoxDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (topPadding > 0) SizedBox(height: topPadding),
              Padding(
                padding: padding.copyWith(
                  top: pinnedAtTop ? 0 : padding.top,
                  bottom: 4,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    QuranSearchField(
                      controller: searchController,
                      isDark: isDark,
                      hintText:
                          'ابحث عن سورة أو آية — مثل: ٢:٢٥٥ أو البقرة',
                    ),
                    const SizedBox(height: 12),
                    QuranDivisionFilterBar(
                      isDark: isDark,
                      division: division,
                      juzNumber: juzNumber,
                      hizbNumber: hizbNumber,
                      onDivisionChanged: onDivisionChanged,
                      onJuzChanged: onJuzChanged,
                      onHizbChanged: onHizbChanged,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _QuranIndexStickyControlsDelegate oldDelegate) {
    return oldDelegate.isDark != isDark ||
        oldDelegate.extent != extent ||
        oldDelegate.padding != padding ||
        oldDelegate.stickyTopPadding != stickyTopPadding ||
        oldDelegate.pinnedAtTop != pinnedAtTop ||
        oldDelegate.division != division ||
        oldDelegate.juzNumber != juzNumber ||
        oldDelegate.hizbNumber != hizbNumber;
  }
}
