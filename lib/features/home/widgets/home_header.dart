import 'package:flutter/material.dart';
import 'package:smart_to_do_app/core/localization/app_localizations.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('Hello! 👋'),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                context.tr("Let's make today productive."),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        CircleAvatar(
          backgroundColor: theme.colorScheme.surface,
          child: Icon(
            Icons.person_outline,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}