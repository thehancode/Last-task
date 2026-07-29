import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/ui_mode.dart';
import '../l10n/app_localizations.dart';
import 'auth_view_model.dart';
import 'terminal_style.dart';

class GuestImportScreen extends ConsumerWidget {
  const GuestImportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: EdgeInsets.all(
              usesTerminalPresentation ? TerminalMetrics.line(context) : 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  strings.guestImportTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: TerminalMetrics.line(context)),
                Text(strings.guestImportMessage),
                SizedBox(height: TerminalMetrics.line(context)),
                FilledButton(
                  onPressed: () => ref
                      .read(authViewModelProvider.notifier)
                      .importGuestWorkspace(),
                  child: Text(strings.importTasks),
                ),
                TextButton(
                  onPressed: () => ref
                      .read(authViewModelProvider.notifier)
                      .keepGuestWorkspaceSeparate(),
                  child: Text(strings.keepSeparate),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
