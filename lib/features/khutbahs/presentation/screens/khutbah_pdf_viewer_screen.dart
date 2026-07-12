import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/haptics/goman_haptics.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/goman_app_bar_back_button.dart';
import '../providers/khutbah_providers.dart';

class KhutbahPdfViewerScreen extends HookConsumerWidget {
  const KhutbahPdfViewerScreen({
    super.key,
    required this.khutbahId,
  });

  final int khutbahId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final repo = ref.watch(khutbahRepositoryProvider);
    final entry = repo?.byId(khutbahId);
    final filePath = useState<String?>(null);
    final loading = useState(true);
    final progress = useState(0.0);
    final error = useState<String?>(null);
    final controller = useMemoized(PdfViewerController.new);

    Future<void> loadPdf() async {
      if (entry == null) {
        error.value = AppStrings.khutbahsPdfError;
        loading.value = false;
        return;
      }

      loading.value = true;
      error.value = null;
      progress.value = 0;

      try {
        final cache = ref.read(khutbahPdfCacheProvider);
        final file = await cache.download(
          entry,
          onProgress: (value) => progress.value = value,
        );
        filePath.value = file.path;
      } catch (_) {
        error.value = AppStrings.khutbahsPdfError;
      } finally {
        loading.value = false;
      }
    }

    useEffect(() {
      loadPdf();
      return null;
    }, [khutbahId]);

    final background =
        isDark ? AppColors.surfaceDark : AppColors.surfaceLight;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const GomanAppBarBackButton(),
        title: GomanAppBarArabicTitle(
          title: entry?.title ?? AppStrings.khutbahs,
        ),
        actions: [
          if (filePath.value != null)
            IconButton(
              tooltip: AppStrings.khutbahsShare,
              onPressed: () async {
                GomanHaptics.tap();
                await Share.shareXFiles([
                  XFile(filePath.value!),
                ], text: entry?.title ?? '');
              },
              icon: const Icon(Icons.ios_share_rounded),
            ),
        ],
      ),
      body: _Body(
        isDark: isDark,
        loading: loading.value,
        progress: progress.value,
        error: error.value,
        filePath: filePath.value,
        controller: controller,
        onRetry: loadPdf,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.isDark,
    required this.loading,
    required this.progress,
    required this.error,
    required this.filePath,
    required this.controller,
    required this.onRetry,
  });

  final bool isDark;
  final bool loading;
  final double progress;
  final String? error;
  final String? filePath;
  final PdfViewerController controller;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 220,
                child: LinearProgressIndicator(
                  value: progress > 0 ? progress : null,
                  backgroundColor:
                      AppColors.primary.withValues(alpha: 0.08),
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.khutbahsPdfLoading,
                textAlign: TextAlign.center,
                style: GoogleFonts.tajawal(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mutedOnCard(isDark),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (error != null || filePath == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off_rounded,
                size: 48,
                color: AppColors.secondary.withValues(alpha: 0.55),
              ),
              const SizedBox(height: 16),
              Text(
                error ?? AppStrings.khutbahsPdfError,
                textAlign: TextAlign.center,
                style: GoogleFonts.tajawal(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mutedOnCard(isDark),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: onRetry,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.onPrimary,
                ),
                child: Text(
                  AppStrings.khutbahsRetry,
                  style: GoogleFonts.tajawal(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ColoredBox(
      color: AppColors.cardSurface(isDark),
      child: PdfViewer.file(
        filePath!,
        controller: controller,
        params: PdfViewerParams(
          backgroundColor: AppColors.cardSurface(isDark),
          margin: 8,
          textSelectionParams: const PdfTextSelectionParams(enabled: false),
          layoutPages: _layoutPagesHorizontally,
        ),
      ),
    );
  }
}

PdfPageLayout _layoutPagesHorizontally(
  List<PdfPage> pages,
  PdfViewerParams params,
) {
  if (pages.isEmpty) {
    return PdfPageLayout(pageLayouts: const [], documentSize: Size.zero);
  }

  final height =
      pages.map((page) => page.height).reduce(math.max) + params.margin * 2;
  final pageLayouts = <Rect>[];
  var x = params.margin;

  for (final page in pages) {
    pageLayouts.add(
      Rect.fromLTWH(
        x,
        params.margin + (height - params.margin * 2 - page.height) / 2,
        page.width,
        page.height,
      ),
    );
    x += page.width + params.margin;
  }

  return PdfPageLayout(
    pageLayouts: pageLayouts,
    documentSize: Size(x, height),
  );
}
