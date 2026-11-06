import 'package:flutter/material.dart';
import 'package:smart_to_do_app/core/constants/app_colors.dart';

class SettingsIconContainer extends StatelessWidget {
  const SettingsIconContainer({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: 42,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: AppColors.primary, size: 21),
    );
  }
}