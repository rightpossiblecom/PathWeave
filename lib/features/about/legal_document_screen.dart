import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class LegalDocumentScreen extends StatelessWidget {
  final String title;
  final List<Map<String, String>> sections;

  const LegalDocumentScreen({
    super.key,
    required this.title,
    required this.sections,
  });

  factory LegalDocumentScreen.privacyPolicy() {
    return const LegalDocumentScreen(
      title: 'Privacy Policy',
      sections: [
        {
          'heading': 'Overview',
          'body':
              'PathWeave respects your privacy completely. We do not collect any personal data, require user accounts, or track players across devices.',
        },
        {
          'heading': 'Zero Personal Data Collection',
          'body':
              'We do not collect any personal data such as names, email addresses, phone numbers, precise locations, advertising identifiers, or usage analytics.',
        },
        {
          'heading': 'On-Device Storage Only',
          'body':
              'Your solved levels, star ratings, daily puzzle streaks, and display preferences are stored exclusively on your device using local storage. You can erase all saved progress at any time from the Settings screen.',
        },
        {
          'heading': 'Third-Party Sharing',
          'body':
              'Because no personal information is collected or transmitted to external servers, zero user data is shared with or sold to third parties.',
        },
        {
          'heading': 'Contact',
          'body':
              'For questions about this Privacy Policy, reach out to ${AppConstants.supportEmail}.',
        },
      ],
    );
  }

  factory LegalDocumentScreen.termsOfService() {
    return const LegalDocumentScreen(
      title: 'Terms of Service',
      sections: [
        {
          'heading': 'Acceptance of Terms',
          'body':
              'By installing and playing PathWeave, you agree to use the application for personal, non-commercial entertainment in compliance with applicable laws.',
        },
        {
          'heading': 'Offline Puzzle Gameplay',
          'body':
              'PathWeave operates offline without accounts or subscriptions. Game progress resides locally on your device; uninstalling the app or clearing app data permanently resets local progress.',
        },
        {
          'heading': 'Intellectual Property',
          'body':
              'Puzzle layouts, visual interface elements, and software code included in PathWeave are provided under the terms distributed with the application.',
        },
        {
          'heading': 'Disclaimer of Warranties',
          'body':
              'PathWeave is provided on an "as is" basis without warranties of any kind. Support inquiries may be sent to ${AppConstants.supportEmail}.',
        },
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
        itemCount: sections.length,
        separatorBuilder: (_, _) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final item = sections[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['heading'] ?? '',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['body'] ?? '',
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
