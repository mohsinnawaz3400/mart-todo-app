
import 'package:flutter/material.dart';
import 'package:smart_to_do_app/core/constants/app_colors.dart';
import 'package:smart_to_do_app/features/setting/screens/settings_screen.dart';
import 'package:smart_to_do_app/features/setting/widgets/settingsIcon_container.dart';

class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: SettingsIconContainer(icon: icon),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      trailing: Switch.adaptive(
        value: value,
        activeTrackColor: AppColors.primary,
        onChanged: onChanged,
      ),
    );
  }
}