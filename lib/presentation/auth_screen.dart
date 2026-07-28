import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/ui_mode.dart';
import '../l10n/app_localizations.dart';
import 'auth_view_model.dart';
import 'terminal_style.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _username = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final state = ref.watch(authViewModelProvider);
    final busy = state.phase == AuthPhase.loading;
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: EdgeInsets.all(
              usesTerminalPresentation ? TerminalMetrics.line(context) : 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  strings.appTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: TerminalMetrics.line(context)),
                _CredentialsForm(
                  username: _username,
                  password: _password,
                  busy: busy,
                  error: state.error,
                  onSubmit: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() => ref
      .read(authViewModelProvider.notifier)
      .logIn(_username.text, _password.text);
}

class _CredentialsForm extends StatelessWidget {
  const _CredentialsForm({
    required this.username,
    required this.password,
    required this.busy,
    required this.error,
    required this.onSubmit,
  });

  final TextEditingController username;
  final TextEditingController password;
  final bool busy;
  final String? error;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: username,
          enabled: !busy,
          autocorrect: false,
          enableSuggestions: false,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(labelText: strings.username),
        ),
        SizedBox(height: TerminalMetrics.line(context) * .6),
        TextField(
          controller: password,
          enabled: !busy,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          onSubmitted: (_) => onSubmit(),
          decoration: InputDecoration(labelText: strings.password),
        ),
        if (error != null) ...[
          SizedBox(height: TerminalMetrics.line(context) * .6),
          Text(
            error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        SizedBox(height: TerminalMetrics.line(context)),
        FilledButton(
          onPressed: busy ? null : onSubmit,
          child: busy
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(strings.logIn),
        ),
      ],
    );
  }
}
