package ru.fromchat.api.local.messages

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.serialization.json.JsonElement
import ru.fromchat.api.ApiClient
import ru.fromchat.api.crypto.decryptEnvelope
import ru.fromchat.api.local.db.parseDmMessageContent
import ru.fromchat.api.local.db.store.MessageRepository
import ru.fromchat.api.local.db.store.ProfileCache
import ru.fromchat.api.local.messages.ActiveDmChatTracker
import ru.fromchat.api.schema.messages.Message
import ru.fromchat.api.schema.messages.dm.DmEnvelope
import ru.fromchat.api.schema.websocket.types.DmDeletedData

object DmInboundMessageProcessor {
  suspend fun processNew(element: JsonElement) {
    val envelope = runCatching {
      ApiClient.json.decodeFromJsonElement(DmEnvelope.serializer(), element)
    }.getOrNull() ?: return

    val currentUserId = ApiClient.user?.id ?: return
    if (envelope.senderId != currentUserId && envelope.recipientId != currentUserId) return

    val otherUserId = if (envelope.senderId == currentUserId) {
      envelope.recipientId
    } else {
      envelope.senderId
    }

    withContext(Dispatchers.Default) {
      val outcome = runCatching { decryptEnvelope(envelope, currentUserId) }.getOrNull()
      val plaintext = outcome ?: ""
      val isCorrupted = outcome == null
      val message = buildMessage(envelope, plaintext, isCorrupted, currentUserId, otherUserId)

      if (envelope.senderId == currentUserId) {
        val clientId = envelope.clientMessageId?.trim().orEmpty()
        if (clientId.isNotEmpty()) {
          MessageRepository.confirmDmMessage(otherUserId, clientId, message)
        } else {
          MessageRepository.upsertDmMessage(otherUserId, message)
        }
      } else {
        val isRead = ActiveDmChatTracker.isActive(otherUserId)
        val inbound = message.copy(is_read = isRead)
        MessageRepository.upsertDmMessage(otherUserId, inbound)
      }
    }
  }

  suspend fun processDeleted(element: JsonElement) {
    val data = runCatching {
      ApiClient.json.decodeFromJsonElement(DmDeletedData.serializer(), element)
    }.getOrNull() ?: return

    val currentUserId = ApiClient.user?.id ?: return
    if (data.senderId != currentUserId && data.recipientId != currentUserId) return

    val otherUserId = when (currentUserId) {
      data.senderId -> data.recipientId
      else -> data.senderId
    } ?: return

    withContext(Dispatchers.Default) {
      MessageRepository.deleteDmMessageById(otherUserId, data.id)
    }
  }

  suspend fun processEdited(element: JsonElement) {
    val envelope = runCatching {
      ApiClient.json.decodeFromJsonElement(DmEnvelope.serializer(), element)
    }.getOrNull() ?: return

    val currentUserId = ApiClient.user?.id ?: return
    if (envelope.senderId != currentUserId && envelope.recipientId != currentUserId) return

    val otherUserId = if (envelope.senderId == currentUserId) {
      envelope.recipientId
    } else {
      envelope.senderId
    }

    withContext(Dispatchers.Default) {
      val existing = runCatching { MessageRepository.loadDmMessages(otherUserId) }
        .getOrDefault(emptyList())
        .find { it.id == envelope.id }
      val outcome = runCatching { decryptEnvelope(envelope, currentUserId) }.getOrNull()
      val plaintext = outcome ?: ""
      val isCorrupted = outcome == null
      val dec = parseDmMessageContent(plaintext)
      val updated = (existing ?: buildMessage(envelope, plaintext, isCorrupted, currentUserId, otherUserId))
        .copy(
          content = dec.text,
          is_edited = true,
          files = envelope.files,
          dmEnvelope = envelope,
          fileThumbnails = dec.fileThumbnails ?: existing?.fileThumbnails,
          fileAspectRatios = dec.fileAspectRatios ?: existing?.fileAspectRatios,
          fileSizes = dec.fileSizes ?: existing?.fileSizes,
          fileDimensions = dec.fileDimensions ?: existing?.fileDimensions,
          isContentCorrupted = isCorrupted,
        )
      MessageRepository.upsertDmMessage(otherUserId, updated)
    }
  }

  private fun buildMessage(
    envelope: DmEnvelope,
    plaintext: String,
    isContentCorrupted: Boolean,
    currentUserId: Int,
    otherUserId: Int,
  ): Message {
    val dec = parseDmMessageContent(plaintext)
    val cached = ProfileCache.get(otherUserId)
    val username = if (envelope.senderId == currentUserId) {
      "You"
    } else {
      cached?.displayName?.takeIf { it.isNotBlank() }
        ?: cached?.username?.takeIf { it.isNotBlank() }
        ?: envelope.senderUsername?.takeIf { it.isNotBlank() }
        ?: "User $otherUserId"
    }
    return Message(
      id = envelope.id,
      user_id = envelope.senderId,
      content = dec.text,
      timestamp = envelope.timestamp,
      is_read = envelope.senderId == currentUserId,
      is_edited = false,
      username = username,
      profile_picture = null,
      verified = null,
      reply_to = null,
      client_message_id = envelope.clientMessageId,
      reactions = null,
      files = envelope.files,
      dmEnvelope = envelope,
      fileThumbnails = dec.fileThumbnails,
      fileAspectRatios = dec.fileAspectRatios,
      fileSizes = dec.fileSizes,
      fileDimensions = dec.fileDimensions,
      isContentCorrupted = isContentCorrupted,
    )
  }
}
