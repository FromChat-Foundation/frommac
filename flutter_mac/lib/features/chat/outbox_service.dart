import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/providers.dart';
import '../../models/models.dart';
import '../session/session_controller.dart';
import 'file_bytes_loader.dart';

final outboxServiceProvider = Provider<OutboxService>((ref) {
  return OutboxService(ref);
});

class OutboxService {
  OutboxService(this._ref);

  final Ref _ref;
  final _uuid = const Uuid();

  /// In-memory bytes for pending uploads (web + desktop).
  final Map<String, Uint8List> _pendingBytes = {};

  Future<void> enqueueFile({
    required SelectedChat chat,
    required String filename,
    String? path,
    Uint8List? bytes,
  }) async {
    final session = _ref.read(sessionProvider);
    if (!session.isLoggedIn) return;
    final clientId = _uuid.v4();
    final convId = switch (chat) {
      PublicChatSelection() => 'public',
      DmChatSelection(:final otherUserId) => 'dm:$otherUserId',
    };

    Uint8List? data = bytes;
    if (data == null && path != null) {
      data = await loadFileBytes(path);
    }
    if (data == null) return;
    _pendingBytes[clientId] = data;

    await _ref.read(messageDbProvider).enqueueOutbox(
          instanceId: session.instanceId,
          clientMessageId: clientId,
          conversationId: convId,
          kind: 'file',
          payloadJson: jsonEncode({
            'filename': filename,
            if (path != null) 'path': path,
          }),
        );
    await processPending();
  }

  Future<void> processPending() async {
    final session = _ref.read(sessionProvider);
    if (!session.isLoggedIn) return;
    final db = _ref.read(messageDbProvider);
    final api = _ref.read(apiClientProvider);
    final rows = await db.pendingOutbox(session.instanceId);
    for (final row in rows) {
      final kind = row['kind'] as String;
      final clientId = row['clientMessageId'] as String;
      final convId = row['conversationId'] as String;
      final payload = jsonDecode(row['payloadJson'] as String) as Map<String, dynamic>;
      try {
        if (kind != 'file') continue;
        var bytes = _pendingBytes[clientId];
        final path = payload['path'] as String?;
        final name = payload['filename'] as String? ?? 'file';
        bytes ??= path != null ? await loadFileBytes(path) : null;
        if (bytes == null) continue;

        if (convId == 'public') {
          await api.sendPublicMessage(
            content: '',
            clientMessageId: clientId,
            files: [
              MultipartFile.fromBytes(bytes, filename: name),
            ],
          );
        } else if (convId.startsWith('dm:')) {
          final start = await api.startDmUpload(
            filename: name,
            size: bytes.length,
            contentType: 'application/octet-stream',
          );
          final uploadId = start['upload_id'] as String? ??
              start['uploadId'] as String?;
          if (uploadId == null) throw StateError('No upload id');
          const chunk = 256 * 1024;
          var index = 0;
          for (var offset = 0; offset < bytes.length; offset += chunk) {
            final end = (offset + chunk < bytes.length)
                ? offset + chunk
                : bytes.length;
            await api.uploadDmChunk(
              uploadId: uploadId,
              index: index++,
              bytes: bytes.sublist(offset, end),
            );
          }
          await api.completeDmUpload(uploadId);
          await _ref.read(sessionProvider.notifier).sendText(
                chat: DmChatSelection(int.parse(convId.substring(3))),
                text: '📎 $name',
              );
        }
        _pendingBytes.remove(clientId);
        await db.deleteOutbox(session.instanceId, clientId);
      } catch (_) {
        // leave in outbox for retry
      }
    }
  }
}
