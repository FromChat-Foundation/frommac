package ru.fromchat.api.schema.messages.publicchat.upload

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class PublicUploadChunkRequest(
    val offset: Long,
    @SerialName("data_b64") val dataB64: String,
)
