import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../../core/theme/app_colors.dart';
import '../constants/quran_icon_assets.dart';
import '../../data/models/ayah_highlight.dart';
import '../providers/quran_ayah_highlights_provider.dart';
import '../providers/quran_reading_provider.dart';
import '../theme/quran_qcf_theme.dart';
import '../utils/ayah_highlight_colors.dart';
import '../utils/quran_page_utils.dart';
import '../widgets/quran_ayah_actions_sheet.dart';
import '../widgets/quran_reader_chrome.dart';
import '../widgets/quran_search_sheet.dart';
import '../widgets/quran_surah_list_sheet.dart';
import '../widgets/quran_tafseer_sheet.dart';

abstract final class _ReaderTap {
  static const slop = 18.0;
  static const longPressThreshold = Duration(milliseconds: 450);
}

abstract final class _ReaderLayout {
  static const horizontalMargin = 10.0;
  static const verticalMargin = 8.0;
}

abstract final class _AyahHighlightAnimation {
  static const fadeIn = Duration(milliseconds: 350);
  static const hold = Duration(milliseconds: 1200);
  static const fadeOut = Duration(milliseconds: 450);
}

class _HighlightedAyah {
  const _HighlightedAyah({
    required this.surahNumber,
    required this.verseNumber,
  });

  final int surahNumber;
  final int verseNumber;
}

class _MushafViewport extends StatelessWidget {
  const _MushafViewport({
    required this.pageController,
    required this.startPage,
    required this.theme,
    required this.onPageChanged,
    required this.onAyahLongPress,
    required this.verseBackgroundColor,
    required this.isDark,
  });

  final PageController pageController;
  final int startPage;
  final QcfThemeData theme;
  final ValueChanged<int> onPageChanged;
  final void Function(int surahNumber, int verseNumber) onAyahLongPress;
  final Color? Function(int surahNumber, int verseNumber) verseBackgroundColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);

    return Padding(
      padding: const EdgeInsets.only(
        left: _ReaderLayout.horizontalMargin,
        right: _ReaderLayout.horizontalMargin,
        top: _ReaderLayout.verticalMargin,
      ),
      child: FittedBox(
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: screen.width,
          height: screen.height,
          child: PageviewQuran(
            controller: pageController,
            initialPageNumber: startPage,
            theme: theme,
            physics: const BouncingScrollPhysics(),
            onPageChanged: onPageChanged,
            onLongPress: onAyahLongPress,
            verseBackgroundColor: verseBackgroundColor,
          ),
        ),
      ),
    );
  }
}

class QuranReaderScreen extends ConsumerStatefulWidget {
  const QuranReaderScreen({
    super.key,
    required this.initialPageNumber,
    this.flashAyahSurah,
    this.flashAyahVerse,
  });

  final int initialPageNumber;
  final int? flashAyahSurah;
  final int? flashAyahVerse;

  @override
  ConsumerState<QuranReaderScreen> createState() => _QuranReaderScreenState();
}

class _QuranReaderScreenState extends ConsumerState<QuranReaderScreen>
    with SingleTickerProviderStateMixin {
  bool _showTopControls = false;
  Offset? _pointerDown;
  DateTime? _pointerDownTime;
  _HighlightedAyah? _highlightedAyah;
  late final AnimationController _highlightOpacityController;
  int _highlightGeneration = 0;

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _highlightOpacityController = AnimationController(
      vsync: this,
      value: 0,
    )..addListener(() {
        if (mounted) setState(() {});
      });
    final page = widget.initialPageNumber.clamp(1, totalPagesCount);
    _pageController = PageController(initialPage: page - 1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(quranLastPageProvider.notifier).state = page;
      final flashSurah = widget.flashAyahSurah;
      final flashVerse = widget.flashAyahVerse;
      if (flashSurah != null && flashVerse != null) {
        _flashAyahHighlight(flashSurah, flashVerse);
      }
    });
  }

  @override
  void dispose() {
    _highlightOpacityController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent event) {
    _pointerDown = event.position;
    _pointerDownTime = DateTime.now();
  }

  void _onPointerUp(PointerUpEvent event) {
    final origin = _pointerDown;
    final downTime = _pointerDownTime;
    _pointerDown = null;
    _pointerDownTime = null;
    if (origin == null || downTime == null) return;

    final held = DateTime.now().difference(downTime);
    if (held >= _ReaderTap.longPressThreshold) return;

    if ((event.position - origin).distance <= _ReaderTap.slop) {
      setState(() => _showTopControls = !_showTopControls);
    }
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _pointerDown = null;
    _pointerDownTime = null;
  }

  Future<void> _flashAyahHighlight(int surahNumber, int verseNumber) async {
    final generation = ++_highlightGeneration;
    _highlightOpacityController.stop();
    _highlightOpacityController.value = 0;

    setState(() {
      _highlightedAyah = _HighlightedAyah(
        surahNumber: surahNumber,
        verseNumber: verseNumber,
      );
    });

    await _highlightOpacityController.animateTo(
      1,
      duration: _AyahHighlightAnimation.fadeIn,
      curve: Curves.easeOutCubic,
    );
    if (!mounted || generation != _highlightGeneration) return;

    await Future<void>.delayed(_AyahHighlightAnimation.hold);
    if (!mounted || generation != _highlightGeneration) return;

    await _highlightOpacityController.animateTo(
      0,
      duration: _AyahHighlightAnimation.fadeOut,
      curve: Curves.easeInCubic,
    );
    if (!mounted || generation != _highlightGeneration) return;

    setState(() => _highlightedAyah = null);
  }

  void _jumpToSurah(int surahNumber) {
    final page = getPageNumber(surahNumber, 1);
    _pageController.animateToPage(
      page - 1,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  void _openSurahList() {
    showQuranSurahListSheet(
      context,
      onSurahSelected: _jumpToSurah,
    );
  }

  void _jumpToAyah(int surahNumber, int verseNumber) {
    final page = getPageNumber(surahNumber, verseNumber);
    _pageController.animateToPage(
      page - 1,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  void _jumpToAyahFromSearch(int surahNumber, int verseNumber) {
    _jumpToAyah(surahNumber, verseNumber);
    _flashAyahHighlight(surahNumber, verseNumber);
  }

  void _openSearch() {
    showQuranSearchSheet(
      context,
      onNavigate: _jumpToAyahFromSearch,
    );
  }

  void _openAyahTafseer(int surahNumber, int verseNumber) {
    showQuranAyahTafseerSheet(
      context,
      surahNumber: surahNumber,
      verseNumber: verseNumber,
    );
  }

  void _openAyahActions(int surahNumber, int verseNumber) {
    showQuranAyahActionsSheet(
      context,
      surahNumber: surahNumber,
      verseNumber: verseNumber,
      onOpenTafseer: () => _openAyahTafseer(surahNumber, verseNumber),
    );
  }

  Color? _verseBackgroundColor({
    required int surahNumber,
    required int verseNumber,
    required bool isDark,
    required List<SavedAyahHighlight> highlights,
  }) {
    final flash = _highlightedAyah;
    if (flash != null &&
        flash.surahNumber == surahNumber &&
        flash.verseNumber == verseNumber &&
        _highlightOpacityController.value > 0) {
      final baseAlpha = isDark ? 0.38 : 0.26;
      return AppColors.secondary
          .withValues(alpha: baseAlpha * _highlightOpacityController.value);
    }

    for (final entry in highlights) {
      if (entry.surahNumber == surahNumber &&
          entry.verseNumber == verseNumber) {
        return AyahHighlightColors.mushaf(entry.color, isDark: isDark);
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = QuranQcfTheme.forBrightness(Theme.of(context).brightness);
    final startPage = widget.initialPageNumber.clamp(1, totalPagesCount);
    final currentPage = ref.watch(quranLastPageProvider);
    final currentSurah = getPrimarySurahForPage(currentPage);
    final currentSurahName = getSurahNameArabic(currentSurah);
    final savedHighlights = ref.watch(quranAyahHighlightsProvider);

    return Scaffold(
      backgroundColor: theme.pageBackgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: _onPointerDown,
              onPointerUp: _onPointerUp,
              onPointerCancel: _onPointerCancel,
              child: _MushafViewport(
                pageController: _pageController,
                startPage: startPage,
                theme: theme,
                isDark: isDark,
                verseBackgroundColor: (surah, verse) => _verseBackgroundColor(
                  surahNumber: surah,
                  verseNumber: verse,
                  isDark: isDark,
                  highlights: savedHighlights,
                ),
                onPageChanged: (page) {
                  ref.read(quranLastPageProvider.notifier).state = page;
                },
                onAyahLongPress: _openAyahActions,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              ignoring: !_showTopControls,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                offset: _showTopControls ? Offset.zero : const Offset(0, -1),
                child: QuranReaderTopBar(
                  surahName: currentSurahName,
                  backIconAsset: QuranIconAssets.back,
                  searchIconAsset: QuranIconAssets.search,
                  surahListIconAsset: QuranIconAssets.surahList,
                  onBack: () => context.pop(),
                  onSurahList: _openSurahList,
                  onSearch: _openSearch,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
