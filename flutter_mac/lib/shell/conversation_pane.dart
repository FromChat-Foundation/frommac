import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/calls/call_store.dart';
import '../features/chat/messages_controller.dart';
import '../features/chat/outbox_service.dart';
import '../features/session/session_controller.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../theme/fromchat_theme.dart';

class ConversationPane extends ConsumerStatefulWidget {
  const ConversationPane({super.key});

  @override
  ConsumerState<ConversationPane> createState() => _ConversationPaneState();
}

class _ConversationPaneState extends ConsumerState<ConversationPane> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  final _inputFocus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    _inputFocus.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    final chat = ref.read(selectedChatProvider);
    if (text.isEmpty || chat == null) return;
    _controller.clear();
    await ref.read(sessionProvider.notifier).sendText(chat: chat, text: text);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickFiles() async {
    final chat = ref.read(selectedChatProvider);
    if (chat == null) return;
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
    );
    if (result == null) return;
    for (final f in result.files) {
      await ref.read(outboxServiceProvider).enqueueFile(
            chat: chat,
            path: f.path,
            bytes: f.bytes,
            filename: f.name,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(selectedChatProvider);
    final messages = ref.watch(messagesProvider);
    final scheme = Theme.of(context).colorScheme;

    if (selected == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BrandTitle(fontSize: 36),
            const SizedBox(height: 12),
            Text(
              l10n.app_desc,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }

    final title = switch (selected) {
      PublicChatSelection() => l10n.public_chat,
      DmChatSelection(:final displayName, :final username) =>
        displayName?.isNotEmpty == true
            ? displayName!
            : (username ?? 'DM'),
    };

    final body = Column(
      children: [
        _FloatingChatHeader(
          title: title,
          isPublic: selected is PublicChatSelection,
          onCall: selected is DmChatSelection
              ? () => ref.read(callStoreProvider.notifier).startCall(
                    peerUserId: selected.otherUserId,
                    peerName: title,
                  )
              : null,
        ),
        Expanded(
          child: messages.loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  itemCount: messages.messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages.messages[index];
                    final prev =
                        index > 0 ? messages.messages[index - 1] : null;
                    final grouped =
                        prev != null && prev.userId == msg.userId;
                    return _MessageBubble(message: msg, grouped: grouped);
                  },
                ),
        ),
        _Composer(
          controller: _controller,
          focusNode: _inputFocus,
          onSend: _send,
          onAttach: _pickFiles,
          hint: l10n.message_placeholder,
        ),
      ],
    );

    if (kIsWeb) return body;

    return DropTarget(
      onDragDone: (detail) async {
        for (final f in detail.files) {
          await ref.read(outboxServiceProvider).enqueueFile(
                chat: selected,
                path: f.path,
                filename: f.name,
              );
        }
      },
      child: body,
    );
  }
}

class _FloatingChatHeader extends StatelessWidget {
  const _FloatingChatHeader({
    required this.title,
    required this.isPublic,
    this.onCall,
  });

  final String title;
  final bool isPublic;
  final VoidCallback? onCall;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer.withValues(alpha: 0.92),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(35),
          top: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            child: Icon(isPublic ? Icons.groups : Icons.person),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                if (isPublic)
                  Text(
                    l10n.chat_group_label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
              ],
            ),
          ),
          if (onCall != null)
            IconButton(
              tooltip: l10n.cd_call,
              onPressed: onCall,
              icon: const Icon(Icons.call),
            ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.grouped});

  final ChatMessage message;
  final bool grouped;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final align =
        message.isMine ? Alignment.centerRight : Alignment.centerLeft;
    final bg = message.isMine ? scheme.primary : scheme.surfaceContainerHigh;
    final fg = message.isMine ? scheme.onPrimary : scheme.onSurface;

    return Align(
      alignment: align,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Container(
          margin: EdgeInsets.only(
            top: grouped ? 2 : 8,
            left: message.isMine ? 64 : 0,
            right: message.isMine ? 0 : 64,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: ShapeDecoration(
            color: bg,
            shape: MessageBubbleShape(isMine: message.isMine, grouped: grouped),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!message.isMine && !grouped)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    message.username,
                    style: TextStyle(
                      color: fg.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              SelectableText(
                message.isContentCorrupted
                    ? l10n.message_corrupted
                    : message.content,
                style: TextStyle(color: fg, height: 1.35),
              ),
              if (message.isEdited)
                Text(
                  l10n.message_edited_suffix,
                  style: TextStyle(
                    color: fg.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.onAttach,
    required this.hint,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final VoidCallback onAttach;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.enter, meta: true): onSend,
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: onAttach,
              icon: const Icon(Icons.attach_file),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                minLines: 1,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: hint,
                  filled: true,
                  fillColor: scheme.surfaceContainerHigh,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: onSend,
              child: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
