package ru.fromchat.api.local.messages

import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

/** Tracks which DM peer chat is currently open (for inbox read/unread routing). */
object ActiveDmChatTracker {
    private val _activeOtherUserId = MutableStateFlow<Int?>(null)
    val activeOtherUserId: StateFlow<Int?> = _activeOtherUserId.asStateFlow()

    fun setActive(otherUserId: Int?) {
        if (_activeOtherUserId.value == otherUserId) return
        _activeOtherUserId.value = otherUserId
    }

    fun isActive(otherUserId: Int): Boolean =
        otherUserId > 0 && _activeOtherUserId.value == otherUserId
}
