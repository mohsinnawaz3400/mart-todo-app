import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';

class TaskDateTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const TaskDateTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (onClear != null)
                IconButton(
                  onPressed: onClear,
                  tooltip: context.tr('Clear'),
                  icon: const Icon(Icons.close_rounded),
                )
              else
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                ),
            ],
          ),
        ),
      ),
    );
  }
}