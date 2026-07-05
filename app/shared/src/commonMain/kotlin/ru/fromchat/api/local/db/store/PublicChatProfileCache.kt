package ru.fromchat.api.local.db.store

import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import ru.fromchat.api.local.cache.CacheContext
import ru.fromchat.api.schema.chats.publicchat.PublicChatProfile

/**
 * In-memory cache of the server-provided public chat profile (title, bio, member count),
 * backed by SQLDelight [public_chat_profile] per instance partition.
 */
object PublicChatProfileCache {
    private val _profile = MutableStateFlow<PublicChatProfile?>(null)
    val profileState: StateFlow<PublicChatProfile?> = _profile.asStateFlow()

    private var loadedInstanceId: String = ""

    val profile: PublicChatProfile?
        get() = _profile.value

    fun isFullyLoaded(): Boolean {
        val instanceId = resolvedInstanceId()
        if (instanceId.isEmpty() || loadedInstanceId != instanceId) return false
        return isCompleteProfile(_profile.value)
    }

    /**
     * Synchronous disk hydrate for cold start / chats list first frame (mirrors DM list immediate load).
     */
    fun hydrateFromDiskImmediate(instanceId: String): PublicChatProfile? {
        val id = instanceId.trim()
        synchronized(this) {
            if (id.isEmpty()) {
                return _profile.value
            }
            if (loadedInstanceId == id && isCompleteProfile(_profile.value)) {
                return _profile.value
            }
            val previousInstanceId = loadedInstanceId
            loadedInstanceId = id
            val disk = PublicChatProfileCacheStore.getImmediate(id)
            _profile.value = when {
                disk != null -> disk
                previousInstanceId.isEmpty() -> _profile.value
                previousInstanceId != id -> null
                else -> _profile.value
            }
            return _profile.value
        }
    }

    fun put(profile: PublicChatProfile) {
        val instanceId: String
        synchronized(this) {
            _profile.value = profile
            instanceId = resolvedInstanceId()
            if (instanceId.isNotEmpty()) {
                loadedInstanceId = instanceId
            }
        }
        if (instanceId.isNotEmpty()) {
            runCatching { PublicChatProfileCacheStore.putImmediate(instanceId, profile) }
        }
    }

    suspend fun onActiveInstanceChanged(instanceId: String) {
        hydrateFromDiskImmediate(instanceId)
    }

    suspend fun hydrateFromDisk() {
        hydrateFromDiskImmediate(CacheContext.activeInstanceId.value)
    }

    suspend fun clear() {
        synchronized(this) {
            _profile.value = null
            loadedInstanceId = ""
        }
    }

    private fun resolvedInstanceId(): String =
        loadedInstanceId.ifEmpty { CacheContext.activeInstanceId.value.trim() }

    private fun isCompleteProfile(profile: PublicChatProfile?): Boolean =
        profile != null && profile.id.isNotBlank() && profile.title.isNotBlank()
}
