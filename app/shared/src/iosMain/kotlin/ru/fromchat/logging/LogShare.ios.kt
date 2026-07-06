package ru.fromchat.logging

import platform.Foundation.NSURL
import platform.UIKit.UIActivityViewController
import platform.UIKit.UIApplication

actual object LogShare {
    actual fun shareText(title: String, text: String) {
        val controller = UIActivityViewController(
            activityItems = listOf(text),
            applicationActivities = null,
        )
        present(controller)
    }

    actual fun shareFile(title: String, filePath: String, mimeType: String) {
        val url = NSURL.fileURLWithPath(filePath)
        val controller = UIActivityViewController(
            activityItems = listOf(url),
            applicationActivities = null,
        )
        present(controller)
    }

    private fun present(controller: UIActivityViewController) {
        val root = UIApplication.sharedApplication.keyWindow?.rootViewController ?: return
        root.presentViewController(controller, animated = true, completion = null)
    }
}
