
import 'package:flutter/material.dart';
import 'package:smart_to_do_app/core/constants/app_colors.dart';

class ChartLegendItem extends StatelessWidget {
  const ChartLegendItem({
    super.key,
    required this.color,
    required this.title,
  });

  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 9,
          width: 9,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}