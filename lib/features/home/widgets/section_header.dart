
import 'package:flutter/material.dart';

import '../../../core/localization/app_localizations.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final VoidCallback onViewAll;
  final bool showViewAll;


  const SectionHeader({
    required this.title,
    required this.count,
    required this.onViewAll,
    this.showViewAll = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            context.tr(title),
            style: theme.textTheme.titleMedium,
          ),
        ),
        Text(
          '$count ${context.tr('tasks')}',
          style: theme.textTheme.bodySmall,
        ),
        TextButton(
          onPressed: onViewAll,
          child: Text(context.tr('View All')),
        ),
      ],
    );
  }
}