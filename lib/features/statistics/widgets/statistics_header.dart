
import 'package:flutter/material.dart';
import 'package:smart_to_do_app/core/constants/app_colors.dart';
import 'package:smart_to_do_app/core/localization/app_localizations.dart';

class StatisticsHeader extends StatelessWidget {
  const StatisticsHeader({super.key, required this.onInfoTap});

  final VoidCallback onInfoTap;

  @override
  Widget build(BuildContext context) {
    final foreground = Theme.of(context).colorScheme.onSurface;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: context.tr('Done!'),
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  color: foreground,
                ),
              ),
              TextSpan(
                text: '™',
                style: TextStyle(fontSize: 12, color: foreground),
              ),
            ],
          ),
        ),
        Material(
          color: Theme.of(context).cardTheme.color ??
              Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          child: IconButton(
            tooltip: context.tr('Statistics information'),
            onPressed: onInfoTap,
            icon: Icon(Icons.info_outline_rounded, color: foreground),
          ),
        ),
      ],
    );
  }
}