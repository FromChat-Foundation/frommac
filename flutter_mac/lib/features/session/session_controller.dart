import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../api/api_client.dart';
import '../../core/providers.dart';
import '../../core/server_config.dart';
import '../../crypto/dm_crypto.dart';
import '../../crypto/password_hash.dart';
import '../../crypto/transport_crypto.dart';
import '../../models/models.dart';
import '../calls/call_store.dart';
import '../chats/chat_list_controller.dart';
import '../chat/messages_controller.dart';

class SessionState {
  const SessionState({
    this.token,
    this.user,
    this.instanceId = 'default',
    this.ready = false,
    this.wsConnected = false,
    this.authError,
  });

  final String? token;
  final User? user;
  final String instanceId;
  final bool ready;
  final bool wsConnected;
  final String? authError;

  bool get isLoggedIn => token != null && user != null;

  SessionState copyWith({
    String? token,
    User? user,
    String? instanceId,
    bool? ready,
    bool? wsConnected,
    String? authError,
    bool clearAuthError = false,
    bool clearSession = false,
  }) =>
      SessionState(
        token: clearSession ? null : (token ?? this.token),
        user: clearSession ? null : (user ?? this.user),
        instanceId: instanceId ?? this.instanceId,
        ready: ready ?? this.ready,
        wsConnected: wsConnected ?? this.wsConnected,
        authError: clearAuthError ? null : (authError ?? this.authError),
      );
}

final sessionProvider =
    StateNotifierProvider<SessionController, SessionState>((ref) {
  return SessionController(ref);
});

class SessionController extends StateNotifier<SessionState> {
  SessionController(this._ref) : super(const SessionState()) {
    // Defer so apiClientProvider/webSocketProvider can finish without a cycle.
    Future.microtask(_bootstrap);
  }

  final Ref _ref;
  final _uuid = const Uuid();
  Timer? _wsDisconnectBanner;

  void _wireApiHooks(ApiClient api) {
    api.attachSessionHooks(
      onUnauthorized: handleUnauthorized,
      onInstanceId: handleInstanceId,
    );
  }

  Future<void> _bootstrap() async {
    final settings = _ref.read(appSettingsProvider);
    final api = _ref.read(apiClientProvider);
    _wireApiHooks(api);
    final token = await settings.getAuthToken();
    final user = settings.getUserInfo();
    final instance = settings.lastInstanceId ?? 'default';
    if (token != null && user != null) {
      state = SessionState(
        token: token,
        user: user,
        instanceId: instance,
        ready: true,
      );
      api.bindSession(token);
      await _ref.read(identityKeyManagerProvider).restoreFromLocal();
      unawaited(_afterLogin());
    } else {
      state = const SessionState(ready: true);
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final api = _ref.read(apiClientProvider);
    _wireApiHooks(api);
    final derived = PasswordHash.deriveAuthSecret(username, password);
    final res = await api.login(username: username, password: derived);
    await _completeAuth(res);
  }

  Future<void> register({
    required String username,
    required String displayName,
    required String password,
    required String confirmPassword,
    String? bio,
  }) async {
    final api = _ref.read(apiClientProvider);
    _wireApiHooks(api);
    final derived = PasswordHash.deriveAuthSecret(username, password);
    final confirmDerived =
        PasswordHash.deriveAuthSecret(username, confirmPassword);
    final res = await api.register(
      username: username,
      displayName: displayName,
      password: derived,
      confirmPassword: confirmDerived,
      bio: bio,
    );
    await _completeAuth(res);
  }

  Future<void> _completeAuth(LoginResponse res) async {
    final api = _ref.read(apiClientProvider);
    _wireApiHooks(api);
    final settings = _ref.read(appSettingsProvider);
    api.bindSession(res.token);
    await _ref.read(identityKeyManagerProvider).ensureKeysOnLogin();
    await settings.setAuthToken(res.token);
    await settings.setUserInfo(res.user);
    state = SessionState(
      token: res.token,
      user: res.user,
      instanceId: state.instanceId,
      ready: true,
    );
    await _afterLogin();
  }

  Future<void> _afterLogin() async {
    try {
      final ws = _ref.read(webSocketProvider);
      await ws.connect();
      final seq = _ref
          .read(appSettingsProvider)
          .getUpdatesSeq(state.user?.id ?? 0);
      ws.getUpdates(seq);
      // Defer list sync so we are outside the auth provider stack.
      await Future<void>.delayed(Duration.zero);
      await _ref.read(chatListProvider.notifier).refresh();
    } catch (e, st) {
      // Auth succeeded; realtime/list failures should not fail register/login.
      assert(() {
        // ignore: avoid_print
        print('afterLogin error: $e\n$st');
        return true;
      }());
    }
  }

  Future<void> logout() async {
    _wsDisconnectBanner?.cancel();
    final api = _ref.read(apiClientProvider);
    await api.logout();
    await _ref.read(webSocketProvider).disconnect();
    await _ref.read(appSettingsProvider).clearSession();
    await _ref.read(identityKeyManagerProvider).clear();
    api.clearSession();
    state = const SessionState(ready: true);
  }

  void handleUnauthorized() {
    unawaited(logout());
    state = state.copyWith(
      clearSession: true,
      ready: true,
      authError: 'unauthorized',
    );
  }

  void handleInstanceId(String id) {
    unawaited(_ref.read(appSettingsProvider).setLastInstanceId(id));
    state = state.copyWith(instanceId: id);
    unawaited(
      _ref.read(messageDbProvider).setActiveInstance(
            _ref.read(serverConfigProvider).apiBaseUrl,
            id,
          ),
    );
  }

  void setWsConnected(bool value) {
    if (value) {
      _wsDisconnectBanner?.cancel();
      _wsDisconnectBanner = null;
      if (!state.wsConnected) {
        state = state.copyWith(wsConnected: true);
      }
      return;
    }
    // Avoid flashing "Connecting…" on brief reconnects.
    _wsDisconnectBanner?.cancel();
    _wsDisconnectBanner = Timer(const Duration(seconds: 2), () {
      if (!state.wsConnected) return;
      state = state.copyWith(wsConnected: false);
    });
  }

  void handleWsMessage(Map<String, dynamic> message) {
    final type = message['type'] as String? ?? '';
    switch (type) {
      case 'updates':
        final data = message['data'] as Map<String, dynamic>? ?? {};
        final seq = data['seq'] as int?;
        if (seq != null && state.user != null) {
          unawaited(
            _ref.read(appSettingsProvider).setUpdatesSeq(state.user!.id, seq),
          );
        }
        final updates = data['updates'] as List? ?? [];
        for (final u in updates) {
          if (u is Map<String, dynamic>) handleWsMessage(u);
        }
      case 'newMessage':
      case 'messageEdited':
        final msg = message['data']?['message'] ?? message['message'];
        if (msg is Map<String, dynamic>) {
          _ref.read(messagesProvider.notifier).ingestPublic(msg);
          _ref.read(chatListProvider.notifier).onPublicPreview(msg);
        }
      case 'dmNew':
      case 'dmEdited':
        final env = message['data']?['message'] ??
            message['data'] ??
            message['message'];
        if (env is Map<String, dynamic>) {
          unawaited(_ref.read(messagesProvider.notifier).ingestDm(env));
          unawaited(_ref.read(chatListProvider.notifier).refresh());
        }
      case 'call_signaling':
        _ref.read(callStoreProvider.notifier).onSignaling(
              message['data'] as Map<String, dynamic>? ?? {},
            );
      case 'statusUpdate':
        _ref.read(chatListProvider.notifier).onStatusUpdate(
              message['data'] as Map<String, dynamic>? ?? {},
            );
      default:
        break;
    }
  }

  Future<void> sendText({
    required SelectedChat chat,
    required String text,
  }) async {
    final clientId = _uuid.v4();
    final user = state.user;
    if (user == null) return;
    if (chat is PublicChatSelection) {
      _ref.read(messagesProvider.notifier).addOptimisticPublic(
            content: text,
            clientMessageId: clientId,
            user: user,
          );
      _ref.read(webSocketProvider).sendPublicMessage(
            content: text,
            clientMessageId: clientId,
          );
      return;
    }
    if (chat is DmChatSelection) {
      await _sendDm(chat.otherUserId, text, clientId);
    }
  }

  Future<void> _sendDm(int recipientId, String text, String clientId) async {
    final api = _ref.read(apiClientProvider);
    final user = state.user!;
    final transport = await api.transportPublicKey();
    final transportKey = transport['public_key_b64'] as String? ??
        transport['publicKey'] as String?;
    if (transportKey == null) {
      throw StateError('No transport key');
    }
    final recipientKey = await api.fetchPublicKeyOf(recipientId);
    final identity = await _ref.read(identityKeyManagerProvider).restoreFromLocal() ??
        await _ref.read(identityKeyManagerProvider).ensureKeysOnLogin();
    final cipher = TransportCrypto.encryptWithTransportKey(
      plaintext: text,
      transportPublicKeyB64: transportKey,
    );
    _ref.read(messagesProvider.notifier).addOptimisticDm(
          content: text,
          clientMessageId: clientId,
          user: user,
          otherUserId: recipientId,
        );
    await api.sendDm({
      'recipient_id': recipientId,
      'client_public_key_b64': cipher.clientPublicKeyB64,
      'transport_nonce_b64': cipher.nonceB64,
      'transport_ciphertext_b64': cipher.ciphertextB64,
      'sender_public_key_b64': identity.publicKeyB64,
      if (recipientKey != null) 'recipient_public_key_b64': recipientKey,
      'client_message_id': clientId,
    });
  }

  Future<String> decryptDmEnvelope(DmEnvelope envelope) async {
    final identity = await _ref.read(identityKeyManagerProvider).restoreFromLocal();
    if (identity == null || envelope.wrappedMekB64 == null) {
      return DmEnvelopeCrypto.corruptedPlaceholder;
    }
    try {
      return await DmEnvelopeCrypto.decryptEnvelope(
        ivB64: envelope.ivB64,
        ciphertextB64: envelope.ciphertextB64,
        wrappedMekB64: envelope.wrappedMekB64!,
        identityPublicKey: identity.publicKey,
        isRecipient: envelope.recipientId == state.user?.id,
      );
    } catch (_) {
      return DmEnvelopeCrypto.corruptedPlaceholder;
    }
  }

  Future<void> updateServer(ServerConfigData config) async {
    await _ref.read(serverConfigProvider.notifier).update(config);
    _ref.read(apiClientProvider).updateConfig(config);
  }

  Future<void> updateUser(User user) async {
    await _ref.read(appSettingsProvider).setUserInfo(user);
    state = state.copyWith(user: user);
  }
}
