import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef WsHandler = void Function(Map<String, dynamic> message);

class WebSocketManager {
  WebSocketManager({
    required this.urlProvider,
    required this.tokenProvider,
    required this.onMessage,
    this.onConnected,
    this.onDisconnected,
  });

  final String Function() urlProvider;
  final String? Function() tokenProvider;
  final WsHandler onMessage;
  final void Function()? onConnected;
  final void Function()? onDisconnected;

  WebSocketChannel? _channel;
  StreamSubscription? _sub;
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  bool _wantConnected = false;
  bool _opening = false;
  int _backoffMs = 2000;
  int _generation = 0;

  bool get isConnected => _channel != null;

  Future<void> connect() async {
    _wantConnected = true;
    await _open();
  }

  Future<void> disconnect() async {
    _wantConnected = false;
    _reconnectTimer?.cancel();
    _pingTimer?.cancel();
    _generation++;
    await _sub?.cancel();
    _sub = null;
    try {
      await _channel?.sink.close();
    } catch (_) {}
    _channel = null;
    _opening = false;
    onDisconnected?.call();
  }

  Future<void> _open() async {
    if (!_wantConnected || _opening) return;
    final token = tokenProvider();
    if (token == null || token.isEmpty) return;

    _opening = true;
    final gen = ++_generation;
    _reconnectTimer?.cancel();

    try {
      await _sub?.cancel();
      _sub = null;
      try {
        await _channel?.sink.close();
      } catch (_) {}
      _channel = null;

      final url = urlProvider();
      debugPrint('[ws] connecting $url');
      final channel = WebSocketChannel.connect(Uri.parse(url));

      // Connection failures surface on [ready], not only on the stream.
      await channel.ready.timeout(const Duration(seconds: 20));
      if (!_wantConnected || gen != _generation) {
        try {
          await channel.sink.close();
        } catch (_) {}
        return;
      }

      _channel = channel;
      _sub = channel.stream.listen(
        (event) {
          try {
            final map = jsonDecode(event as String) as Map<String, dynamic>;
            onMessage(map);
          } catch (_) {}
        },
        onDone: () {
          if (gen == _generation) _scheduleReconnect('done');
        },
        onError: (Object e, StackTrace st) {
          // Swallow — reconnect quietly (avoids RethrownDartError spam on web).
          debugPrint('[ws] stream error: $e');
          if (gen == _generation) _scheduleReconnect('error');
        },
        cancelOnError: true,
      );

      send({
        'type': 'ping',
        'credentials': {'scheme': 'Bearer', 'credentials': token},
      });
      _backoffMs = 2000;
      _pingTimer?.cancel();
      _pingTimer = Timer.periodic(const Duration(seconds: 25), (_) {
        final t = tokenProvider();
        if (t == null) return;
        send({
          'type': 'ping',
          'credentials': {'scheme': 'Bearer', 'credentials': t},
        });
      });
      debugPrint('[ws] connected');
      onConnected?.call();
    } catch (e) {
      debugPrint('[ws] connect failed: $e');
      _channel = null;
      if (_wantConnected && gen == _generation) {
        _scheduleReconnect('connect_failed');
      }
    } finally {
      if (gen == _generation) _opening = false;
    }
  }

  void _scheduleReconnect(String reason) {
    onDisconnected?.call();
    _pingTimer?.cancel();
    _channel = null;
    if (!_wantConnected) return;
    _reconnectTimer?.cancel();
    final delay = _backoffMs;
    debugPrint('[ws] reconnect in ${delay}ms ($reason)');
    _reconnectTimer = Timer(Duration(milliseconds: delay), () {
      if (_wantConnected) unawaited(_open());
    });
    _backoffMs = (_backoffMs * 2).clamp(2000, 60000);
  }

  void send(Map<String, dynamic> message) {
    final channel = _channel;
    if (channel == null) return;
    try {
      channel.sink.add(jsonEncode(message));
    } catch (e) {
      debugPrint('[ws] send failed: $e');
    }
  }

  void sendPublicMessage({
    required String content,
    String? clientMessageId,
    int? replyToId,
  }) {
    send({
      'type': 'sendMessage',
      'data': {
        'content': content,
        if (clientMessageId != null) 'client_message_id': clientMessageId,
        if (replyToId != null) 'reply_to_id': replyToId,
      },
    });
  }

  void sendTyping({required bool dm, int? recipientId}) {
    if (dm && recipientId != null) {
      send({
        'type': 'dmTyping',
        'data': {'recipientId': recipientId},
      });
    } else {
      send({'type': 'typing'});
    }
  }

  void stopTyping({required bool dm, int? recipientId}) {
    if (dm && recipientId != null) {
      send({
        'type': 'stopDmTyping',
        'data': {'recipientId': recipientId},
      });
    } else {
      send({'type': 'stopTyping'});
    }
  }

  void getUpdates(int lastSeq) {
    send({
      'type': 'getUpdates',
      'data': {'lastSeq': lastSeq},
    });
  }

  void callSignaling(Map<String, dynamic> data) {
    send({'type': 'call_signaling', 'data': data});
  }

  void subscribeStatus(int userId) {
    send({
      'type': 'subscribeStatus',
      'data': {'userId': userId},
    });
  }
}
