import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_client.dart';
import '../api/websocket_manager.dart';
import '../core/app_settings.dart';
import '../core/server_config.dart';
import '../crypto/identity_key_manager.dart';
import '../db/message_database.dart';
import '../features/session/session_controller.dart';

final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('override in main');
});

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

final appSettingsProvider = Provider<AppSettings>((ref) {
  return AppSettings(
    ref.watch(sharedPrefsProvider),
    ref.watch(secureStorageProvider),
  );
});

final serverConfigProvider =
    StateNotifierProvider<ServerConfigNotifier, ServerConfigData>((ref) {
  final settings = ref.watch(appSettingsProvider);
  return ServerConfigNotifier(settings);
});

class ServerConfigNotifier extends StateNotifier<ServerConfigData> {
  ServerConfigNotifier(this._settings) : super(_settings.loadServerConfig());

  final AppSettings _settings;

  Future<void> update(ServerConfigData config) async {
    await _settings.saveServerConfig(config);
    state = config;
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, AppThemeMode>((ref) {
  return ThemeModeNotifier(ref.watch(appSettingsProvider));
});

class ThemeModeNotifier extends StateNotifier<AppThemeMode> {
  ThemeModeNotifier(this._settings) : super(_settings.themeMode);

  final AppSettings _settings;

  Future<void> setMode(AppThemeMode mode) async {
    await _settings.setThemeMode(mode);
    state = mode;
  }
}

final messageDbProvider = Provider<MessageDatabase>((ref) {
  throw UnimplementedError('override in main');
});

/// No dependency on [sessionProvider] — SessionController wires hooks itself.
final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(serverConfigProvider);
  final client = ApiClient(config: config);
  ref.listen(serverConfigProvider, (_, next) => client.updateConfig(next));
  return client;
});

final identityKeyManagerProvider = Provider<IdentityKeyManager>((ref) {
  return IdentityKeyManager(
    ref.watch(secureStorageProvider),
    // Lazy: avoid create-time coupling if ApiClient is mid-init.
    apiGetter: () => ref.read(apiClientProvider),
  );
});

final webSocketProvider = Provider<WebSocketManager>((ref) {
  final manager = WebSocketManager(
    urlProvider: () => ref.read(serverConfigProvider).webSocketUrl,
    tokenProvider: () => ref.read(sessionProvider).token,
    onMessage: (msg) => ref.read(sessionProvider.notifier).handleWsMessage(msg),
    onConnected: () => ref.read(sessionProvider.notifier).setWsConnected(true),
    onDisconnected: () =>
        ref.read(sessionProvider.notifier).setWsConnected(false),
  );
  ref.onDispose(manager.disconnect);
  return manager;
});

ThemeMode mapAppTheme(AppThemeMode mode) => switch (mode) {
      AppThemeMode.asSystem => ThemeMode.system,
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
    };
