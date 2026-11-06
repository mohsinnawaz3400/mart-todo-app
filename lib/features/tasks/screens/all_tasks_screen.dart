import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../controllers/task_controller.dart';
import '../controllers/task_filter_state.dart';
import '../models/task_model.dart';
import '../widgets/task_card.dart';
import '../widgets/task_filter_section.dart';
import 'add_task_screen.dart';

class AllTasksScreen extends StatelessWidget {
  const AllTasksScreen({super.key});

  Future<void> _editTask(BuildContext context, TaskModel task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddTaskScreen(task: task)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskController>(
      builder: (context, controller, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: RefreshIndicator(
              color: Theme.of(context).colorScheme.primary,
              onRefresh: controller.loadTasks,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 15),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('All Tasks'),
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            context.tr('Organize and manage your activities.'),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 22),

                          // Search and filters
                          TaskFilterSection(
                            onFilterChanged: () {},
                            onApplyFilters: (query, category, status, sort) {
                              // Filter state is maintained inside section.
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tasks list
                  Consumer<TaskFilterState>(
                    builder: (context, filter, child) {
                      final filteredTasks = controller.filterTasks(
                        query: filter.query,
                        category: filter.category,
                        status: filter.status,
                        sort: filter.sort,
                      );

                      if (controller.isLoading) {
                        return const SliverFillRemaining(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (filteredTasks.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: _EmptyTasks(onClear: filter.clear),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final task = filteredTasks[index];

                            return TaskCard(
                              key: ValueKey(task.id),
                              task: task,
                              onToggle: () => controller.toggleTask(task),
                              onDelete: () => controller.deleteTask(task.id),
                              onEdit: () => _editTask(context, task),
                            );
                          }, childCount: filteredTasks.length),
                        ),
                      );
                    },
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 30)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyTasks extends StatelessWidget {
  final VoidCallback onClear;

  const _EmptyTasks({required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 65,
            color: Theme.of(context).hintColor,
          ),
          const SizedBox(height: 12),
          Text(
            context.tr('No Tasks Found'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            context.tr('Try changing your filters.'),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          TextButton(
            onPressed: onClear,
            child: Text(context.tr('Clear Filters')),
          ),
        ],
      ),
    );
  }
}
