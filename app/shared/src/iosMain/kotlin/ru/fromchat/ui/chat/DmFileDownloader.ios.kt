package ru.fromchat.ui.chat

import platform.Foundation.NSURL
import platform.UIKit.UIApplication
import ru.fromchat.platform.iosTopViewController

actual suspend fun openCachedAttachmentFile(
    cacheUri: String,
    mimeType: String,
    displayFilename: String?,
): Boolean {
    val url = NSURL.URLWithString(cacheUri) ?: NSURL.fileURLWithPath(cacheUri.removePrefix("file://"))
    return UIApplication.sharedApplication.openURL(url)
}
