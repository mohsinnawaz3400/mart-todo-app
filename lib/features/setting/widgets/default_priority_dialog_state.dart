import 'package:flutter/material.dart';
import 'package:smart_to_do_app/core/constants/app_colors.dart';
import 'package:smart_to_do_app/core/localization/app_localizations.dart';
import 'package:smart_to_do_app/features/setting/screens/settings_screen.dart';

import 'default_priorityD_dalog.dart';

class DefaultPriorityDialogState extends State<DefaultPriorityDialog> {
  String _selectedPriority = 'Medium';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.tr('Default Priority')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: ['Low', 'Medium', 'High'].map((priority) {
          return RadioListTile<String>(
            contentPadding: EdgeInsets.zero,
            title: Text(context.tr(priority)),
            value: priority,
            groupValue: _selectedPriority,
            activeColor: AppColors.primary,
            onChanged: (value) {
              if (value == null) return;
              setState(() => _selectedPriority = value);
            },
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.tr('Cancel')),
        ),
        ElevatedButton(
          onPressed: () {
            final messenger = ScaffoldMessenger.of(context);
            final message =
                '${context.tr(_selectedPriority)} ${context.tr('selected')}';
            Navigator.pop(context);
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(message),
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
          },
          child: Text(context.tr('Save')),
        ),
      ],
    );
  }
}