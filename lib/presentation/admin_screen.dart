import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/ui_mode.dart';
import '../data/backend_auth_session.dart';
import '../l10n/app_localizations.dart';
import 'admin_view_model.dart';
import 'auth_view_model.dart';
import 'terminal_style.dart';

class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final state = ref.watch(adminViewModelProvider);
    final currentUserId = ref.watch(authViewModelProvider).userId;
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.administration),
        actions: [
          TextButton(
            onPressed: state.loading
                ? null
                : () => ref.read(authViewModelProvider.notifier).logOut(),
            child: Text(strings.logOut),
          ),
          TextButton(
            onPressed: state.loading ? null : () => _showCreateUser(context),
            child: Text(strings.createUser),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(
          usesTerminalPresentation ? TerminalMetrics.line(context) : 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state.error != null) ...[
              Text(
                state.error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              SizedBox(height: TerminalMetrics.line(context)),
            ],
            Expanded(
              child: state.loading && state.users.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : state.users.isEmpty
                  ? Center(child: Text(strings.noUsers))
                  : ListView.separated(
                      itemCount: state.users.length,
                      separatorBuilder: (_, _) =>
                          Divider(height: TerminalMetrics.line(context)),
                      itemBuilder: (context, index) {
                        final user = state.users[index];
                        final canDelete = user.id != currentUserId;
                        return Semantics(
                          label: '${user.displayName}, ${user.email}',
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: usesTerminalPresentation ? 0 : 4,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    user.displayName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: TerminalMetrics.cell(context)),
                                Text(user.email),
                                if (user.isAdmin) ...[
                                  SizedBox(
                                    width: TerminalMetrics.cell(context),
                                  ),
                                  Text(strings.administrator),
                                ],
                                if (canDelete) ...[
                                  SizedBox(
                                    width: TerminalMetrics.cell(context),
                                  ),
                                  IconButton(
                                    tooltip: strings.deleteUser,
                                    onPressed: state.loading
                                        ? null
                                        : () => _confirmDelete(
                                            context,
                                            ref,
                                            user,
                                          ),
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCreateUser(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) => const _CreateUserDialog(),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AdminUser user,
  ) async {
    final strings = AppLocalizations.of(context)!;
    final delete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.deleteUserTitle),
        content: Text(strings.deleteUserBody(user.displayName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(strings.delete),
          ),
        ],
      ),
    );
    if (delete == true && context.mounted) {
      await ref.read(adminViewModelProvider.notifier).deleteUser(user.id);
    }
  }
}

class _CreateUserDialog extends ConsumerStatefulWidget {
  const _CreateUserDialog();

  @override
  ConsumerState<_CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends ConsumerState<_CreateUserDialog> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _email = TextEditingController();
  final _displayName = TextEditingController();
  var _isAdmin = false;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    _email.dispose();
    _displayName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final busy = ref.watch(adminViewModelProvider).loading;
    return AlertDialog(
      title: Text(strings.createUser),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _username,
              decoration: InputDecoration(labelText: strings.username),
            ),
            TextField(
              controller: _email,
              decoration: InputDecoration(labelText: strings.email),
            ),
            TextField(
              controller: _displayName,
              decoration: InputDecoration(labelText: strings.displayName),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(labelText: strings.password),
            ),
            CheckboxListTile(
              value: _isAdmin,
              onChanged: busy
                  ? null
                  : (value) => setState(() => _isAdmin = value!),
              title: Text(strings.administrator),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: busy ? null : () => Navigator.pop(context),
          child: Text(strings.cancel),
        ),
        FilledButton(
          onPressed: busy ? null : _submit,
          child: Text(strings.createUser),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final created = await ref
        .read(adminViewModelProvider.notifier)
        .createUser(
          username: _username.text,
          password: _password.text,
          email: _email.text,
          displayName: _displayName.text,
          isAdmin: _isAdmin,
        );
    if (created && mounted) Navigator.pop(context);
  }
}
