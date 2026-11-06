import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';

class TaskSaveButton extends StatelessWidget {
  final bool isSaving;
  final bool isEditing;
  final VoidCallback onPressed;

  const TaskSaveButton({
    super.key,
    required this.isSaving,
    required this.isEditing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: isSaving ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 2,
          disabledBackgroundColor:
          primary.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: isSaving
            ? const SizedBox(
          height: 23,
          width: 23,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Colors.white,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isEditing
                  ? Icons.save_rounded
                  : Icons.add_task_rounded,
            ),
            const SizedBox(width: 10),
            Text(
              context.tr(
                isEditing ? 'Update Task' : 'Save Task',
              ),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}