import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/calls/call_overlay.dart';
import '../features/chat/messages_controller.dart';
import '../features/chats/chat_list_controller.dart';
import '../features/session/session_controller.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import 'chat_list_pane.dart';
import 'conversation_pane.dart';
import 'settings_pane.dart';

enum ShellSection { chats, search, settings, profile }

final shellSectionProvider =
    StateProvider<ShellSection>((ref) => ShellSection.chats);

class MacShell extends ConsumerStatefulWidget {
  const MacShell({super.key});

  @override
  ConsumerState<MacShell> createState() => _MacShellState();
}

class _MacShellState extends ConsumerState<MacShell> {
  final _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final isMeta = HardwareKeyboard.instance.isMetaPressed;
    if (isMeta && event.logicalKey == LogicalKeyboardKey.comma) {
      ref.read(shellSectionProvider.notifier).state = ShellSection.settings;
      return KeyEventResult.handled;
    }
    if (isMeta && event.logicalKey == LogicalKeyboardKey.keyF) {
      ref.read(shellSectionProvider.notifier).state = ShellSection.search;
      _searchFocus.requestFocus();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      ref.read(selectedChatProvider.notifier).state = null;
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
        event.logicalKey == LogicalKeyboardKey.arrowUp) {
      _moveSelection(event.logicalKey == LogicalKeyboardKey.arrowDown);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _moveSelection(bool down) {
    final items = ref.read(chatListProvider).visible;
    if (items.isEmpty) return;
    final current = ref.read(selectedChatProvider);
    var index = items.indexWhere((e) => _sameChat(e.selection, current));
    if (index < 0) {
      index = 0;
    } else {
      index = (index + (down ? 1 : -1)).clamp(0, items.length - 1);
    }
    final sel = items[index].selection;
    ref.read(selectedChatProvider.notifier).state = sel;
    ref.read(messagesProvider.notifier).open(sel);
  }

  bool _sameChat(SelectedChat a, SelectedChat? b) {
    if (b == null) return false;
    if (a is PublicChatSelection && b is PublicChatSelection) return true;
    if (a is DmChatSelection && b is DmChatSelection) {
      return a.otherUserId == b.otherUserId;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final section = ref.watch(shellSectionProvider);
    final session = ref.watch(sessionProvider);
    final scheme = Theme.of(context).colorScheme;

    return Focus(
      autofocus: true,
      onKeyEvent: _onKey,
      child: Scaffold(
        body: Stack(
          children: [
            Row(
              children: [
                NavigationRail(
                  selectedIndex: section.index,
                  onDestinationSelected: (i) {
                    ref.read(shellSectionProvider.notifier).state =
                        ShellSection.values[i];
                  },
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: scheme.surfaceContainer,
                  destinations: [
                    NavigationRailDestination(
                      icon: const Icon(Icons.chat_bubble_outline),
                      selectedIcon: const Icon(Icons.chat_bubble),
                      label: Text(l10n.chats),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.search),
                      selectedIcon: const Icon(Icons.search),
                      label: Text(l10n.search_title),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.settings_outlined),
                      selectedIcon: const Icon(Icons.settings),
                      label: Text(l10n.settings),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.person_outline),
                      selectedIcon: const Icon(Icons.person),
                      label: Text(l10n.profile),
                    ),
                  ],
                ),
                VerticalDivider(width: 1, color: scheme.outlineVariant),
                if (section == ShellSection.chats ||
                    section == ShellSection.search)
                  SizedBox(
                    width: 320,
                    child: ChatListPane(
                      searchMode: section == ShellSection.search,
                      searchFocus: _searchFocus,
                    ),
                  ),
                if (section == ShellSection.chats ||
                    section == ShellSection.search)
                  VerticalDivider(width: 1, color: scheme.outlineVariant),
                Expanded(
                  child: switch (section) {
                    ShellSection.chats ||
                    ShellSection.search =>
                      const ConversationPane(),
                    ShellSection.settings => const SettingsPane(),
                    ShellSection.profile => ProfilePane(user: session.user),
                  },
                ),
              ],
            ),
            const CallOverlay(),
            if (!session.wsConnected && session.isLoggedIn)
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Material(
                  color: scheme.tertiaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(
                      l10n.status_connecting,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: scheme.onTertiaryContainer),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
