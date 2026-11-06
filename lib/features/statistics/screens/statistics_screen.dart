
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_to_do_app/features/statistics/widgets/chart_legend_item.dart';
import 'package:smart_to_do_app/features/statistics/widgets/completion_chart.dart';
import 'package:smart_to_do_app/features/statistics/widgets/date_navigation.dart';
import 'package:smart_to_do_app/features/statistics/widgets/overall_progress_card.dart';
import 'package:smart_to_do_app/features/statistics/widgets/period_selector.dart';
import 'package:smart_to_do_app/features/statistics/widgets/statistics_chart_card.dart';
import 'package:smart_to_do_app/features/statistics/widgets/statistics_header.dart';
import 'package:smart_to_do_app/features/statistics/widgets/summary_card.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../tasks/controllers/task_controller.dart';

enum StatsPeriod { day, week, month, year }

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  StatsPeriod _selectedPeriod = StatsPeriod.week;
  DateTime _selectedDate = DateTime.now();

  // Centralized AppColors theme colors.
  Color get _blue => AppColors.primary;

  Color get _green => AppColors.success;

  Color get _importantColor => AppColors.warning;

  Color get _pendingColor => AppColors.danger;

  Color get _remainingColor {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return isDark
        ? const Color(0xFF475569)
        : AppColors.border;
  }

  DateTime get _startDate {
    switch (_selectedPeriod) {
      case StatsPeriod.day:
        return DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
        );

      case StatsPeriod.week:
        final monday = _selectedDate.subtract(
          Duration(days: _selectedDate.weekday - DateTime.monday),
        );

        return DateTime(monday.year, monday.month, monday.day);

      case StatsPeriod.month:
        return DateTime(
          _selectedDate.year,
          _selectedDate.month,
        );

      case StatsPeriod.year:
        return DateTime(_selectedDate.year);
    }
  }

  DateTime get _endDate {
    switch (_selectedPeriod) {
      case StatsPeriod.day:
        return _startDate.add(const Duration(days: 1));

      case StatsPeriod.week:
        return _startDate.add(const Duration(days: 7));

      case StatsPeriod.month:
        return DateTime(
          _selectedDate.year,
          _selectedDate.month + 1,
        );

      case StatsPeriod.year:
        return DateTime(_selectedDate.year + 1);
    }
  }

  String get _dateLabel {
    final start = _startDate;
    final end = _endDate.subtract(const Duration(days: 1));

    switch (_selectedPeriod) {
      case StatsPeriod.day:
        return DateFormat('MMM d, yyyy').format(start);

      case StatsPeriod.week:
        return '${DateFormat('MMM d').format(start)} – '
            '${DateFormat('MMM d, yyyy').format(end)}';

      case StatsPeriod.month:
        return DateFormat('MMMM yyyy').format(start);

      case StatsPeriod.year:
        return DateFormat('yyyy').format(start);
    }
  }

  void _changeDate(int direction) {
    setState(() {
      switch (_selectedPeriod) {
        case StatsPeriod.day:
          _selectedDate = _selectedDate.add(
            Duration(days: direction),
          );
          break;

        case StatsPeriod.week:
          _selectedDate = _selectedDate.add(
            Duration(days: 7 * direction),
          );
          break;

        case StatsPeriod.month:
          _selectedDate = DateTime(
            _selectedDate.year,
            _selectedDate.month + direction,
            1,
          );
          break;

        case StatsPeriod.year:
          _selectedDate = DateTime(
            _selectedDate.year + direction,
            _selectedDate.month,
            1,
          );
          break;
      }
    });
  }

  bool _isInSelectedRange(DateTime? date) {
    return date != null &&
        !date.isBefore(_startDate) &&
        date.isBefore(_endDate);
  }

  DateTime? _getTaskDate(dynamic task) {
    // Prefer updatedAt. Fall back to dueDate.
    try {
      final value = task.updatedAt;

      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value);
    } catch (_) {
      // The task model may not expose updatedAt.
    }

    try {
      final value = task.dueDate;

      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value);
    } catch (_) {
      // The task model may not expose dueDate.
    }

    return null;
  }

  bool _isHighPriority(dynamic task) {
    return task.priority.toString().toLowerCase().contains('high');
  }

  void _showInfoSnackBar() {
    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            context.tr(
              'Statistics are calculated from the dates available in your tasks.',
            ),
          ),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor: AppColors.secondary,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskController>(
      builder: (context, controller, child) {
        final periodTasks = controller.tasks.where((task) {
          return _isInSelectedRange(_getTaskDate(task));
        }).toList();

        final total = periodTasks.length;

        final completed = periodTasks
            .where((task) => task.isCompleted)
            .length;

        final pending = total - completed;

        final important = periodTasks.where((task) {
          return _isHighPriority(task) && !task.isCompleted;
        }).length;

        final progress = total == 0 ? 0.0 : completed / total;

        return Scaffold(
          backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatisticsHeader(
                    onInfoTap: _showInfoSnackBar,
                  ),

                  const SizedBox(height: 24),

                  PeriodSelector(
                    selectedPeriod: _selectedPeriod,
                    onChanged: (period) {
                      setState(() {
                        _selectedPeriod = period;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  DateNavigation(
                    label: _dateLabel,
                    onPrevious: () => _changeDate(-1),
                    onNext: () => _changeDate(1),
                  ),

                  const SizedBox(height: 22),

                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          icon: Icons.check_circle_rounded,
                          title: context.tr('Completed'),
                          count: completed,
                          color: _blue,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: SummaryCard(
                          icon: Icons.star_rounded,
                          title: context.tr('Important'),
                          count: important,
                          color: _importantColor,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: SummaryCard(
                          icon: Icons.pending_actions_rounded,
                          title: context.tr('Pending'),
                          count: pending,
                          color: _pendingColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  StatisticsChartCard(
                    title: context.tr('TASKS COMPLETED'),
                    chart: CompletionChart(
                      tasks: periodTasks,
                      period: _selectedPeriod,
                      startDate: _startDate,
                      getTaskDate: _getTaskDate,
                      blue: _blue,
                      remaining: _remainingColor,
                    ),
                    legendItems: [
                      ChartLegendItem(
                        color: _blue,
                        title: context.tr('Completed'),
                      ),
                      ChartLegendItem(
                        color: _green,
                        title: context.tr('Important'),
                      ),
                      ChartLegendItem(
                        color: _remainingColor,
                        title: context.tr('Remaining'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  OverallProgressCard(
                    completed: completed,
                    total: total,
                    progress: progress,
                    blue: _blue,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
