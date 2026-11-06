import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;

  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;

  final double radius;
  final double elevation;

  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
    this.radius = 16,
    this.elevation = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor ??
          Theme.of(context).cardColor,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(
          color: Theme.of(context).brightness == Brightness.light
              ? AppColors.border
              : Colors.transparent,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}