
import 'package:flutter/material.dart';
import 'package:smart_to_do_app/features/setting/screens/settings_screen.dart';
import 'package:smart_to_do_app/features/setting/widgets/settingsIcon_container.dart';

class SettingsNavigationTile extends StatelessWidget {
  const SettingsNavigationTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      onTap: onTap,
      leading: SettingsIconContainer(icon: icon),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
    );
  }
}