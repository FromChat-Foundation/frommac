import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/server_config.dart';
import '../../l10n/app_localizations.dart';
import '../session/session_controller.dart';

Future<void> showServerSetupSheet(BuildContext context, WidgetRef ref) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => const _ServerDialog(),
  );
}

class _ServerDialog extends ConsumerStatefulWidget {
  const _ServerDialog();

  @override
  ConsumerState<_ServerDialog> createState() => _ServerDialogState();
}

class _ServerDialogState extends ConsumerState<_ServerDialog> {
  late final TextEditingController _host;
  bool _https = true;

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
  void dispose() {
    _host.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.server_config_title),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _host,
              decoration: InputDecoration(
                labelText: l10n.server_ip_label,
                hintText: l10n.server_ip_hint,
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.server_config_https_headline),
              value: _https,
              onChanged: (v) => setState(() => _https = v),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.back),
        ),
        FilledButton(
          onPressed: () async {
            final raw = _host.text.trim();
            var host = raw;
            var port = 443;
            final idx = raw.lastIndexOf(':');
            if (idx > 0 && int.tryParse(raw.substring(idx + 1)) != null) {
              host = raw.substring(0, idx);
              port = int.parse(raw.substring(idx + 1));
            }
            await ref.read(sessionProvider.notifier).updateServer(
                  ServerConfigData(
                    serverIp: host,
                    apiPort: port,
                    callsPort: port,
                    httpsEnabled: _https,
                  ),
                );
            if (context.mounted) Navigator.pop(context);
          },
          child: Text(l10n.action_save),
        ),
      ],
    );
  }
}
