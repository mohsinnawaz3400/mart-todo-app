
import 'package:flutter/material.dart';
import 'package:smart_to_do_app/core/constants/app_colors.dart';
import 'package:smart_to_do_app/core/localization/app_localizations.dart';

class OverallProgressCard extends StatelessWidget {
  const OverallProgressCard({
    super.key,
    required this.completed,
    required this.total,
    required this.progress,
    required this.blue,
  });

  final int completed;
  final int total;
  final double progress;
  final Color blue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  context.tr('Overall Progress'),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: TextStyle(
                  color: blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              color: blue,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$completed ${context.tr('out of')} $total '
                '${context.tr('tasks completed')}',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}