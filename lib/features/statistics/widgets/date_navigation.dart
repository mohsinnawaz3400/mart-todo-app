
import 'package:flutter/material.dart';
import 'package:smart_to_do_app/core/constants/app_colors.dart';

class DateNavigation extends StatelessWidget {
  const DateNavigation({
    super.key,
    required this.label,
    required this.onPrevious,
    required this.onNext,
  });

  final String label;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _DateNavigationButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: onPrevious,
        ),
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? AppColors.success : AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        _DateNavigationButton(
          icon: Icons.arrow_forward_ios_rounded,
          onTap: onNext,
        ),
      ],
    );
  }
}

class _DateNavigationButton extends StatelessWidget {
  const _DateNavigationButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: theme.cardTheme.color ?? theme.colorScheme.surface,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          height: 36,
          width: 36,
          child: Icon(
            icon,
            size: 15,
            color: isDark ? AppColors.success : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
