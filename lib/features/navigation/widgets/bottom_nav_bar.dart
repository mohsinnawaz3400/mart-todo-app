import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAddTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddTap,
  });

  static const List<IconData> _icons = [
    Icons.home_rounded,
    Icons.calendar_month_rounded,
    Icons.bar_chart_rounded,
    Icons.settings_rounded,
  ];

  static const List<String> _labels = [
    'Home',
    'Tasks',
    'Statistics',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 10),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _buildNavItem(context, 0),
            _buildNavItem(context, 1),

            Expanded(
              child: GestureDetector(
                onTap: onAddTap,
                child: Transform.translate(
                  offset: const Offset(0, -15),
                  child: Container(
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.35),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            _buildNavItem(context, 2),
            _buildNavItem(context, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index) {
    final bool isSelected = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _icons[index],
              size: 25,
              color: isSelected ? AppColors.primary : const Color(0xFF9A9AAA),
            ),

            const SizedBox(height: 5),

            Text(
              AppLocalizations.text(context, _labels[index]),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : const Color(0xFF9A9AAA),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
