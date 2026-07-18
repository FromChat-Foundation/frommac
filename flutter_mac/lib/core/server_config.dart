class ServerConfigData {
  const ServerConfigData({
    required this.serverIp,
    required this.apiPort,
    required this.callsPort,
    required this.httpsEnabled,
    this.callsEnabled = true,
  });

  final String serverIp;
  final int apiPort;
  final int callsPort;
  final bool httpsEnabled;
  final bool callsEnabled;

  /// Production defaults.
  static const defaults = ServerConfigData(
    serverIp: 'api.fromchat.ru',
    apiPort: 443,
    callsPort: 443,
    httpsEnabled: true,
    callsEnabled: true,
  );

  /// Local DEV CORS proxy for HTTP only (`tool/run_web.sh`).
  static const webProxyDefaults = ServerConfigData(
    serverIp: '127.0.0.1',
    apiPort: 8787,
    callsPort: 8787,
    httpsEnabled: false,
    callsEnabled: false,
  );

  /// True when Flutter was started with `--dart-define=FROMCHAT_WEB_PROXY=...`.
  static bool get usesDevHttpProxy =>
      const String.fromEnvironment('FROMCHAT_WEB_PROXY').isNotEmpty;

  /// Real API host for WS/LiveKit while HTTP goes through the local proxy.
  static const devUpstreamHost = 'api.fromchat.ru';

  /// When built with `--dart-define=FROMCHAT_WEB_PROXY=host:port`, use the proxy.
  static ServerConfigData get effectiveDefaults {
    const proxy = String.fromEnvironment('FROMCHAT_WEB_PROXY');
    if (proxy.isNotEmpty) {
      final parts = proxy.split(':');
      final host = parts.first;
      final port = parts.length > 1 ? int.tryParse(parts[1]) ?? 8787 : 8787;
      return ServerConfigData(
        serverIp: host,
        apiPort: port,
        callsPort: port,
        httpsEnabled: false,
        callsEnabled: false,
      );
    }
    return defaults;
  }

  String get apiBaseUrl {
    final scheme = httpsEnabled ? 'https' : 'http';
    return '$scheme://$serverIp:$apiPort';
  }

  /// Chat WebSocket. In DEV proxy mode HTTP is local, but WS must hit the real
  /// API (`wss://`) — the Python CORS proxy does not upgrade WebSockets.
  String get webSocketUrl {
    if (usesDevHttpProxy) {
      return 'wss://$devUpstreamHost/chat/ws';
    }
    final scheme = httpsEnabled ? 'wss' : 'ws';
    return '$scheme://$serverIp:$apiPort/chat/ws';
  }

  String get liveKitWsUrl {
    if (usesDevHttpProxy) {
      return 'wss://$devUpstreamHost';
    }
    final scheme = httpsEnabled ? 'wss' : 'ws';
    return '$scheme://$serverIp:$apiPort';
  }

  String get liveKitSignalingWsUrl {
    if (usesDevHttpProxy) {
      return 'wss://$devUpstreamHost/livekit/rtc';
    }
    final scheme = httpsEnabled ? 'wss' : 'ws';
    return '$scheme://$serverIp:$apiPort/livekit/rtc';
  }

  ServerConfigData copyWith({
    String? serverIp,
    int? apiPort,
    int? callsPort,
    bool? httpsEnabled,
    bool? callsEnabled,
  }) =>
      ServerConfigData(
        serverIp: serverIp ?? this.serverIp,
        apiPort: apiPort ?? this.apiPort,
        callsPort: callsPort ?? this.callsPort,
        httpsEnabled: httpsEnabled ?? this.httpsEnabled,
        callsEnabled: callsEnabled ?? this.callsEnabled,
      );
}

enum AppThemeMode { asSystem, light, dark }
