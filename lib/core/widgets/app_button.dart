import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  final Color? backgroundColor;
  final Color? textColor;

  final IconData? icon;

  final bool isLoading;
  final bool isOutlined;

  final double height;
  final double? width;

  const AppButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
    this.height = 52,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final color = backgroundColor ?? AppColors.primary;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: isOutlined
          ? OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? color,
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _buildChild(color),
      )
          : ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor ?? Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _buildChild(
          textColor ?? Colors.white,
        ),
      ),
    );
  }

  Widget _buildChild(Color foregroundColor) {
    if (isLoading) {
      return SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: foregroundColor,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      );
    }

    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
    );
  }
}