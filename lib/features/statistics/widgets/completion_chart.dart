
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_to_do_app/core/constants/app_colors.dart';
import 'package:smart_to_do_app/features/statistics/screens/statistics_screen.dart';

class CompletionChart extends StatelessWidget {
  const CompletionChart({
    super.key,
    required this.tasks,
    required this.period,
    required this.startDate,
    required this.getTaskDate,
    required this.blue,
    required this.remaining,
  });

  final List<dynamic> tasks;
  final StatsPeriod period;
  final DateTime startDate;
  final DateTime? Function(dynamic task) getTaskDate;
  final Color blue;
  final Color remaining;

  int get _bucketCount {
    switch (period) {
      case StatsPeriod.day:
        return 1;
      case StatsPeriod.week:
        return 7;
      case StatsPeriod.month:
        return DateTime(startDate.year, startDate.month + 1, 0).day;
      case StatsPeriod.year:
        return 12;
    }
  }

  int _bucketIndex(DateTime date) {
    switch (period) {
      case StatsPeriod.day:
        return 0;
      case StatsPeriod.week:
        return date.difference(startDate).inDays;
      case StatsPeriod.month:
        return date.day - 1;
      case StatsPeriod.year:
        return date.month - 1;
    }
  }

  String _bucketLabel(int index) {
    switch (period) {
      case StatsPeriod.day:
        return DateFormat('d').format(startDate);
      case StatsPeriod.week:
        return DateFormat('E').format(
          startDate.add(Duration(days: index)),
        );
      case StatsPeriod.month:
        final day = index + 1;
        return day == 1 || day % 5 == 0 ? '$day' : '';
      case StatsPeriod.year:
        return DateFormat('MMM').format(DateTime(startDate.year, index + 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    final counts = List<int>.filled(_bucketCount, 0);

    for (final task in tasks) {
      if (!task.isCompleted) continue;
      final date = getTaskDate(task);
      if (date == null) continue;

      final index = _bucketIndex(date);
      if (index >= 0 && index < counts.length) {
        counts[index]++;
      }
    }

    final maxCount = counts.isEmpty
        ? 0
        : counts.reduce((a, b) => a > b ? a : b);
    final maxY = (maxCount + 2).clamp(5, 20).toDouble();
    final interval = maxY <= 5 ? 1.0 : (maxY / 5).ceilToDouble();

    return BarChart(
      BarChartData(
        maxY: maxY,
        minY: 0,
        alignment: BarChartAlignment.spaceAround,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: interval,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 26,
              interval: interval,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 9,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: period == StatsPeriod.month ? 5 : 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= _bucketCount) {
                  return const SizedBox.shrink();
                }

                final label = _bucketLabel(index);
                if (label.isEmpty) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: List.generate(_bucketCount, (index) {
          final count = counts[index].toDouble();
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: count,
                width: period == StatsPeriod.month ? 7 : 17,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
                color: count > 0 ? blue : remaining,
              ),
            ],
          );
        }),
      ),
    );
  }
}