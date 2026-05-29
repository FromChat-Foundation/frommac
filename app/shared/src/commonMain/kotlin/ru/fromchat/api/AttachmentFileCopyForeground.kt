package ru.fromchat.api

expect object AttachmentFileCopyForeground {
    fun onCopyStarted(storageKey: String, displayLabel: String? = null)
    fun onCopyFinished(storageKey: String)
}
