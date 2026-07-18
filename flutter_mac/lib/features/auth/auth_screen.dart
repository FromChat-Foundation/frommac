import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import '../session/session_controller.dart';

enum _AuthStep { username, password, confirm, profile }

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  _AuthStep _step = _AuthStep.username;
  bool _register = false;
  bool _busy = false;
  bool _obscure = true;
  String? _error;

  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _displayName = TextEditingController();
  final _bio = TextEditingController();

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    _confirm.dispose();
    _displayName.dispose();
    _bio.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _error = null);
    switch (_step) {
      case _AuthStep.username:
        final u = _username.text.trim();
        if (u.length < 3 || u.length > 20) {
          setState(() => _error = l10n.username_length_error);
          return;
        }
        setState(() => _busy = true);
        try {
          final exists =
              await ref.read(apiClientProvider).checkUsername(u);
          setState(() {
            _register = !exists;
            _step = _AuthStep.password;
            _busy = false;
          });
        } catch (e) {
          final base = l10n.auth_server_connect_failed;
          final hint = e.toString();
          setState(() {
            _busy = false;
            _error = hint.contains('8787') || hint.contains('Connection refused')
                ? '$base\n(DEV: запусти python3 tool/cors_proxy.py)'
                : '$base\n$hint';
          });
        }
      case _AuthStep.password:
        final p = _password.text;
        if (p.length < 5 || p.length > 50) {
          setState(() => _error = l10n.password_length_error);
          return;
        }
        if (_register) {
          setState(() => _step = _AuthStep.confirm);
        } else {
          await _submitLogin();
        }
      case _AuthStep.confirm:
        if (_confirm.text != _password.text) {
          setState(() => _error = l10n.passwords_dont_match);
          return;
        }
        setState(() => _step = _AuthStep.profile);
      case _AuthStep.profile:
        final name = _displayName.text.trim();
        if (name.isEmpty || name.length > 64) {
          setState(() => _error = l10n.display_name_error);
          return;
        }
        await _submitRegister();
    }
  }

  Future<void> _submitLogin() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await ref.read(sessionProvider.notifier).login(
            username: _username.text.trim(),
            password: _password.text,
          );
      if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
    } catch (e) {
      setState(() => _error = l10n.auth_wrong_password);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _submitRegister() async {
    setState(() => _busy = true);
    try {
      await ref.read(sessionProvider.notifier).register(
            username: _username.text.trim(),
            displayName: _displayName.text.trim(),
            password: _password.text,
            confirmPassword: _confirm.text,
            bio: _bio.text.trim().isEmpty ? null : _bio.text.trim(),
          );
      if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _back() {
    setState(() {
      _error = null;
      switch (_step) {
        case _AuthStep.username:
          Navigator.of(context).pop();
        case _AuthStep.password:
          _step = _AuthStep.username;
        case _AuthStep.confirm:
          _step = _AuthStep.password;
        case _AuthStep.profile:
          _step = _AuthStep.confirm;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    final (title, body) = switch (_step) {
      _AuthStep.username => (
          l10n.auth_step_username_title,
          l10n.auth_step_username_body
        ),
      _AuthStep.password => (
          l10n.auth_step_password_title,
          l10n.auth_step_password_body
        ),
      _AuthStep.confirm => (
          l10n.auth_step_confirm_title,
          l10n.auth_step_confirm_body
        ),
      _AuthStep.profile => (
          l10n.auth_step_profile_title,
          l10n.auth_step_profile_body
        ),
    };

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _back,
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    switch (_step) {
                      _AuthStep.username => Icons.person_outline,
                      _AuthStep.password ||
                      _AuthStep.confirm =>
                        Icons.lock_outline,
                      _AuthStep.profile => Icons.badge_outlined,
                    },
                    size: 36,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 20),
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 24),
                if (_step == _AuthStep.username)
                  TextField(
                    controller: _username,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: l10n.username,
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _next(),
                  ),
                if (_step == _AuthStep.password)
                  TextField(
                    controller: _password,
                    autofocus: true,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () =>
                            setState(() => _obscure = !_obscure),
                      ),
                    ),
                    onSubmitted: (_) => _next(),
                  ),
                if (_step == _AuthStep.confirm)
                  TextField(
                    controller: _confirm,
                    autofocus: true,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: l10n.confirm_password,
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _next(),
                  ),
                if (_step == _AuthStep.profile) ...[
                  TextField(
                    controller: _displayName,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: l10n.display_name,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _bio,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: l10n.profile_headline_bio,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: TextStyle(color: scheme.error)),
                ],
                const Spacer(),
                FilledButton(
                  onPressed: _busy ? null : _next,
                  child: _busy
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _step == _AuthStep.profile
                              ? l10n.register_button
                              : (_step == _AuthStep.password && !_register)
                                  ? l10n.login
                                  : l10n.settings_next,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
