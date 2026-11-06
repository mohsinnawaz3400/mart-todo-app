import 'package:flutter/material.dart';
import 'package:smart_to_do_app/core/localization/app_localizations.dart';

class ProgressCard extends StatelessWidget {
  final int completed;
  final int total;
  final int pending;
  final double percentage;

  const ProgressCard({
    super.key,
    required this.completed,
    required this.total,
    required this.pending,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final gradientColors = isDark
        ? const [Color(0xFF14532D), Color(0xFF166534)]
        : const [Color(0xFF16A34A), Color(0xFF22C55E)];

    final textColor = Colors.white;
    final secondaryTextColor = Colors.white.withOpacity(0.85);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.20),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            height: 90,
            width: 90,
            child: Stack(
              alignment: Alignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: percentage.clamp(0.0, 1.0)),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return SizedBox(
                      height: 65,
                      width: 65,
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 8,
                        strokeCap: StrokeCap.round,
                        backgroundColor: Colors.white.withOpacity(0.25),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                Text(
                  '${(percentage.clamp(0.0, 1.0) * 100).round()}%',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('Your Progress'),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 9),

                Text(
                  '$completed of $total tasks completed',
                  style: TextStyle(color: secondaryTextColor, fontSize: 12),
                ),

                const SizedBox(height: 8),

                Text(
                  '$pending tasks remaining',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
