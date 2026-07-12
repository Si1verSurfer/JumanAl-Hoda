import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/goman_scaffold.dart';
import '../../data/legal_document_model.dart';
import '../../data/legal_documents.dart';

class LegalDocumentScreen extends StatelessWidget {
  const LegalDocumentScreen({super.key, required this.kind});

  final LegalDocumentKind kind;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = AppColors.onCard(isDark);
    final doc = LegalDocuments.document(kind);

    return GomanScaffold(
      title: doc.title,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _IntroCard(text: doc.intro, textColor: textColor, isDark: isDark),
            const SizedBox(height: 12),
            Text(
              'آخر تحديث: ${doc.lastUpdated}',
              textAlign: TextAlign.right,
              style: GoogleFonts.tajawal(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: textColor.withValues(alpha: 0.45),
              ),
            ),
            const SizedBox(height: 20),
            ...doc.sections.map(
              (section) => _SectionCard(
                section: section,
                textColor: textColor,
                isDark: isDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({
    required this.text,
    required this.textColor,
    required this.isDark,
  });

  final String text;
  final Color textColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: isDark ? 0.12 : 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.14),
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: GoogleFonts.tajawal(
          fontSize: 15,
          height: 1.8,
          fontWeight: FontWeight.w500,
          color: textColor.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.section,
    required this.textColor,
    required this.isDark,
  });

  final LegalSection section;
  final Color textColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.subtleCardSurface(isDark),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: textColor.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: isDark ? 0.08 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            section.title,
            textAlign: TextAlign.right,
            style: GoogleFonts.notoNaskhArabic(
              fontSize: 17,
              height: 1.5,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          ...section.paragraphs.map(
            (paragraph) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                paragraph,
                textAlign: TextAlign.right,
                style: GoogleFonts.tajawal(
                  fontSize: 14.5,
                  height: 1.75,
                  fontWeight: FontWeight.w500,
                  color: textColor.withValues(alpha: 0.82),
                ),
              ),
            ),
          ),
          if (section.bullets.isNotEmpty) ...[
            const SizedBox(height: 4),
            ...section.bullets.map(
              (bullet) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 9, left: 10),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        bullet,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.tajawal(
                          fontSize: 14,
                          height: 1.7,
                          fontWeight: FontWeight.w500,
                          color: textColor.withValues(alpha: 0.78),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
