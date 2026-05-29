package ru.fromchat.ui.chat

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import ru.fromchat.api.DmEnvelope
import ru.fromchat.api.DmFile

object DmFileDownloader {
    suspend fun downloadToCache(
        messageId: Int,
        fileIndex: Int,
        file: DmFile,
        envelope: DmEnvelope,
        currentUserId: Int?,
        clientMessageId: String?,
        messageLabel: String? = null,
    ): Boolean = withContext(Dispatchers.Default) {
        DecryptedFileCache.getOrDecrypt(
            messageId = messageId,
            fileIndex = fileIndex,
            file = file,
            envelope = envelope,
            currentUserId = currentUserId,
            clientMessageId = clientMessageId,
            messageLabel = messageLabel,
        ) != null
    }
}

expect suspend fun openCachedAttachmentFile(
    cacheUri: String,
    mimeType: String,
    displayFilename: String? = null,
): Boolean
