package ru.fromchat.api.schema.messages.publicchat.upload

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class PublicUploadCompleteResponse(
    @SerialName("file_id") val fileId: String,
    @SerialName("upload_id") val uploadId: String,
)
