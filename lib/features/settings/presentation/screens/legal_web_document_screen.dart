import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/constants/app_website.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/goman_scaffold.dart';
import '../../data/legal_documents.dart';
import 'legal_document_screen.dart';

class LegalWebDocumentScreen extends StatefulWidget {
  const LegalWebDocumentScreen({super.key, required this.kind});

  final LegalDocumentKind kind;

  @override
  State<LegalWebDocumentScreen> createState() => _LegalWebDocumentScreenState();
}

class _LegalWebDocumentScreenState extends State<LegalWebDocumentScreen> {
  late final WebViewController _controller;
  var _loading = true;
  var _failed = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() {
              _loading = true;
              _failed = false;
            });
          },
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() => _loading = false);
          },
          onWebResourceError: (_) {
            if (!mounted) return;
            setState(() {
              _loading = false;
              _failed = true;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(_urlFor(widget.kind)));
  }

  String _urlFor(LegalDocumentKind kind) => switch (kind) {
        LegalDocumentKind.privacyPolicy => AppWebsite.privacyPolicy,
        LegalDocumentKind.termsAndConditions => AppWebsite.termsAndConditions,
        LegalDocumentKind.about => AppWebsite.baseUrl,
      };

  Future<void> _reload() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    await _controller.loadRequest(Uri.parse(_urlFor(widget.kind)));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GomanScaffold(
      title: LegalDocuments.title(widget.kind),
      body: Stack(
        children: [
          if (!_failed)
            WebViewWidget(controller: _controller)
          else
            _ErrorState(
              isDark: isDark,
              onRetry: _reload,
              onLocalFallback: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (context) => LegalDocumentScreen(kind: widget.kind),
                  ),
                );
              },
            ),
          if (_loading && !_failed)
            const Center(
              child: CircularProgressIndicator(color: AppColors.secondary),
            ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.isDark,
    required this.onRetry,
    required this.onLocalFallback,
  });

  final bool isDark;
  final VoidCallback onRetry;
  final VoidCallback onLocalFallback;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 48,
              color: AppColors.mutedOnCard(isDark),
            ),
            const SizedBox(height: 16),
            Text(
              'تعذّر تحميل الصفحة من الموقع',
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.onCard(isDark),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'تحقق من اتصال الإنترنت ثم أعد المحاولة',
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(
                fontSize: 14,
                height: 1.6,
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
                'إعادة المحاولة',
                style: GoogleFonts.tajawal(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: onLocalFallback,
              child: Text(
                'عرض النسخة المحلية',
                style: GoogleFonts.tajawal(
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
