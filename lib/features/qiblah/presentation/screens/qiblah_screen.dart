import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/haptics/goman_haptics.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/goman_button.dart';
import '../../../../core/widgets/goman_scaffold.dart';
import '../../../prayer_times/presentation/providers/prayer_location_provider.dart';
import '../../../prayer_times/presentation/widgets/prayer_location_sheet.dart';
import '../../utils/qiblah_bearing.dart';
import '../widgets/qiblah_compass_dial.dart';

class QiblahScreen extends HookConsumerWidget {
  const QiblahScreen({super.key});

  static const route = '/qiblah';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locationState = ref.watch(prayerLocationProvider);
    final heading = useState<double?>(null);
    final compassAvailable = useState<bool?>(null);
    final wasAligned = useRef(false);

    useEffect(() {
      final subscription = FlutterCompass.events?.listen((event) {
        final next = event.heading;
        if (next == null) {
          compassAvailable.value = false;
          return;
        }
        compassAvailable.value = true;
        heading.value = next;
      });
      if (subscription == null) {
        compassAvailable.value = false;
      }
      return subscription?.cancel;
    }, const []);

    final location = locationState is PrayerLocationReady
        ? locationState.location
        : null;

    final qiblahBearing = location == null
        ? null
        : qiblahBearingDegrees(
            latitude: location.latitude,
            longitude: location.longitude,
          );

    final isAligned = heading.value != null &&
        qiblahBearing != null &&
        _alignmentDelta(heading.value!, qiblahBearing) < 8;

    useEffect(() {
      if (isAligned && !wasAligned.value) {
        GomanHaptics.confirm();
      }
      wasAligned.value = isAligned;
      return null;
    }, [isAligned]);

    return GomanScaffold(
      title: AppStrings.qiblahTitle,
      body: Container(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            if (locationState is PrayerLocationLoading)
              const _StatusCard(
                icon: Icons.location_searching_rounded,
                message: AppStrings.prayerLoadingLocation,
              )
            else if (locationState is PrayerLocationError)
              _StatusCard(
                icon: Icons.location_off_rounded,
                message: locationState.message,
                actionLabel: AppStrings.prayerChangeLocation,
                onAction: () => showPrayerLocationSheet(context, ref),
              )
            else if (location != null) ...[
              Center(
                child: Text(
                  location.label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tajawal(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary.withValues(alpha: 0.85),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (qiblahBearing != null)
                Center(
                  child: Text(
                    '${AppStrings.qiblahBearingLabel} ${_formatBearing(qiblahBearing)}°',
                    style: GoogleFonts.tajawal(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: (isDark
                              ? AppColors.surfaceLight
                              : AppColors.primary)
                          .withValues(alpha: 0.55),
                    ),
                  ),
                ),
            ],
            const SizedBox(height: 20),
            if (compassAvailable.value == false)
              _StatusCard(
                icon: Icons.explore_off_rounded,
                message: AppStrings.qiblahCompassUnavailable,
              )
            else if (location != null && qiblahBearing != null)
              QiblahCompassDial(
                headingDegrees: heading.value,
                qiblahDegrees: qiblahBearing,
                isAligned: isAligned,
                isDark: isDark,
              ),
            const SizedBox(height: 24),
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isAligned
                      ? const Color(0xFF2E7D32).withValues(alpha: 0.12)
                      : AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isAligned
                      ? AppStrings.qiblahAligned
                      : AppStrings.qiblahInstruction,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoNaskhArabic(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                    color: isAligned
                        ? const Color(0xFF2E7D32)
                        : (isDark
                            ? AppColors.surfaceLight
                            : AppColors.primary),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GomanButton(
              label: AppStrings.prayerChangeLocation,
              variant: GomanButtonVariant.outlined,
              onPressed: () => showPrayerLocationSheet(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  double _alignmentDelta(double heading, double qiblah) {
    final delta = (qiblah - heading).abs() % 360;
    return delta > 180 ? 360 - delta : delta;
  }

  String _formatBearing(double bearing) => bearing.round().toString();
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardSurface(isDark),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: isDark ? 0.14 : 0.06),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: AppColors.secondary),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.tajawal(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.45,
              color: isDark ? AppColors.surfaceLight : AppColors.primary,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 12),
            GomanButton(
              label: actionLabel!,
              onPressed: onAction,
            ),
          ],
        ],
      ),
    );
  }
}
