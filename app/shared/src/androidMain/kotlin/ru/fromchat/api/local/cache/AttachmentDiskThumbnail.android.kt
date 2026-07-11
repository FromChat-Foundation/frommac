package ru.fromchat.api.local.cache

import java.io.FileOutputStream

actual fun generateAttachmentDiskThumbnail(
    sourceAbsolutePath: String,
    destAbsolutePath: String,
    maxEdgePx: Int,
): Boolean {
    val bitmap = ru.fromchat.api.local.download.decodeSampledImageFile(
        sourceAbsolutePath,
        maxEdgePx,
        maxEdgePx,
    ) ?: return false
    return runCatching {
        FileOutputStream(destAbsolutePath).use { stream ->
            bitmap.compress(android.graphics.Bitmap.CompressFormat.JPEG, 85, stream)
        }
        true
    }.getOrDefault(false)
}
