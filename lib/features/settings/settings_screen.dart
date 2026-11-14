import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../about/about_screen.dart';
import '../about/legal_document_screen.dart';
import '../home/home_view_model.dart';
import 'settings_view_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final settings = context.watch<SettingsViewModel>();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        Text(
          'Appearance & Controls',
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theme Mode',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.system,
                        icon: Icon(Icons.brightness_auto_rounded, size: 18),
                        label: Text('System'),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        icon: Icon(Icons.light_mode_rounded, size: 18),
                        label: Text('Light'),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        icon: Icon(Icons.dark_mode_rounded, size: 18),
                        label: Text('Dark'),
                      ),
                    ],
                    selected: {settings.themeMode},
                    onSelectionChanged: (selection) {
                      settings.updateThemeMode(selection.first);
                    },
                  ),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Haptic Feedback'),
                  subtitle: const Text('Subtle vibration when weaving tiles'),
                  value: settings.hapticsEnabled,
                  onChanged: settings.toggleHaptics,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Show Step Numbers'),
                  subtitle: const Text('Display step count along your path'),
                  value: settings.showStepNumbers,
                  onChanged: settings.toggleShowStepNumbers,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'Data & Feedback',
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.star_rate_rounded,
                  color: colorScheme.primary,
                ),
                title: const Text('Rate App & Feedback'),
                subtitle: const Text('Share thoughts or copy support email'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _showFeedbackSheet(context),
              ),
              Divider(height: 1, color: colorScheme.outlineVariant),
              ListTile(
                leading: Icon(
                  Icons.delete_outline_rounded,
                  color: colorScheme.error,
                ),
                title: Text(
                  'Clear App Data',
                  style: TextStyle(color: colorScheme.error),
                ),
                subtitle: const Text('Reset solved puzzles, stars, and streaks'),
                onTap: () => _confirmClearData(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'Legal & Information',
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.privacy_tip_outlined,
                  color: colorScheme.primary,
                ),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => LegalDocumentScreen.privacyPolicy(),
                  ),
                ),
              ),
              Divider(height: 1, color: colorScheme.outlineVariant),
              ListTile(
                leading: Icon(
                  Icons.gavel_rounded,
                  color: colorScheme.primary,
                ),
                title: const Text('Terms of Service'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => LegalDocumentScreen.termsOfService(),
                  ),
                ),
              ),
              Divider(height: 1, color: colorScheme.outlineVariant),
              ListTile(
                leading: Icon(
                  Icons.info_outline_rounded,
                  color: colorScheme.primary,
                ),
                title: const Text('About PathWeave'),
                subtitle: const Text(
                  'Version ${AppConstants.appVersion} (${AppConstants.buildNumber})',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AboutScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showFeedbackSheet(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: colorScheme.surfaceContainerLow,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enjoying PathWeave?',
              style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Leave a rating on Google Play or send puzzle suggestions to our support address.',
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Clipboard.setData(
                    const ClipboardData(text: AppConstants.supportEmail),
                  );
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Copied ${AppConstants.supportEmail} to clipboard',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: const Text('Copy ${AppConstants.supportEmail}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmClearData(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear all progress?'),
        content: const Text(
          'This resets all solved campaign puzzles, stars, and daily streaks on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              await context.read<HomeViewModel>().resetAllProgress();
              if (ctx.mounted) Navigator.of(ctx).pop();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All local progress cleared.')),
                );
              }
            },
            child: const Text('Clear Data'),
          ),
        ],
      ),
    );
  }
}
