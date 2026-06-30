import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../providers/quran_reading_provider.dart';
import '../theme/quran_qcf_theme.dart';
import '../utils/quran_page_utils.dart';
import '../widgets/quran_reader_chrome.dart';
import '../widgets/quran_surah_list_sheet.dart';
import '../widgets/quran_tafseer_sheet.dart';

abstract final class _ReaderTap {
  static const slop = 18.0;
}

abstract final class _ReaderLayout {
  static const horizontalMargin = 10.0;
  static const verticalMargin = 8.0;
}

class _MushafViewport extends StatelessWidget {
  const _MushafViewport({
    required this.pageController,
    required this.startPage,
    required this.theme,
    required this.onPageChanged,
  });

  final PageController pageController;
  final int startPage;
  final QcfThemeData theme;
  final ValueChanged<int> onPageChanged;

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
            h: 1.h,
            theme: theme,
            physics: const BouncingScrollPhysics(),
            onPageChanged: onPageChanged,
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
  });

  final int initialPageNumber;

  @override
  ConsumerState<QuranReaderScreen> createState() => _QuranReaderScreenState();
}

class _QuranReaderScreenState extends ConsumerState<QuranReaderScreen> {
  bool _showTopControls = false;
  Offset? _pointerDown;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    final page = widget.initialPageNumber.clamp(1, totalPagesCount);
    _pageController = PageController(initialPage: page - 1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(quranLastPageProvider.notifier).state = page;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent event) {
    _pointerDown = event.position;
  }

  void _onPointerUp(PointerUpEvent event) {
    final origin = _pointerDown;
    _pointerDown = null;
    if (origin == null) return;

    if ((event.position - origin).distance <= _ReaderTap.slop) {
      setState(() => _showTopControls = !_showTopControls);
    }
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _pointerDown = null;
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

  void _openTafseer(int surahNumber) {
    showQuranTafseerSheet(
      context,
      surahNumber: surahNumber,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = QuranQcfTheme.forBrightness(Theme.of(context).brightness);
    final startPage = widget.initialPageNumber.clamp(1, totalPagesCount);
    final currentPage = ref.watch(quranLastPageProvider);
    final currentSurah = getPrimarySurahForPage(currentPage);
    final currentSurahName = getSurahNameArabic(currentSurah);

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
                onPageChanged: (page) {
                  ref.read(quranLastPageProvider.notifier).state = page;
                },
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
                  onBack: () => context.pop(),
                  onSurahList: _openSurahList,
                  onTafseer: () => _openTafseer(currentSurah),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: QuranReaderBottomBar(pageNumber: currentPage),
          ),
        ],
      ),
    );
  }
}
