package ru.fromchat.api.schema.user.profile

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class VerifyResponse(
    val verified: Boolean,
    @SerialName("verification_status") val verificationStatus: VerificationStatus? = null,
)