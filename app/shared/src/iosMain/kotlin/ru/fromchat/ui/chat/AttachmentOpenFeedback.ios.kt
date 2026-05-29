package ru.fromchat.ui.chat

internal actual fun showAttachmentOpenFailed(message: String) {
    // iOS uses share sheet from openCachedAttachmentFile; no-op here.
}
