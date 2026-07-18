import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/fromchat_theme.dart';
import 'auth_screen.dart';
import 'server_setup_sheet.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => showServerSetupSheet(context, ref),
                  icon: const Icon(Icons.dns_outlined),
                  label: Text(l10n.change_server),
                ),
              ),
              const Spacer(),
              Center(child: BrandTitle(fontSize: 48)),
              const SizedBox(height: 16),
              Text(
                l10n.auth_welcome_title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.auth_welcome_tagline,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AuthScreen()),
                  );
                },
                child: Text(l10n.auth_get_started),
              ),
              const SizedBox(height: 12),
              Text(
                '${l10n.auth_legal_notice_prefix}${l10n.legal_terms_title}${l10n.auth_legal_notice_and}${l10n.legal_privacy_title}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
