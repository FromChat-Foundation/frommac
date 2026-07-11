package ru.fromchat.api.schema.messages.publicchat.upload

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class PublicUploadStatusResponse(
    @SerialName("upload_id") val uploadId: String,
    val offset: Long = 0L,
    @SerialName("total_size") val totalSize: Long = 0L,
    val complete: Boolean = false,
)
