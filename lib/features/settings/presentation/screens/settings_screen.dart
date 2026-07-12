import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/providers/prayer_time_format_provider.dart';
import '../../../../app/providers/theme_mode_provider.dart';
import '../../../../core/constants/app_contact.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/haptics/goman_haptics.dart';
import '../../../../core/providers/app_version_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/goman_scaffold.dart';
import '../../../prayer_times/presentation/widgets/prayer_notification_settings_sheet.dart';
import '../../data/legal_documents.dart';
import '../widgets/settings_widgets.dart';
import 'legal_document_screen.dart';
import 'legal_web_document_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode =
        ref.watch(themeModeProvider).valueOrNull ?? ThemeMode.system;
    final is24Hour =
        ref.watch(prayerTimeFormatProvider).valueOrNull ?? false;
    final appVersion = ref.watch(appVersionProvider).valueOrNull ?? '...';
    final background =
        isDark ? AppColors.surfaceDark : AppColors.surfaceLight;

    return GomanScaffold(
      title: AppStrings.settings,
      body: ColoredBox(
        color: background,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            const SettingsHeroHeader(),
            SettingsSectionHeader(
              title: AppStrings.settingsAppearance,
              icon: Icons.palette_outlined,
            ),
            SettingsCard(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
                    child: Row(
                      children: [
                        SettingsChoiceChip(
                          label: 'تلقائي',
                          icon: Icons.brightness_auto_rounded,
                          selected: themeMode == ThemeMode.system,
                          onTap: () {
                            GomanHaptics.tap();
                            ref
                                .read(themeModeProvider.notifier)
                                .setThemeMode(ThemeMode.system);
                          },
                        ),
                        const SizedBox(width: 8),
                        SettingsChoiceChip(
                          label: 'فاتح',
                          icon: Icons.light_mode_rounded,
                          selected: themeMode == ThemeMode.light,
                          onTap: () {
                            GomanHaptics.tap();
                            ref
                                .read(themeModeProvider.notifier)
                                .setThemeMode(ThemeMode.light);
                          },
                        ),
                        const SizedBox(width: 8),
                        SettingsChoiceChip(
                          label: 'داكن',
                          icon: Icons.dark_mode_rounded,
                          selected: themeMode == ThemeMode.dark,
                          onTap: () {
                            GomanHaptics.tap();
                            ref
                                .read(themeModeProvider.notifier)
                                .setThemeMode(ThemeMode.dark);
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, indent: 14, endIndent: 14),
                  SettingsTile(
                    title: AppStrings.settingsTimeFormat12,
                    leading: const SettingsIconBadge(icon: Icons.schedule_rounded),
                    trailing: SettingsCheckmark(selected: !is24Hour),
                    onTap: () {
                      GomanHaptics.tap();
                      ref.read(prayerTimeFormatProvider.notifier).set12Hour();
                    },
                  ),
                  SettingsTile(
                    title: AppStrings.settingsTimeFormat24,
                    leading: const SettingsIconBadge(icon: Icons.access_time_rounded),
                    trailing: SettingsCheckmark(selected: is24Hour),
                    onTap: () {
                      GomanHaptics.tap();
                      ref.read(prayerTimeFormatProvider.notifier).set24Hour();
                    },
                    showDivider: false,
                  ),
                ],
              ),
            ),
            SettingsSectionHeader(
              title: AppStrings.settingsNotifications,
              icon: Icons.notifications_active_outlined,
            ),
            SettingsCard(
              child: SettingsTile(
                title: AppStrings.settingsPrayerNotifications,
                subtitle: AppStrings.settingsPrayerNotificationsHint,
                leading: const SettingsIconBadge(
                  icon: Icons.notifications_active_rounded,
                  highlight: true,
                ),
                onTap: () => showPrayerNotificationSettingsSheet(context, ref),
                showDivider: false,
              ),
            ),
            SettingsSectionHeader(
              title: AppStrings.settingsLegal,
              icon: Icons.gavel_rounded,
            ),
            SettingsCard(
              child: Column(
                children: [
                  SettingsTile(
                    title: AppStrings.settingsPrivacyPolicy,
                    leading: const SettingsIconBadge(icon: Icons.privacy_tip_outlined),
                    onTap: () => _openLegal(context, LegalDocumentKind.privacyPolicy),
                  ),
                  SettingsTile(
                    title: AppStrings.settingsTerms,
                    leading: const SettingsIconBadge(icon: Icons.description_outlined),
                    onTap: () =>
                        _openLegal(context, LegalDocumentKind.termsAndConditions),
                  ),
                  SettingsTile(
                    title: AppStrings.settingsAbout,
                    leading: const SettingsIconBadge(icon: Icons.info_outline_rounded),
                    onTap: () => _openLegal(context, LegalDocumentKind.about),
                    showDivider: false,
                  ),
                ],
              ),
            ),
            SettingsSectionHeader(
              title: AppStrings.settingsSupport,
              icon: Icons.support_agent_rounded,
            ),
            SettingsCard(
              child: SettingsTile(
                title: AppStrings.settingsContact,
                subtitle: AppContact.supportEmail,
                leading: const SettingsIconBadge(icon: Icons.mail_outline_rounded),
                onTap: () => _copyEmail(context),
                showDivider: false,
              ),
            ),
            const SizedBox(height: 28),
            SettingsVersionFooter(
              version: appVersion,
              footer: AppStrings.settingsFooter,
            ),
          ],
        ),
      ),
    );
  }

  void _openLegal(BuildContext context, LegalDocumentKind kind) {
    final screen = switch (kind) {
      LegalDocumentKind.privacyPolicy ||
      LegalDocumentKind.termsAndConditions =>
        LegalWebDocumentScreen(kind: kind),
      LegalDocumentKind.about => LegalDocumentScreen(kind: kind),
    };

    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) => screen),
    );
  }

  Future<void> _copyEmail(BuildContext context) async {
    GomanHaptics.tap();
    await Clipboard.setData(
      const ClipboardData(text: AppContact.supportEmail),
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppStrings.settingsEmailCopied,
          style: GoogleFonts.tajawal(fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
