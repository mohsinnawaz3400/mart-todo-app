
import 'package:flutter/material.dart';
import 'package:smart_to_do_app/core/constants/app_colors.dart';

import 'chart_legend_item.dart';

class StatisticsChartCard extends StatelessWidget {
  const StatisticsChartCard({
    super.key,
    required this.title,
    required this.chart,
    required this.legendItems,
  });

  final String title;
  final Widget chart;
  final List<ChartLegendItem> legendItems;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(height: 220, child: chart),
          const SizedBox(height: 18),
          Wrap(
            spacing: 16,
            runSpacing: 10,
            children: legendItems
                .map((item) => ChartLegendItem(
              color: item.color,
              title: item.title,
            ))
                .toList(),
          ),
        ],
      ),
    );
  }
}