
import 'package:flutter/material.dart';
import 'package:smart_to_do_app/core/localization/app_localizations.dart';
import 'package:smart_to_do_app/features/setting/widgets/settingsIcon_container.dart';

class SettingsLanguageTile extends StatelessWidget {
  const SettingsLanguageTile({
    super.key,
    required this.languageCode,
    required this.onChanged,
  });

  final String languageCode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: const SettingsIconContainer(icon: Icons.language_rounded),
      title: Text(
        context.tr('Language'),
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        context.tr('Choose your preferred language'),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: const ['en', 'ur', 'ar'].contains(languageCode)
              ? languageCode
              : 'en',
          items: [
            DropdownMenuItem(
              value: 'en',
              child: Text(context.tr('English')),
            ),
            DropdownMenuItem(
              value: 'ur',
              child: Text(context.tr('Urdu')),
            ),
            DropdownMenuItem(
              value: 'ar',
              child: Text(context.tr('Arabic')),
            ),
          ],
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ),
    );
  }
}

