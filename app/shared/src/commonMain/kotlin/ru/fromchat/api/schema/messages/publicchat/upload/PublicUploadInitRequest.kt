package ru.fromchat.api.schema.messages.publicchat.upload

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class PublicUploadInitRequest(
    val filename: String,
    @SerialName("total_size") val totalSize: Long,
    @SerialName("chunk_size") val chunkSize: Int? = null,
)
