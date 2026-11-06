import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';

class TaskCategorySelector extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  const TaskCategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  static const List<String> categories = [
    'Work',
    'Personal',
    'Shopping',
    'Fitness',
    'Idea',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Wrap(
      spacing: 9,
      runSpacing: 9,
      children: categories.map((category) {
        final selected = selectedCategory == category;

        return ChoiceChip(
          label: Text(context.tr(category)),
          selected: selected,
          showCheckmark: false,
          selectedColor: primary,
          backgroundColor:
          theme.colorScheme.surfaceContainerHighest,
          onSelected: (value) {
            if (value) {
              onCategoryChanged(category);
            }
          },
          labelStyle: TextStyle(
            color: selected
                ? Colors.white
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        );
      }).toList(),
    );
  }
}