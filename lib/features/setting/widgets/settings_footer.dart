
import 'package:flutter/material.dart';
import 'package:smart_to_do_app/core/constants/app_colors.dart';
import 'package:smart_to_do_app/core/localization/app_localizations.dart';

class SettingsFooter extends StatelessWidget {
  const SettingsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.task_alt_rounded,
            color: AppColors.primary.withValues(alpha: 0.7),
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            context.tr('Smart Todo v1.0.0'),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            context.tr('Stay organized. Stay productive.'),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}