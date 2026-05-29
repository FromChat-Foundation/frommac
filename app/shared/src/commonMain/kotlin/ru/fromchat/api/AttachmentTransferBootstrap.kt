package ru.fromchat.api

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import ru.fromchat.api.db.MessageDatabaseProvider
import ru.fromchat.api.outbox.DmAttachmentOutboxPayload
import ru.fromchat.api.outbox.OutgoingMessageCoordinator
import ru.fromchat.api.outbox.scheduleOutboxProcessing
import ru.fromchat.core.cache.repairInterruptedUploadArtifacts
import kotlinx.serialization.json.Json
import ru.fromchat.core.cache.CacheContext
import ru.fromchat.core.instance.applyCachedSessionInstanceIfAvailable
import ru.fromchat.core.instance.scheduleSessionInstanceNetworkRefresh
/**
 * Cold-start hook for attachment downloads and outbound media uploads.
 * Call from Android [android.app.Application] and from the iOS app entry (not Activity / Compose lifecycle).
 */
object AttachmentTransferBootstrap {
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Default)
    private val json = Json { ignoreUnknownKeys = true }

    fun launchOnApplicationStart() {
        scope.launch {
            runCatching { runColdStart() }
        }
    }

    suspend fun runColdStart() {
        AttachmentDownloadNotifier.hydrateFromDisk()
        if (ApiClient.token.isNullOrEmpty()) return
        applyCachedSessionInstanceIfAvailable()
        resumeAttachmentsForActiveInstance()
        scheduleSessionInstanceNetworkRefresh()
    }

    private suspend fun resumeAttachmentsForActiveInstance() {
        val instanceId = CacheContext.activeInstanceId.value.trim()
        if (instanceId.isEmpty()) return
        repairPendingAttachmentArtifacts(instanceId)
        scheduleOutboxProcessing(instanceId)
        AttachmentDownloadNotifier.resumeInterruptedDownloadsOnAppStart()
    }

    private suspend fun repairPendingAttachmentArtifacts(instanceId: String) {
        val rows = MessageDatabaseProvider.database.messageDatabaseQueries
            .selectPendingOutboxForInstance(instanceId)
            .executeAsList()
        for (row in rows) {
            if (row.kind != OutgoingMessageCoordinator.KIND_SEND_DM_ATTACHMENT) continue
            val clientMessageId = runCatching {
                json.decodeFromString<DmAttachmentOutboxPayload>(row.payloadJson).clientMessageId.trim()
            }.getOrNull().orEmpty()
            if (clientMessageId.isEmpty()) continue
            repairInterruptedUploadArtifacts(instanceId, clientMessageId)
        }
    }
}
