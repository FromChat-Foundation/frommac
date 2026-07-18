import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/providers.dart';
import '../core/server_config.dart';
import '../features/session/session_controller.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../crypto/password_hash.dart';

enum SettingsPage {
  hub,
  appearance,
  devices,
  account,
  changePassword,
  deleteAccount,
  server,
  about,
  logs,
}

final settingsPageProvider =
    StateProvider<SettingsPage>((ref) => SettingsPage.hub);

class SettingsPane extends ConsumerWidget {
  const SettingsPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(settingsPageProvider);
    return switch (page) {
      SettingsPage.hub => const _SettingsHub(),
      SettingsPage.appearance => const _AppearancePage(),
      SettingsPage.devices => const _DevicesPage(),
      SettingsPage.account => const _AccountPage(),
      SettingsPage.changePassword => const _ChangePasswordPage(),
      SettingsPage.deleteAccount => const _DeleteAccountPage(),
      SettingsPage.server => const _ServerConfigPage(),
      SettingsPage.about => const _AboutPage(),
      SettingsPage.logs => const _LogsPage(),
    };
  }
}

class _SettingsHub extends ConsumerWidget {
  const _SettingsHub();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(l10n.settings, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        _tile(context, Icons.palette_outlined, l10n.settings_category_appearance,
            () => ref.read(settingsPageProvider.notifier).state =
                SettingsPage.appearance),
        _tile(context, Icons.devices, l10n.settings_devices_title,
            () => ref.read(settingsPageProvider.notifier).state =
                SettingsPage.devices),
        _tile(context, Icons.manage_accounts_outlined, l10n.settings_account_title,
            () => ref.read(settingsPageProvider.notifier).state =
                SettingsPage.account),
        _tile(context, Icons.dns_outlined, l10n.server_config_title,
            () => ref.read(settingsPageProvider.notifier).state =
                SettingsPage.server),
        _tile(context, Icons.info_outline, l10n.about,
            () => ref.read(settingsPageProvider.notifier).state =
                SettingsPage.about),
        _tile(context, Icons.bug_report_outlined, l10n.logs_title,
            () => ref.read(settingsPageProvider.notifier).state =
                SettingsPage.logs),
        const Divider(height: 32),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: Text(l10n.logout, style: const TextStyle(color: Colors.red)),
          onTap: () => ref.read(sessionProvider.notifier).logout(),
        ),
      ],
    );
  }

  Widget _tile(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _BackScaffold extends ConsumerWidget {
  const _BackScaffold({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 16, 8),
          child: Row(
            children: [
              IconButton(
                onPressed: () => ref.read(settingsPageProvider.notifier).state =
                    SettingsPage.hub,
                icon: const Icon(Icons.arrow_back),
              ),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

class _AppearancePage extends ConsumerWidget {
  const _AppearancePage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mode = ref.watch(themeModeProvider);
    return _BackScaffold(
      title: l10n.settings_category_appearance,
      child: ListView(
        children: [
          RadioListTile<AppThemeMode>(
            title: Text(l10n.theme),
            value: AppThemeMode.asSystem,
            groupValue: mode,
            onChanged: (v) =>
                ref.read(themeModeProvider.notifier).setMode(v!),
          ),
          RadioListTile<AppThemeMode>(
            title: Text(l10n.light),
            value: AppThemeMode.light,
            groupValue: mode,
            onChanged: (v) =>
                ref.read(themeModeProvider.notifier).setMode(v!),
          ),
          RadioListTile<AppThemeMode>(
            title: Text(l10n.dark),
            value: AppThemeMode.dark,
            groupValue: mode,
            onChanged: (v) =>
                ref.read(themeModeProvider.notifier).setMode(v!),
          ),
        ],
      ),
    );
  }
}

class _DevicesPage extends ConsumerStatefulWidget {
  const _DevicesPage();

  @override
  ConsumerState<_DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends ConsumerState<_DevicesPage> {
  List<DeviceSessionInfo>? _devices;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list = await ref.read(apiClientProvider).devices();
      setState(() => _devices = list);
    } catch (e) {
      setState(() => _error = '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _BackScaffold(
      title: l10n.settings_devices_title,
      child: _devices == null
          ? Center(
              child: _error != null
                  ? Text(_error!)
                  : const CircularProgressIndicator(),
            )
          : (_devices!.isEmpty
              ? Center(child: Text(l10n.settings_devices_empty))
              : ListView.builder(
                  itemCount: _devices!.length,
                  itemBuilder: (context, i) {
                    final d = _devices![i];
                    return ListTile(
                      leading: const Icon(Icons.devices),
                      title: Text(d.deviceName),
                      subtitle: Text(d.lastActive),
                      trailing: d.current
                          ? Chip(label: Text(l10n.settings_devices_this_device))
                          : IconButton(
                              icon: const Icon(Icons.delete_outline),
                              tooltip: l10n.settings_devices_revoke,
                              onPressed: () async {
                                await ref
                                    .read(apiClientProvider)
                                    .revokeDevice(d.id);
                                await _load();
                              },
                            ),
                    );
                  },
                )),
    );
  }
}

class _AccountPage extends ConsumerWidget {
  const _AccountPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return _BackScaffold(
      title: l10n.settings_account_title,
      child: ListView(
        children: [
          ListTile(
            title: Text(l10n.settings_change_password),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => ref.read(settingsPageProvider.notifier).state =
                SettingsPage.changePassword,
          ),
          ListTile(
            title: Text(
              l10n.settings_account_delete,
              style: const TextStyle(color: Colors.red),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.red),
            onTap: () => ref.read(settingsPageProvider.notifier).state =
                SettingsPage.deleteAccount,
          ),
        ],
      ),
    );
  }
}

class _ChangePasswordPage extends ConsumerStatefulWidget {
  const _ChangePasswordPage();

  @override
  ConsumerState<_ChangePasswordPage> createState() =>
      _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<_ChangePasswordPage> {
  final _current = TextEditingController();
  final _next = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(sessionProvider).user;
    return _BackScaffold(
      title: l10n.settings_change_password,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _current,
              obscureText: true,
              decoration:
                  InputDecoration(labelText: l10n.settings_current_password),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _next,
              obscureText: true,
              decoration:
                  InputDecoration(labelText: l10n.settings_new_password),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _busy
                  ? null
                  : () async {
                      setState(() {
                        _busy = true;
                        _error = null;
                      });
                      try {
                        final username = user?.username ?? '';
                        await ref.read(apiClientProvider).changePassword(
                              currentPassword: PasswordHash.deriveAuthSecret(
                                username,
                                _current.text,
                              ),
                              newPassword: PasswordHash.deriveAuthSecret(
                                username,
                                _next.text,
                              ),
                            );
                        if (mounted) {
                          ref.read(settingsPageProvider.notifier).state =
                              SettingsPage.account;
                        }
                      } catch (e) {
                        setState(() => _error = '$e');
                      } finally {
                        if (mounted) setState(() => _busy = false);
                      }
                    },
              child: Text(l10n.action_save),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeleteAccountPage extends ConsumerStatefulWidget {
  const _DeleteAccountPage();

  @override
  ConsumerState<_DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends ConsumerState<_DeleteAccountPage> {
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(sessionProvider).user;
    return _BackScaffold(
      title: l10n.settings_account_delete,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(l10n.settings_account_delete_confirm_body),
            const SizedBox(height: 12),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.password),
            ),
            const SizedBox(height: 16),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await ref.read(apiClientProvider).deleteAccount(
                      password: PasswordHash.deriveAuthSecret(
                        user?.username ?? '',
                        _password.text,
                      ),
                    );
                await ref.read(sessionProvider.notifier).logout();
              },
              child: Text(l10n.settings_delete_account_button),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServerConfigPage extends ConsumerStatefulWidget {
  const _ServerConfigPage();

  @override
  ConsumerState<_ServerConfigPage> createState() => _ServerConfigPageState();
}

class _ServerConfigPageState extends ConsumerState<_ServerConfigPage> {
  late final TextEditingController _host;
  bool _https = true;
  String? _status;

  @override
  void initState() {
    super.initState();
    final c = ref.read(serverConfigProvider);
    _host = TextEditingController(
      text: c.apiPort == 443 ? c.serverIp : '${c.serverIp}:${c.apiPort}',
    );
    _https = c.httpsEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _BackScaffold(
      title: l10n.server_config_title,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _host,
              decoration: InputDecoration(
                labelText: l10n.server_ip_label,
                hintText: l10n.server_ip_hint,
              ),
            ),
            SwitchListTile(
              title: Text(l10n.server_config_https_headline),
              subtitle: Text(l10n.server_config_https_hint),
              value: _https,
              onChanged: (v) => setState(() => _https = v),
            ),
            if (_status != null) Text(_status!),
            FilledButton(
              onPressed: () async {
                final raw = _host.text.trim();
                var host = raw;
                var port = 443;
                final idx = raw.lastIndexOf(':');
                if (idx > 0 &&
                    raw.substring(idx + 1).isNotEmpty &&
                    int.tryParse(raw.substring(idx + 1)) != null) {
                  host = raw.substring(0, idx);
                  port = int.parse(raw.substring(idx + 1));
                }
                final config = ServerConfigData(
                  serverIp: host,
                  apiPort: port,
                  callsPort: port,
                  httpsEnabled: _https,
                );
                await ref.read(sessionProvider.notifier).updateServer(config);
                final id = await ref.read(apiClientProvider).probeInstanceId();
                setState(() => _status = id != null
                    ? l10n.server_config_snackbar_ok_calls_skip('0')
                    : l10n.auth_server_connect_failed);
              },
              child: Text(l10n.action_save),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutPage extends StatelessWidget {
  const _AboutPage();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _BackScaffold(
      title: l10n.about,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(l10n.app_name, style: Theme.of(context).textTheme.headlineSmall),
          Text(l10n.about_version),
          const SizedBox(height: 12),
          Text(l10n.app_desc),
          const SizedBox(height: 16),
          ListTile(
            title: Text(l10n.about_link_telegram),
            onTap: () => launchUrl(Uri.parse('https://t.me/fromchat_ch')),
          ),
          ListTile(
            title: Text(l10n.about_link_website),
            onTap: () => launchUrl(Uri.parse('https://fromchat.ru')),
          ),
          ListTile(
            title: Text(l10n.legal_privacy_title),
            onTap: () =>
                launchUrl(Uri.parse('https://fromchat.ru/privacy')),
          ),
          ListTile(
            title: Text(l10n.legal_terms_title),
            onTap: () => launchUrl(Uri.parse('https://fromchat.ru/terms')),
          ),
        ],
      ),
    );
  }
}

class _LogsPage extends StatelessWidget {
  const _LogsPage();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _BackScaffold(
      title: l10n.logs_title,
      child: Center(child: Text(l10n.logs_empty)),
    );
  }
}

class ProfilePane extends ConsumerStatefulWidget {
  const ProfilePane({super.key, this.user});

  final User? user;

  @override
  ConsumerState<ProfilePane> createState() => _ProfilePaneState();
}

class _ProfilePaneState extends ConsumerState<ProfilePane> {
  late final TextEditingController _display;
  late final TextEditingController _bio;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _display = TextEditingController(text: widget.user?.displayName ?? '');
    _bio = TextEditingController(text: widget.user?.bio ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(sessionProvider).user ?? widget.user;
    if (user == null) {
      return Center(child: Text(l10n.profile));
    }
    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        CircleAvatar(
          radius: 48,
          child: Text(
            user.displayLabel.characters.first.toUpperCase(),
            style: const TextStyle(fontSize: 36),
          ),
        ),
        const SizedBox(height: 16),
        Text('@${user.username}',
            style: Theme.of(context).textTheme.titleMedium),
        if (!_editing) ...[
          Text(user.displayLabel,
              style: Theme.of(context).textTheme.headlineSmall),
          if (user.bio != null) Text(user.bio!),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => setState(() => _editing = true),
            child: Text(l10n.action_edit),
          ),
        ] else ...[
          TextField(
            controller: _display,
            decoration: InputDecoration(labelText: l10n.display_name),
          ),
          TextField(
            controller: _bio,
            decoration: InputDecoration(labelText: l10n.profile_headline_bio),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () async {
              final updated = await ref.read(apiClientProvider).updateProfile({
                'display_name': _display.text,
                'bio': _bio.text,
              });
              await ref.read(sessionProvider.notifier).updateUser(updated);
              setState(() => _editing = false);
            },
            child: Text(l10n.action_save),
          ),
        ],
      ],
    );
  }
}
