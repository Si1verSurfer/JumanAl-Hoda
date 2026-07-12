import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/constants/prayer_arabic_labels.dart';
import '../../../../core/constants/app_nav_constants.dart';
import '../../../../core/haptics/goman_haptics.dart';
import '../../../../core/navigation/goman_navigation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/goman_search_field.dart';
import '../../data/models/prayer_location.dart';
import '../providers/prayer_location_provider.dart';

Future<void> showPrayerLocationSheet(BuildContext context, WidgetRef ref) {
  return showGomanModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const PrayerLocationSheet(),
  );
}

class PrayerLocationSheet extends HookConsumerWidget {
  const PrayerLocationSheet({super.key});

  static const double _baseSheetFactor = 0.72;
  static const double _minSheetFactor = 0.46;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = useTextEditingController();
    final focusNode = useFocusNode();
    final searchResults = useState<List<PopularCity>>(popularPrayerCities);
    final isSearching = useState(false);
    final query = useState('');
    final titleColor = isDark ? AppColors.surfaceLight : AppColors.primary;
    final sheetColor = AppColors.cardSurface(isDark);
    final sheetBottomInset = AppNavConstants.modalSheetBottomInset(context);

    final viewInsets = MediaQuery.viewInsetsOf(context);
    final screenHeight = MediaQuery.sizeOf(context).height;
    final keyboardOpen = viewInsets.bottom > 0;
    final sheetHeight = (screenHeight * _baseSheetFactor - viewInsets.bottom)
        .clamp(screenHeight * _minSheetFactor, screenHeight * _baseSheetFactor);

    useEffect(() {
      Timer? debounce;
      void onTextChanged() {
        final value = controller.text;
        query.value = value;
        debounce?.cancel();
        debounce = Timer(const Duration(milliseconds: 350), () async {
          final trimmed = value.trim();
          if (trimmed.isEmpty) {
            searchResults.value = popularPrayerCities;
            isSearching.value = false;
            return;
          }
          isSearching.value = true;
          final results = await searchCities(trimmed);
          if (context.mounted && controller.text.trim() == trimmed) {
            searchResults.value = results;
            isSearching.value = false;
          }
        });
      }

      controller.addListener(onTextChanged);
      return () {
        debounce?.cancel();
        controller.removeListener(onTextChanged);
      };
    }, [controller]);

    Future<void> selectCity(PopularCity city) async {
      focusNode.unfocus();
      await ref.read(prayerLocationProvider.notifier).setManualLocation(
            latitude: city.latitude,
            longitude: city.longitude,
            label: city.label,
            timezoneId: city.timezoneId,
            country: city.country,
          );
      if (context.mounted) Navigator.of(context).pop();
    }

    final sectionTitle = query.value.trim().isEmpty
        ? PrayerArabicLabels.popularCities
        : PrayerArabicLabels.searchCity;

    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          height: sheetHeight,
          margin: EdgeInsets.fromLTRB(12, 0, 12, sheetBottomInset),
          decoration: BoxDecoration(
            color: sheetColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppColors.cardShadow(isDark: isDark),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: titleColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      PrayerArabicLabels.changeLocation,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoNaskhArabic(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 14),
                    GomanSearchField(
                      controller: controller,
                      focusNode: focusNode,
                      isDark: isDark,
                      hintText: PrayerArabicLabels.searchCity,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 46,
                      child: FilledButton.icon(
                        onPressed: () async {
                          focusNode.unfocus();
                          await ref
                              .read(prayerLocationProvider.notifier)
                              .refreshFromGps();
                          if (context.mounted) Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.my_location_rounded, size: 18),
                        label: Text(
                          PrayerArabicLabels.useMyLocation,
                          style:
                              GoogleFonts.tajawal(fontWeight: FontWeight.w700),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: AppColors.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    sectionTitle,
                    style: GoogleFonts.tajawal(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _CityResultsList(
                  isSearching: isSearching.value,
                  cities: searchResults.value,
                  isDark: isDark,
                  titleColor: titleColor,
                  keyboardOpen: keyboardOpen,
                  bottomInset: sheetBottomInset,
                  onSelect: selectCity,
                ),
              ),
              SizedBox(height: keyboardOpen ? 6 : 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _CityResultsList extends StatelessWidget {
  const _CityResultsList({
    required this.isSearching,
    required this.cities,
    required this.isDark,
    required this.titleColor,
    required this.keyboardOpen,
    required this.bottomInset,
    required this.onSelect,
  });

  final bool isSearching;
  final List<PopularCity> cities;
  final bool isDark;
  final Color titleColor;
  final bool keyboardOpen;
  final double bottomInset;
  final ValueChanged<PopularCity> onSelect;

  @override
  Widget build(BuildContext context) {
    if (isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (cities.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'لا توجد نتائج',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoNaskhArabic(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.secondary,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(20, 0, 20, keyboardOpen ? 8 : 16),
      itemCount: cities.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final city = cities[index];
        return Material(
          color: isDark
              ? AppColors.surfaceDark
              : AppColors.surfaceElevatedLight,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: (() => onSelect(city)).withHaptic(GomanHapticKind.confirm),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.location_city_rounded,
                      size: 18,
                      color: AppColors.secondary.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      city.label,
                      style: GoogleFonts.notoNaskhArabic(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_left_rounded,
                    color: titleColor.withValues(alpha: 0.35),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
