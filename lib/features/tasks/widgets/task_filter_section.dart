import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/app_localizations.dart';
import '../controllers/task_controller.dart';
import '../controllers/task_filter_state.dart';

class TaskFilterSection extends StatelessWidget {
  final VoidCallback onFilterChanged;

  final Function(
      String,
      String,
      String,
      TaskSort,
      ) onApplyFilters;

  const TaskFilterSection({
    super.key,
    required this.onFilterChanged,
    required this.onApplyFilters,
  });

  static const List<String> categories = [
    'All',
    'Work',
    'Personal',
    'Shopping',
    'Fitness',
    'Idea',
  ];

  static const List<String> statuses = [
    'All',
    'Pending',
    'Completed',
    'Overdue',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskFilterState>(
      builder: (context, filter, child) {
        final theme = Theme.of(context);
        final colors = theme.colorScheme;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search
            TextField(
              onChanged: filter.setQuery,
              decoration: InputDecoration(
                hintText: context.tr('Search by task title...'),
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: filter.query.isNotEmpty
                    ? IconButton(
                  onPressed: () => filter.setQuery(''),
                  icon: const Icon(Icons.close),
                )
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            Text(context.tr('Categories'),
                  style: theme.textTheme.titleSmall,
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) =>
                const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final selected = filter.category == category;

                  return ChoiceChip(
                    label: Text(context.tr(category)),
                    selected: selected,
                    onSelected: (_) {
                      filter.setCategory(category);
                    },
                    showCheckmark: false,
                    selectedColor: colors.primary,
                    backgroundColor: theme.cardTheme.color,
                    labelStyle: TextStyle(
                      color: selected
                          ? colors.onPrimary
                          : theme.textTheme.bodyMedium?.color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 22),

            // Status filters
            Row(
              children: statuses.map((status) {
                final selected = filter.status == status;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => filter.setStatus(status),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? colors.primary
                            : theme.cardTheme.color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        context.tr(status),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? colors.onPrimary
                              : theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 22),

            // Sorting
            Row(
              children: [
                Expanded(
                  child: Text(context.tr('Your Tasks'),
                  style: theme.textTheme.titleMedium,
                  ),
                ),
                PopupMenuButton<TaskSort>(
                  initialValue: filter.sort,
                  icon: Icon(
                    Icons.sort_rounded,
                    color: colors.primary,
                  ),
                  onSelected: filter.setSort,
                  itemBuilder: (context) => [
                    _sortItem(context, TaskSort.dueDate, 'Due Date'),
                    _sortItem(context, TaskSort.newest, 'Newest First'),
                    _sortItem(context, TaskSort.oldest, 'Oldest First'),
                    _sortItem(context, TaskSort.priority, 'Priority'),
                    _sortItem(context, TaskSort.titleAZ, 'Title A - Z'),
                    _sortItem(context, TaskSort.titleZA, 'Title Z - A'),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  PopupMenuItem<TaskSort> _sortItem(
      BuildContext context,
      TaskSort value,
      String label,
      ) {
    return PopupMenuItem(
      value: value,
      child: Text(context.tr(label)),
    );
  }
}
