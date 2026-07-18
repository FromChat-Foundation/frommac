import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/chat/messages_controller.dart';
import '../features/chats/chat_list_controller.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../theme/fromchat_theme.dart';

class ChatListPane extends ConsumerWidget {
  const ChatListPane({
    super.key,
    required this.searchMode,
    this.searchFocus,
  });

  final bool searchMode;
  final FocusNode? searchFocus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(chatListProvider);
    final selected = ref.watch(selectedChatProvider);
    final scheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: scheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: searchMode
                ? TextField(
                    focusNode: searchFocus,
                    decoration: InputDecoration(
                      hintText: l10n.search_hint,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      isDense: true,
                    ),
                    onChanged: (v) =>
                        ref.read(chatListProvider.notifier).setFilter(v),
                  )
                : const BrandTitle(fontSize: 26),
          ),
          if (state.loading) const LinearProgressIndicator(minHeight: 2),
          Expanded(
            child: ListView.builder(
              itemCount: state.visible.length,
              itemBuilder: (context, index) {
                final item = state.visible[index];
                final isSelected = _same(item.selection, selected);
                return _ChatRow(
                  item: item,
                  selected: isSelected,
                  onTap: () {
                    ref.read(selectedChatProvider.notifier).state =
                        item.selection;
                    ref.read(messagesProvider.notifier).open(item.selection);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _same(SelectedChat a, SelectedChat? b) {
    if (b == null) return false;
    if (a is PublicChatSelection && b is PublicChatSelection) return true;
    if (a is DmChatSelection && b is DmChatSelection) {
      return a.otherUserId == b.otherUserId;
    }
    return false;
  }
}

class _ChatRow extends StatelessWidget {
  const _ChatRow({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final ChatListItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    return Material(
      color: selected ? scheme.secondaryContainer.withValues(alpha: 0.45) : null,
      child: InkWell(
        onTap: onTap,
        onSecondaryTapDown: (details) {
          showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
              details.globalPosition.dx,
              details.globalPosition.dy,
              details.globalPosition.dx,
              details.globalPosition.dy,
            ),
            items: [
              PopupMenuItem(value: 'read', child: Text(l10n.action_mark_read)),
              PopupMenuItem(value: 'archive', child: Text(l10n.action_archive)),
            ],
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: item.isPublic
                    ? scheme.primaryContainer
                    : scheme.surfaceContainerHigh,
                child: Icon(
                  item.isPublic ? Icons.groups : Icons.person,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.isPublic ? l10n.public_chat : item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (item.online)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.shade400,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.preview.isEmpty ? ' ' : item.preview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              if (item.unread > 0)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${item.unread}',
                    style: TextStyle(
                      color: scheme.onPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
