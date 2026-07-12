import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/goman_scaffold.dart';
import '../providers/worship_provider.dart';
import '../theme/worship_page_style.dart';
import '../widgets/worship_item_card.dart';

class WorshipCategoryScreen extends ConsumerWidget {
  const WorshipCategoryScreen({
    super.key,
    required this.categoryId,
  });

  final String categoryId;

  static String routeFor(String categoryId) =>
      '${Routes.adhkar}/category/$categoryId';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final category = ref.watch(worshipCategoryProvider(categoryId));
    final items = ref.watch(worshipItemsProvider(categoryId));
    if (category == null) {
      return GomanScaffold(
        title: 'غير موجود',
        body: const Center(child: Text('تعذّر تحميل هذا القسم')),
      );
    }

    return GomanScaffold(
      title: category.title,
      body: Container(
        color: WorshipPageStyle.background(isDark),
        child: items.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.bookmark_border_rounded,
                        size: 42,
                        color: category.accentColor.withValues(alpha: 0.7),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        categoryId == 'my_adhkar'
                            ? 'لا توجد أذكار محفوظة بعد'
                            : 'لا يوجد محتوى في هذا القسم بعد',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoNaskhArabic(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.surfaceLight
                              : AppColors.primary,
                        ),
                      ),
                      if (categoryId == 'my_adhkar') ...[
                        const SizedBox(height: 8),
                        Text(
                          'اضغط على أيقونة الحفظ في أي ذكر لإضافته هنا',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.tajawal(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return WorshipItemCard(
                    item: items[index],
                    isDark: isDark,
                    accentColor: category.accentColor,
                  );
                },
              ),
      ),
    );
  }
}
