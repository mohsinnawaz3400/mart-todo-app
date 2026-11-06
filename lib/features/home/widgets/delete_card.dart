
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_to_do_app/core/localization/app_localizations.dart';

class DateCard extends StatelessWidget {
  const DateCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.calendar_month,
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE').format(now),
                  style: theme.textTheme.titleSmall,
                ),
                Text(
                  DateFormat('dd MMMM yyyy').format(now),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),

            const Spacer(),

            Text(context.tr('TODAY'),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}