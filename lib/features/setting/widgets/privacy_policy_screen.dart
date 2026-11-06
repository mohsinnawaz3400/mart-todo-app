
import 'package:flutter/material.dart';
import 'package:smart_to_do_app/core/constants/app_colors.dart';
import 'package:smart_to_do_app/core/localization/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('Privacy Policy')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(
            Icons.privacy_tip_outlined,
            size: 52,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            context.tr('Privacy Policy'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            context.tr(
              'A formal privacy policy has not been added to this app yet. '
                  'Please contact the app developer for information about data '
                  'storage, processing, and privacy practices.',
            ),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
            label: Text(context.tr('Back to Settings')),
          ),
        ],
      ),
    );
  }
}