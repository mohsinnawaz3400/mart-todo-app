
import 'package:flutter/material.dart';
import 'package:smart_to_do_app/core/constants/app_colors.dart';
import 'package:smart_to_do_app/core/localization/app_localizations.dart';
import 'package:smart_to_do_app/features/statistics/screens/statistics_screen.dart';

class PeriodSelector extends StatelessWidget {
  const PeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onChanged,
  });

  final StatsPeriod selectedPeriod;
  final ValueChanged<StatsPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: isDark
              ? AppColors.secondary
              : AppColors.border,
        ),
      ),
      child: Row(
        children: StatsPeriod.values.map((period) {
          final selected = selectedPeriod == period;

          final label = period.name[0].toUpperCase() +
              period.name.substring(1);

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(period),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  context.tr(label),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: selected
                        ? AppColors.white
                        : Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
