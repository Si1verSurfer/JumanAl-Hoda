import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/haptics/goman_haptics.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/goman_scaffold.dart';
import '../../data/models/worship_item.dart';
import '../providers/worship_provider.dart';

class AllahNameDetailScreen extends ConsumerWidget {
  const AllahNameDetailScreen({
    super.key,
    required this.nameId,
  });

  final String nameId;

  static String routeFor(String nameId) => '/adhkar/allah-name/$nameId';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final items = ref.watch(worshipItemsProvider('allah_names'));
    final matches = items.where((e) => e.id == nameId);
    if (matches.isEmpty) {
      return const GomanScaffold(
        title: 'غير موجود',
        body: Center(child: Text('تعذّر تحميل هذا الاسم')),
      );
    }
    final item = matches.first;

    final favorites = ref.watch(worshipFavoritesProvider);
    final isFavorite = favorites.contains(item.id);
    final titleColor = isDark ? AppColors.surfaceLight : AppColors.primary;

    return GomanScaffold(
      title: item.title,
      actions: [
          IconButton(
            tooltip: isFavorite ? 'إزالة من أذكاري' : 'حفظ في أذكاري',
            onPressed: () {
              GomanHaptics.tap();
              ref.read(worshipFavoritesProvider.notifier).toggle(item.id);
            },
            icon: Icon(
              isFavorite ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
              color: isFavorite ? AppColors.secondary : null,
            ),
          ),
          IconButton(
            tooltip: 'مشاركة',
            onPressed: () => _share(item),
            icon: const Icon(Icons.ios_share_rounded),
          ),
      ],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        children: [
          _HeroCard(item: item, isDark: isDark),
          const SizedBox(height: 16),
          _SectionCard(
            isDark: isDark,
            icon: Icons.auto_stories_rounded,
            title: 'المعنى والشرح',
            body: item.body,
            bodyStyle: GoogleFonts.notoNaskhArabic(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              height: 1.85,
              color: titleColor.withValues(alpha: 0.92),
            ),
          ),
          if (item.quranReference != null) ...[
            const SizedBox(height: 12),
            _SectionCard(
              isDark: isDark,
              icon: Icons.menu_book_rounded,
              title: 'من القرآن الكريم',
              body: item.quranReference!,
              bodyStyle: GoogleFonts.notoNaskhArabic(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 1.8,
                color: AppColors.secondary,
              ),
            ),
          ],
          if (item.benefit != null) ...[
            const SizedBox(height: 12),
            _SectionCard(
              isDark: isDark,
              icon: Icons.favorite_rounded,
              title: 'الفضل والثواب',
              body: item.benefit!,
              bodyStyle: GoogleFonts.notoNaskhArabic(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                height: 1.8,
                color: titleColor.withValues(alpha: 0.9),
              ),
            ),
          ],
          if (item.invocation != null) ...[
            const SizedBox(height: 12),
            _SectionCard(
              isDark: isDark,
              icon: Icons.back_hand_rounded,
              title: 'الدعاء بهذا الاسم',
              body: item.invocation!,
              bodyStyle: GoogleFonts.notoNaskhArabic(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 1.85,
                color: titleColor,
              ),
            ),
          ],
          if (item.reference != null) ...[
            const SizedBox(height: 12),
            Text(
              item.reference!,
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary.withValues(alpha: 0.85),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _share(WorshipItem item) async {
    GomanHaptics.tap();
    final buffer = StringBuffer()
      ..writeln(item.title)
      ..writeln()
      ..writeln(item.body);
    if (item.quranReference != null) {
      buffer
        ..writeln()
        ..writeln(item.quranReference);
    }
    if (item.invocation != null) {
      buffer
        ..writeln()
        ..writeln(item.invocation);
    }
    await Share.share(buffer.toString().trim());
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.item,
    required this.isDark,
  });

  final WorshipItem item;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        gradient: AppColors.primaryBrandGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow(isDark: isDark),
      ),
      child: Column(
        children: [
          if (item.repeatHint != null)
            Text(
              'الاسم ${item.repeatHint}',
              style: GoogleFonts.tajawal(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.onPrimary.withValues(alpha: 0.75),
              ),
            ),
          const SizedBox(height: 8),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoNaskhArabic(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              height: 1.25,
              color: AppColors.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.isDark,
    required this.icon,
    required this.title,
    required this.body,
    required this.bodyStyle,
  });

  final bool isDark;
  final IconData icon;
  final String title;
  final String body;
  final TextStyle bodyStyle;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? AppColors.surfaceLight : AppColors.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.cardSurface(isDark),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: isDark ? 0.14 : 0.07),
        ),
        boxShadow: isDark ? null : AppColors.cardShadow(isDark: false),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: AppColors.secondary),
              const SizedBox(width: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.tajawal(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: titleColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            body,
            textAlign: TextAlign.center,
            style: bodyStyle,
          ),
        ],
      ),
    );
  }
}
