import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers.dart';
import 'features/auth/welcome_screen.dart';
import 'features/session/session_controller.dart';
import 'l10n/app_localizations.dart';
import 'shell/mac_shell.dart';
import 'theme/fromchat_theme.dart';

class FromChatApp extends ConsumerWidget {
  const FromChatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final session = ref.watch(sessionProvider);

    return MaterialApp(
      title: 'FromChat',
      debugShowCheckedModeBanner: false,
      theme: FromChatTheme.light(),
      darkTheme: FromChatTheme.dark(),
      themeMode: mapAppTheme(themeMode),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: !session.ready
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : session.isLoggedIn
              ? const MacShell()
              : const WelcomeScreen(),
    );
  }
}
