
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:smart_to_do_app/core/widgets/app_ad_banner.dart';
import 'package:smart_to_do_app/features/home/widgets/delete_card.dart';
import 'package:smart_to_do_app/features/home/widgets/home_header.dart';
import 'package:smart_to_do_app/features/home/widgets/progress_card.dart';
import 'package:smart_to_do_app/features/home/widgets/statistics_row.dart';
import 'package:smart_to_do_app/features/home/widgets/task_section.dart';

import '../../../core/localization/app_localizations.dart';
import '../../tasks/controllers/task_controller.dart';
import '../../tasks/screens/add_task_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onViewAll;

  const HomeScreen({
    super.key,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskController>(
      builder: (context, controller, child) {
        final today = controller.todayTasks;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [

                // TOP BANNER AD
                const AppAdBanner(),

                // HOME SCREEN CONTENT
                Expanded(
                  child: RefreshIndicator(
                    color: Theme.of(context).colorScheme.primary,
                    onRefresh: controller.loadTasks,
                    child: ListView(
                      physics:
                      const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      children: [

                        // HOME HEADER
                        const HomeHeader(),

                        const SizedBox(height: 23),

                        // DATE CARD
                        const DateCard(),

                        const SizedBox(height: 20),

                        // PROGRESS CARD
                        ProgressCard(
                          completed: controller.completedTasks,
                          total: controller.totalTasks,
                          pending: controller.pendingTasks,
                          percentage:
                          controller.completionPercentage,
                        ),

                        const SizedBox(height: 23),

                        // STATISTICS
                        StatisticsRow(
                          total: controller.totalTasks,
                          completed: controller.completedTasks,
                          overdue: controller.overdueTasks,
                        ),

                        const SizedBox(height: 27),

                        // TODAY'S TASKS
                        TaskSection(
                          title: context.tr("Today's Tasks"),
                          tasks: today,
                          controller: controller,
                          onViewAll: onViewAll,
                          isLoading: controller.isLoading,
                          emptyIcon: Icons.today_outlined,
                          emptyTitle:
                          context.tr('No tasks for today'),
                          emptySubtitle: context.tr(
                            'Enjoy your free time or add a new task.',
                          ),
                          maxItems: 4,
                        ),

                        const SizedBox(height: 22),

                        // VIEW ALL TASKS
                        Center(
                          child: TextButton(
                            onPressed: onViewAll,
                            child: Text(
                              context.tr('View All Tasks →'),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // BOTTOM BANNER AD
                const AppAdBanner(),
              ],
            ),
          ),

          // ADD TASK BUTTON
          floatingActionButton: FloatingActionButton(
            onPressed: () => _openAddTask(context),
            child: const Icon(
              Icons.add_rounded,
              size: 30,
            ),
          ),
        );
      },
    );
  }

  void _openAddTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddTaskScreen(),
      ),
    );
  }
}
