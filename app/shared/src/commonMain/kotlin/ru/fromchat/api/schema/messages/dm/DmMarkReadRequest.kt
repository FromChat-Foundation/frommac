package ru.fromchat.api.schema.messages.dm

import kotlinx.serialization.Serializable

@Serializable
data class DmMarkReadRequest(
    val upToEnvelopeId: Int? = null,
)
