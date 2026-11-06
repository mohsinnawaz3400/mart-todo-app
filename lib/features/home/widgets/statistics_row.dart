import 'package:flutter/material.dart';
import 'package:smart_to_do_app/core/localization/app_localizations.dart';
import 'package:smart_to_do_app/features/home/widgets/stat_card.dart';

class StatisticsRow extends StatelessWidget {
  final int total;
  final int completed;
  final int overdue;

  const StatisticsRow({
    required this.total,
    required this.completed,
    required this.overdue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: context.tr('Total'),
            count: total,
            icon: Icons.assignment_outlined,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatCard(
            title: context.tr('Completed'),
            count: completed,
            icon: Icons.check_circle_outline,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatCard(
            title: context.tr('Overdue'),
            count: overdue,
            icon: Icons.warning_amber_rounded,
            color: Colors.redAccent,
          ),
        ),
      ],
    );
  }
}