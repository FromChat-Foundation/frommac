package ru.fromchat.api

import com.pr0gramm3r101.utils.UtilsLibrary
import ru.fromchat.download.AttachmentDownloadForegroundService

actual object AttachmentDownloadForeground {
    actual fun onFileDownloadStarted(storageKey: String) {
        AttachmentDownloadForegroundService.onJobStarted(
            UtilsLibrary.context.applicationContext,
            storageKey,
        )
    }

    actual fun onFileDownloadProgress(percent: Int, displayLabel: String?) {
        AttachmentDownloadForegroundService.updateProgress(
            UtilsLibrary.context.applicationContext,
            percent,
            displayLabel,
        )
    }

    actual fun onFileDownloadFinished(storageKey: String) {
        AttachmentDownloadForegroundService.onJobFinished(
            UtilsLibrary.context.applicationContext,
            storageKey,
        )
    }
}
