package ru.fromchat.api.schema.messages.publicchat.upload

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** Matches file_storage resumable chunk response: `{"offset_received": <long>}`. */
@Serializable
data class PublicUploadChunkResponse(
    @SerialName("offset_received") val offsetReceived: Long = 0L,
)
