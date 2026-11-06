import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';

class TaskPrioritySelector extends StatelessWidget {
  final String selectedPriority;
  final ValueChanged<String> onPriorityChanged;

  const TaskPrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  });

  static const List<String> priorities = [
    'Low',
    'Medium',
    'High',
  ];

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'High':
        return AppColors.highPriority;

      case 'Low':
        return AppColors.lowPriority;

      default:
        return AppColors.mediumPriority;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: priorities.map((priority) {
        final selected = selectedPriority == priority;
        final color = _priorityColor(priority);

        return Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: InkWell(
              onTap: () {
                onPriorityChanged(priority);
              },
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: selected
                      ? color.withValues(alpha: 0.13)
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected
                        ? color
                        : theme.colorScheme.outlineVariant,
                    width: selected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        context.tr(priority),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? color
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}