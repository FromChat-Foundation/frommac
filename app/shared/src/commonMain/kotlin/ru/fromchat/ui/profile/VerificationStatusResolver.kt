package ru.fromchat.ui.profile

import ru.fromchat.api.local.db.store.ProfileCache
import ru.fromchat.api.schema.messages.Message
import ru.fromchat.api.schema.user.User
import ru.fromchat.api.schema.user.profile.UserProfile
import ru.fromchat.api.schema.user.profile.VerificationStatus
import ru.fromchat.api.schema.user.profile.orFromLegacyVerified

fun UserProfile.effectiveVerificationStatus(): VerificationStatus =
    verificationStatus.orFromLegacyVerified(verified)

fun User.effectiveVerificationStatus(): VerificationStatus =
    verificationStatus.orFromLegacyVerified(verified)

fun resolveVerificationStatus(
    userId: Int,
    message: Message? = null,
    user: User? = null,
): VerificationStatus? {
    ProfileCache.get(userId)?.effectiveVerificationStatus()?.let { cached ->
        if (cached != VerificationStatus.None || ProfileCache.get(userId)?.verificationStatus != null) {
            return cached
        }
    }

    user?.effectiveVerificationStatus()?.let { return it }

    message?.verificationStatus?.let { return it }
    message?.verified?.let { return if (it) VerificationStatus.Verified else null }

    return null
}
