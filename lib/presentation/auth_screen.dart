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

class _AuthScreenState extends ConsumerState<AuthScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(
    length: 2,
    initialIndex: ref.read(authViewModelProvider).preferLogin ? 1 : 0,
    vsync: this,
  );
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();

  @override
  void dispose() {
    _tabs.dispose();
    _username.dispose();
    _password.dispose();
    _confirmation.dispose();
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
                TabBar(
                  controller: _tabs,
                  tabs: [
                    Tab(text: strings.createAccount),
                    Tab(text: strings.logIn),
                  ],
                ),
                SizedBox(height: TerminalMetrics.line(context)),
                AnimatedBuilder(
                  animation: _tabs,
                  builder: (context, _) => _CredentialsForm(
                    createAccount: _tabs.index == 0,
                    username: _username,
                    password: _password,
                    confirmation: _confirmation,
                    busy: busy,
                    error: state.error,
                    onSubmit: _submit,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(bool createAccount) async {
    final strings = AppLocalizations.of(context)!;
    if (createAccount && _password.text != _confirmation.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.passwordsDoNotMatch)));
      return;
    }
    if (createAccount) {
      await ref
          .read(authViewModelProvider.notifier)
          .register(_username.text, _password.text);
    } else {
      await ref
          .read(authViewModelProvider.notifier)
          .logIn(_username.text, _password.text);
    }
  }
}

class _CredentialsForm extends StatelessWidget {
  const _CredentialsForm({
    required this.createAccount,
    required this.username,
    required this.password,
    required this.confirmation,
    required this.busy,
    required this.error,
    required this.onSubmit,
  });

  final bool createAccount;
  final TextEditingController username;
  final TextEditingController password;
  final TextEditingController confirmation;
  final bool busy;
  final String? error;
  final ValueChanged<bool> onSubmit;

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
          onSubmitted: (_) => onSubmit(createAccount),
          decoration: InputDecoration(labelText: strings.password),
        ),
        if (createAccount) ...[
          SizedBox(height: TerminalMetrics.line(context) * .6),
          TextField(
            controller: confirmation,
            enabled: !busy,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            onSubmitted: (_) => onSubmit(true),
            decoration: InputDecoration(labelText: strings.confirmPassword),
          ),
        ],
        if (error != null) ...[
          SizedBox(height: TerminalMetrics.line(context) * .6),
          Text(
            error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        SizedBox(height: TerminalMetrics.line(context)),
        FilledButton(
          onPressed: busy ? null : () => onSubmit(createAccount),
          child: busy
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(createAccount ? strings.createAccount : strings.logIn),
        ),
      ],
    );
  }
}
