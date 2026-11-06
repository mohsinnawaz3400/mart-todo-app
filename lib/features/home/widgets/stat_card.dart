import 'package:flutter/material.dart';
import 'package:smart_to_do_app/core/localization/app_localizations.dart';

class StatCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const StatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 5,
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.tr(title),
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}