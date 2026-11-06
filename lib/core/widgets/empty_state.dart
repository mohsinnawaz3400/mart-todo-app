import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String description;

  final String? imagePath;

  final String? buttonText;
  final VoidCallback? onPressed;

  const EmptyState({
    super.key,
    required this.title,
    required this.description,
    this.imagePath,
    this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null)
              Image.asset(
                imagePath!,
                height: 180,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.task_alt,
                    size: 100,
                    color: AppColors.primary,
                  );
                },
              ),

            const SizedBox(height: 20),

            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color,
                ),
              ),
            ),

            if (buttonText != null && onPressed != null) ...[
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: onPressed,
                child: Text(buttonText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}