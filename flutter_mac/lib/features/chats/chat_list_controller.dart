import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../crypto/dm_crypto.dart';
import '../../models/models.dart';
import '../session/session_controller.dart';

class ChatListItem {
  const ChatListItem({
    required this.id,
    required this.title,
    required this.preview,
    required this.selection,
    this.unread = 0,
    this.online = false,
    this.isPublic = false,
    this.updatedAt,
  });

  final String id;
  final String title;
  final String preview;
  final SelectedChat selection;
  final int unread;
  final bool online;
  final bool isPublic;
  final String? updatedAt;
}

class ChatListState {
  const ChatListState({
    this.items = const [],
    this.loading = false,
    this.filter = '',
  });

  final List<ChatListItem> items;
  final bool loading;
  final String filter;

  List<ChatListItem> get visible {
    final q = filter.trim().toLowerCase();
    if (q.isEmpty) return items;
    return items
        .where((e) => e.title.toLowerCase().contains(q))
        .toList();
  }

  ChatListState copyWith({
    List<ChatListItem>? items,
    bool? loading,
    String? filter,
  }) =>
      ChatListState(
        items: items ?? this.items,
        loading: loading ?? this.loading,
        filter: filter ?? this.filter,
      );
}

final chatListProvider =
    StateNotifierProvider<ChatListController, ChatListState>((ref) {
  return ChatListController(ref);
});

class ChatListController extends StateNotifier<ChatListState> {
  ChatListController(this._ref) : super(const ChatListState());

  final Ref _ref;

  void setFilter(String value) => state = state.copyWith(filter: value);

  Future<void> refresh() async {
    final session = _ref.read(sessionProvider);
    if (!session.isLoggedIn) return;
    state = state.copyWith(loading: true);
    final api = _ref.read(apiClientProvider);
    final instanceId = session.instanceId;
    final db = _ref.read(messageDbProvider);

    final items = <ChatListItem>[
      const ChatListItem(
        id: 'public',
        title: 'Main chat',
        preview: '',
        selection: PublicChatSelection(),
        isPublic: true,
      ),
    ];

    try {
      final convos = await api.dmConversations();
      for (final c in convos) {
        String preview = '';
        if (c.lastMessage != null) {
          preview = await _ref
              .read(sessionProvider.notifier)
              .decryptDmEnvelope(c.lastMessage!);
          if (preview == DmEnvelopeCrypto.corruptedPlaceholder) {
            preview = '🔒';
          }
        }
        final id = 'dm:${c.user.id}';
        await db.upsertConversation(
          instanceId: instanceId,
          id: id,
          type: 'dm',
          otherUserId: c.user.id,
          displayName: c.user.displayLabel,
          lastMessagePreview: preview,
          unreadCount: c.unreadCount,
          updatedAt: c.lastMessage?.timestamp,
        );
        items.add(
          ChatListItem(
            id: id,
            title: c.user.displayLabel,
            preview: preview,
            unread: c.unreadCount,
            online: c.user.online,
            selection: DmChatSelection(
              c.user.id,
              displayName: c.user.displayName,
              username: c.user.username,
            ),
            updatedAt: c.lastMessage?.timestamp,
          ),
        );
      }
    } catch (_) {
      final cached = await db.listConversations(instanceId);
      for (final row in cached) {
        if (row['type'] == 'public') continue;
        final otherId = row['otherUserId'] as int?;
        if (otherId == null) continue;
        items.add(
          ChatListItem(
            id: row['id'] as String,
            title: row['displayName'] as String? ?? 'User',
            preview: row['lastMessagePreview'] as String? ?? '',
            unread: row['unreadCount'] as int? ?? 0,
            selection: DmChatSelection(otherId),
            updatedAt: row['updatedAt'] as String?,
          ),
        );
      }
    }

    // public preview from latest local message if any
    try {
      final publics = await api.getPublicMessages(
        limit: 1,
        currentUserId: session.user?.id,
      );
      if (publics.isNotEmpty) {
        final m = publics.last;
        items[0] = ChatListItem(
          id: 'public',
          title: 'Main chat',
          preview: m.content,
          selection: const PublicChatSelection(),
          isPublic: true,
          updatedAt: m.timestamp,
        );
        await db.upsertConversation(
          instanceId: instanceId,
          id: 'public',
          type: 'public',
          displayName: 'Main chat',
          lastMessagePreview: m.content,
          updatedAt: m.timestamp,
        );
      }
    } catch (_) {}

    state = state.copyWith(items: items, loading: false);
  }

  void onPublicPreview(Map<String, dynamic> msg) {
    final content = msg['content'] as String? ?? '';
    final items = [...state.items];
    if (items.isEmpty) return;
    items[0] = ChatListItem(
      id: 'public',
      title: items[0].title,
      preview: content,
      selection: const PublicChatSelection(),
      isPublic: true,
      unread: items[0].unread,
      updatedAt: msg['timestamp'] as String?,
    );
    state = state.copyWith(items: items);
  }

  void onStatusUpdate(Map<String, dynamic> data) {
    final userId = data['userId'] as int? ?? data['user_id'] as int?;
    final online = data['online'] as bool? ?? false;
    if (userId == null) return;
    final items = state.items.map((e) {
      if (e.selection is DmChatSelection &&
          (e.selection as DmChatSelection).otherUserId == userId) {
        return ChatListItem(
          id: e.id,
          title: e.title,
          preview: e.preview,
          selection: e.selection,
          unread: e.unread,
          online: online,
          isPublic: e.isPublic,
          updatedAt: e.updatedAt,
        );
      }
      return e;
    }).toList();
    state = state.copyWith(items: items);
  }
}
