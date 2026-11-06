import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/localization/app_localizations.dart';
import '../models/task_model.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  String formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return DateFormat('dd MMM yyyy').format(date);
  }

  String formatDateTime(DateTime? date) {
    if (date == null) return 'Not set';
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('Task Details')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.task_alt,
                        color: theme.colorScheme.primary,
                        size: 28,
                      ),
                      const Spacer(),
                      Chip(
                        label: Text(
                          context.tr(
                            task.isCompleted ? 'Completed' : 'Pending',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    task.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    task.description.isEmpty
                        ? context.tr('No description available')
                        : task.description,
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Text(
              context.tr('Task Information'),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            _detailTile(
              icon: Icons.category_outlined,
              title: context.tr('Category'),
              value: context.tr(task.category),
            ),
            _detailTile(
              icon: Icons.flag_outlined,
              title: context.tr('Priority'),
              value: context.tr(task.priority),
            ),
            _detailTile(
              icon: Icons.calendar_month_outlined,
              title: context.tr('Due Date'),
              value: formatDate(task.dueDate),
            ),
            _detailTile(
              icon: Icons.alarm_outlined,
              title: context.tr('Reminder'),
              value: formatDateTime(task.reminderAt),
            ),
            _detailTile(
              icon: Icons.access_time,
              title: context.tr('Created At'),
              value: formatDateTime(task.createdAt),
            ),
            _detailTile(
              icon: Icons.update,
              title: context.tr('Last Updated'),
              value: formatDateTime(task.updatedAt),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onToggle,
                icon: Icon(
                  task.isCompleted ? Icons.undo : Icons.check_circle_outline,
                ),
                label: Text(
                  context.tr(
                    task.isCompleted ? 'Mark as Pending' : 'Mark as Completed',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                    label: Text(context.tr('Edit')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                    label: Text(context.tr('Delete')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ),

              ],
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  // Reusable Detail Tile
  Widget _detailTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),

      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}
