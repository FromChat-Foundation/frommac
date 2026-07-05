package ru.fromchat.ui.main.chats

import ru.fromchat.api.local.db.store.CachedConversation

/** Keeps the active DM list ordered with the most recently updated thread first. */
internal object ChatListReorderController {
    fun bump(
        current: List<CachedConversation>,
        conversation: CachedConversation,
    ): List<CachedConversation> {
        val rest = current.filter { it.otherUserId != conversation.otherUserId }
        return listOf(conversation) + rest
    }

    fun applyOrdered(conversations: List<CachedConversation>): List<CachedConversation> = conversations
}
