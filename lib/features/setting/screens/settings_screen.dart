import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_to_do_app/core/widgets/app_snackbar.dart';
import 'package:smart_to_do_app/features/setting/widgets/default_priorityD_dalog.dart';
import 'package:smart_to_do_app/features/setting/widgets/privacy_policy_screen.dart';
import 'package:smart_to_do_app/features/setting/widgets/profile_card.dart';
import 'package:smart_to_do_app/features/setting/widgets/setting_card.dart';
import 'package:smart_to_do_app/features/setting/widgets/setting_switch_tile.dart';
import 'package:smart_to_do_app/features/setting/widgets/settings_footer.dart';
import 'package:smart_to_do_app/features/setting/widgets/settings_language_tile.dart';
import 'package:smart_to_do_app/features/setting/widgets/settings_navigation_tile.dart';
import 'package:smart_to_do_app/features/setting/widgets/settings_section_title.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/theme/theme_provider.dart';
import '../../tasks/controllers/task_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, themeProvider, localeProvider, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  context.tr('Settings'),
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold, fontSize: 26),
                ),
                const SizedBox(height: 6),
                Text(
                  context.tr('Customize your Smart Todo experience'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 28),

                const ProfileCard(),
                const SizedBox(height: 28),

                SettingsSectionTitle(title: context.tr('Appearance')),
                const SizedBox(height: 12),
                SettingsCard(
                  children: [
                    SettingsSwitchTile(
                      icon: Icons.dark_mode_rounded,
                      title: context.tr('Dark Mode'),
                      subtitle: context.tr(
                        'Switch between light and dark theme',
                      ),
                      value: themeProvider.isDarkMode,
                      onChanged: themeProvider.setDarkMode,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SettingsCard(
                  children: [
                    SettingsLanguageTile(
                      languageCode: localeProvider.languageCode,
                      onChanged: localeProvider.setLocale,
                    ),
                  ],
                ),

                const SizedBox(height: 25),
                SettingsSectionTitle(title: context.tr('Preferences')),
                const SizedBox(height: 12),
                SettingsCard(
                  children: [
                    SettingsNavigationTile(
                      icon: Icons.notifications_active_outlined,
                      title: context.tr('Notifications'),
                      subtitle: context.tr('Manage task reminders'),
                      onTap: () => _showComingSoon(context, 'Notifications'),
                    ),
                    const SettingsDivider(),
                    SettingsNavigationTile(
                      icon: Icons.flag_outlined,
                      title: context.tr('Default Priority'),
                      subtitle: context.tr('Choose your default task priority'),
                      onTap: () => _showPriorityDialog(context),
                    ),
                  ],
                ),

                const SizedBox(height: 25),
                SettingsSectionTitle(title: context.tr('Data Management')),
                const SizedBox(height: 12),
                SettingsCard(
                  children: [
                    SettingsNavigationTile(
                      icon: Icons.cleaning_services_outlined,
                      title: context.tr('Clear Completed Tasks'),
                      subtitle: context.tr('Remove all completed tasks'),
                      onTap: () => _showClearTasksDialog(context),
                    ),
                  ],
                ),

                const SizedBox(height: 25),
                SettingsSectionTitle(title: context.tr('About')),
                const SizedBox(height: 12),
                SettingsCard(
                  children: [
                    SettingsNavigationTile(
                      icon: Icons.info_outline_rounded,
                      title: context.tr('About Smart Todo'),
                      subtitle: context.tr('App information and version'),
                      onTap: () => _showAboutDialog(context),
                    ),
                    const SettingsDivider(),
                    SettingsNavigationTile(
                      icon: Icons.privacy_tip_outlined,
                      title: context.tr('Privacy Policy'),
                      subtitle: context.tr('Learn how your data is handled'),
                      onTap: () => _openPrivacyPolicy(context),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
                const SettingsFooter(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPriorityDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => const DefaultPriorityDialog(),
    );
  }

  void _showClearTasksDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(context.tr('Clear Completed Tasks?')),
          content: Text(
            context.tr(
              'Are you sure you want to permanently delete all completed tasks?',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(context.tr('Cancel')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                Navigator.pop(dialogContext);

                try {
                  await context.read<TaskController>().clearCompletedTasks();

                  if (!context.mounted) return;
                  AppSnackBar.show(
                    context,
                    message: context.tr('Completed tasks cleared successfully'),
                    type: SnackBarType.success,
                  );
                } catch (error) {
                  if (!context.mounted) return;
                  AppSnackBar.show(
                    context,
                    message: context.tr('Could not clear completed tasks'),
                    type: SnackBarType.error,
                  );
                }
              },
              child: Text(context.tr('Clear')),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Smart Todo',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.task_alt_rounded,
        size: 40,
        color: AppColors.primary,
      ),
      applicationLegalese: '© 2026 Smart Todo. All rights reserved.',
    );
  }

  void _openPrivacyPolicy(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const PrivacyPolicyScreen()),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    AppSnackBar.show(
      context,
      message: '${context.tr(feature)} ${context.tr('feature coming soon!')}',
      type: SnackBarType.info,
      duration: const Duration(seconds: 3),
    );
  }
}

class SettingsDivider extends StatelessWidget {
  const SettingsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, indent: 70, endIndent: 15);
  }
}
