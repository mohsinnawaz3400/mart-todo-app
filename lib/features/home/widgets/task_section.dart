import 'package:flutter/material.dart';
import 'package:smart_to_do_app/features/home/widgets/section_header.dart';
import 'package:smart_to_do_app/features/tasks/controllers/task_controller.dart';
import 'package:smart_to_do_app/features/tasks/models/task_model.dart';
import 'package:smart_to_do_app/features/tasks/screens/add_task_screen.dart';
import 'package:smart_to_do_app/features/tasks/widgets/task_card.dart';

import 'empty_task.dart';

class TaskSection extends StatelessWidget {
  final String title;
  final List<TaskModel> tasks;
  final TaskController controller;
  final VoidCallback onViewAll;
  final bool isLoading;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptySubtitle;
  final int maxItems;

  const TaskSection({
    required this.title,
    required this.tasks,
    required this.controller,
    required this.onViewAll,
    this.isLoading = false,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptySubtitle,
    this.maxItems = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          count: tasks.length,
          onViewAll: onViewAll,
          showViewAll: tasks.length > maxItems,
        ),

        const SizedBox(height: 12),

        if (isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          )
        else if (tasks.isEmpty)
          EmptyTaskState(
            icon: emptyIcon,
            title: emptyTitle,
            subtitle: emptySubtitle,
          )
        else
          ...tasks.take(maxItems).map(
                (task) => TaskCard(
              key: ValueKey(task.id),
              task: task,
              onToggle: () => controller.toggleTask(task),
              onDelete: () => controller.deleteTask(task.id),
              onEdit: () => _openEditTask(context, task),
            ),
          ),
      ],
    );
  }

  void _openEditTask(BuildContext context, TaskModel task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddTaskScreen(task: task),
      ),
    );
  }
}