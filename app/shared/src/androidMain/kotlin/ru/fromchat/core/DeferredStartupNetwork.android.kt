package ru.fromchat.core

import ru.fromchat.fcm.ensureFcmTokenRegistered
import ru.fromchat.fcm.uploadPendingFcmTokenIfAvailable

actual suspend fun syncPushTokenAfterStartup() {
    uploadPendingFcmTokenIfAvailable()
    ensureFcmTokenRegistered()
}
