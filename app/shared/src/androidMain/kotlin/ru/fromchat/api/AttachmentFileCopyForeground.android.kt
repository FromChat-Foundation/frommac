package ru.fromchat.api

import com.pr0gramm3r101.utils.UtilsLibrary
import ru.fromchat.download.AttachmentFileCopyForegroundService

actual object AttachmentFileCopyForeground {
    actual fun onCopyStarted(storageKey: String, displayLabel: String?) {
        AttachmentFileCopyForegroundService.onJobStarted(
            UtilsLibrary.context.applicationContext,
            storageKey,
            displayLabel,
        )
    }

    actual fun onCopyFinished(storageKey: String) {
        AttachmentFileCopyForegroundService.onJobFinished(
            UtilsLibrary.context.applicationContext,
            storageKey,
        )
    }
}
