package ru.fromchat.core

actual suspend fun syncPushTokenAfterStartup() {
    // iOS push registration is handled separately when APNs is wired.
}
