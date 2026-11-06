import 'package:flutter/material.dart';
import 'package:smart_to_do_app/core/localization/app_localizations.dart';

class EmptyTaskState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const EmptyTaskState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              Icon(
                icon,
                size: 40,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 10),
              Text(
                context.tr(title),
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 5),
              Text(
                context.tr(subtitle),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}