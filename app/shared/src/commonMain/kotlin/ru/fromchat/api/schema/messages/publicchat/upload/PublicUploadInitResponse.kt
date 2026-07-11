package ru.fromchat.api.schema.messages.publicchat.upload

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class PublicUploadInitResponse(
    @SerialName("upload_id") val uploadId: String,
    @SerialName("chunk_size") val chunkSize: Int,
    val offset: Long = 0L,
)
