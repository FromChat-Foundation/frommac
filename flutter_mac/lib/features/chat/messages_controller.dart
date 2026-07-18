import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../crypto/dm_crypto.dart';
import '../../models/models.dart';
import '../session/session_controller.dart';

class MessagesState {
  const MessagesState({
    this.messages = const [],
    this.loading = false,
    this.chat,
    this.typing = false,
  });

  final List<ChatMessage> messages;
  final bool loading;
  final SelectedChat? chat;
  final bool typing;

  MessagesState copyWith({
    List<ChatMessage>? messages,
    bool? loading,
    SelectedChat? chat,
    bool? typing,
    bool clearChat = false,
  }) =>
      MessagesState(
        messages: messages ?? this.messages,
        loading: loading ?? this.loading,
        chat: clearChat ? null : (chat ?? this.chat),
        typing: typing ?? this.typing,
      );
}

final selectedChatProvider = StateProvider<SelectedChat?>((ref) => null);

final messagesProvider =
    StateNotifierProvider<MessagesController, MessagesState>((ref) {
  return MessagesController(ref);
});

class MessagesController extends StateNotifier<MessagesState> {
  MessagesController(this._ref) : super(const MessagesState());

  final Ref _ref;

  Future<void> open(SelectedChat chat) async {
    state = MessagesState(loading: true, chat: chat);
    final session = _ref.read(sessionProvider);
    final api = _ref.read(apiClientProvider);
    final db = _ref.read(messageDbProvider);
    final instanceId = session.instanceId;

    if (chat is PublicChatSelection) {
      try {
        final msgs = await api.getPublicMessages(
          limit: 80,
          currentUserId: session.user?.id,
        );
        for (final m in msgs) {
          await db.upsertMessage(
            instanceId: instanceId,
            id: m.id,
            conversationId: 'public',
            userId: m.userId,
            content: m.content,
            timestamp: m.timestamp,
            isRead: m.isRead,
            isEdited: m.isEdited,
            clientMessageId: m.clientMessageId,
            username: m.username,
          );
        }
        state = MessagesState(messages: msgs, chat: chat);
      } catch (_) {
        final rows = await db.messagesFor(instanceId, 'public');
        state = MessagesState(
          chat: chat,
          messages: rows
              .map(
                (r) => ChatMessage(
                  id: r['id'] as int,
                  userId: r['userId'] as int,
                  content: r['content'] as String,
                  timestamp: r['timestamp'] as String,
                  isRead: (r['isRead'] as int) == 1,
                  isEdited: (r['isEdited'] as int) == 1,
                  username: r['username'] as String? ?? '',
                  isMine: r['userId'] == session.user?.id,
                ),
              )
              .toList(),
        );
      }
      return;
    }

    if (chat is DmChatSelection) {
      final convId = 'dm:${chat.otherUserId}';
      try {
        final envs = await api.dmHistory(chat.otherUserId, limit: 80);
        final msgs = <ChatMessage>[];
        for (final env in envs.reversed) {
          final content =
              await _ref.read(sessionProvider.notifier).decryptDmEnvelope(env);
          final corrupted = content == DmEnvelopeCrypto.corruptedPlaceholder;
          final m = ChatMessage(
            id: env.id,
            userId: env.senderId,
            content: content,
            timestamp: env.timestamp,
            isRead: true,
            isEdited: false,
            username: env.senderUsername ?? '',
            clientMessageId: env.clientMessageId,
            replyToId: env.replyToId,
            isContentCorrupted: corrupted,
            isMine: env.senderId == session.user?.id,
            files: env.files,
          );
          msgs.add(m);
          await db.upsertMessage(
            instanceId: instanceId,
            id: m.id,
            conversationId: convId,
            userId: m.userId,
            content: m.content,
            timestamp: m.timestamp,
            isRead: true,
            isEdited: false,
            clientMessageId: m.clientMessageId,
            username: m.username,
          );
        }
        await api.markDmRead(chat.otherUserId);
        state = MessagesState(messages: msgs, chat: chat);
      } catch (_) {
        final rows = await db.messagesFor(instanceId, convId);
        state = MessagesState(
          chat: chat,
          messages: rows
              .map(
                (r) => ChatMessage(
                  id: r['id'] as int,
                  userId: r['userId'] as int,
                  content: r['content'] as String,
                  timestamp: r['timestamp'] as String,
                  isRead: true,
                  isEdited: false,
                  username: r['username'] as String? ?? '',
                  isMine: r['userId'] == session.user?.id,
                ),
              )
              .toList(),
        );
      }
    }
  }

  void ingestPublic(Map<String, dynamic> json) {
    final session = _ref.read(sessionProvider);
    final msg = ChatMessage.fromPublicJson(
      json,
      currentUserId: session.user?.id,
    );
    if (state.chat is! PublicChatSelection) return;
    final existing = state.messages.indexWhere(
      (m) =>
          m.id == msg.id ||
          (msg.clientMessageId != null &&
              m.clientMessageId == msg.clientMessageId),
    );
    final list = [...state.messages];
    if (existing >= 0) {
      list[existing] = msg;
    } else {
      list.add(msg);
    }
    state = state.copyWith(messages: list);
  }

  Future<void> ingestDm(Map<String, dynamic> json) async {
    final env = DmEnvelope.fromJson(json);
    final session = _ref.read(sessionProvider);
    final chat = state.chat;
    if (chat is! DmChatSelection) return;
    final other = chat.otherUserId;
    if (env.senderId != other && env.recipientId != other) return;
    final content =
        await _ref.read(sessionProvider.notifier).decryptDmEnvelope(env);
    final msg = ChatMessage(
      id: env.id,
      userId: env.senderId,
      content: content,
      timestamp: env.timestamp,
      isRead: true,
      isEdited: false,
      username: env.senderUsername ?? '',
      clientMessageId: env.clientMessageId,
      isContentCorrupted: content == DmEnvelopeCrypto.corruptedPlaceholder,
      isMine: env.senderId == session.user?.id,
      files: env.files,
    );
    final existing = state.messages.indexWhere(
      (m) =>
          m.id == msg.id ||
          (msg.clientMessageId != null &&
              m.clientMessageId == msg.clientMessageId),
    );
    final list = [...state.messages];
    if (existing >= 0) {
      list[existing] = msg;
    } else {
      list.add(msg);
    }
    state = state.copyWith(messages: list);
  }

  void addOptimisticPublic({
    required String content,
    required String clientMessageId,
    required User user,
  }) {
    final msg = ChatMessage(
      id: -DateTime.now().millisecondsSinceEpoch,
      userId: user.id,
      content: content,
      timestamp: DateTime.now().toUtc().toIso8601String(),
      isRead: false,
      isEdited: false,
      username: user.username,
      clientMessageId: clientMessageId,
      isMine: true,
      sendStatus: 'sending',
    );
    state = state.copyWith(messages: [...state.messages, msg]);
  }

  void addOptimisticDm({
    required String content,
    required String clientMessageId,
    required User user,
    required int otherUserId,
  }) {
    addOptimisticPublic(
      content: content,
      clientMessageId: clientMessageId,
      user: user,
    );
  }
}
