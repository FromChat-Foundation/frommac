@file:OptIn(ExperimentalForeignApi::class, BetaInteropApi::class)

package ru.fromchat.api.local.cache

import kotlinx.cinterop.BetaInteropApi
import kotlinx.cinterop.ExperimentalForeignApi
import kotlinx.cinterop.useContents
import platform.CoreGraphics.CGRectMake
import platform.Foundation.NSData
import platform.Foundation.create
import platform.Foundation.writeToFile
import platform.UIKit.UIGraphicsBeginImageContextWithOptions
import platform.UIKit.UIGraphicsEndImageContext
import platform.UIKit.UIGraphicsGetImageFromCurrentImageContext
import platform.UIKit.UIImage
import platform.UIKit.UIImageJPEGRepresentation

actual fun generateAttachmentDiskThumbnail(
    sourceAbsolutePath: String,
    destAbsolutePath: String,
    maxEdgePx: Int,
): Boolean {
    val data = NSData.create(contentsOfFile = sourceAbsolutePath) ?: return false
    val image = UIImage.imageWithData(data) ?: return false
    val width = image.size.useContents { width }
    val height = image.size.useContents { height }
    if (width <= 0.0 || height <= 0.0) return false
    val longEdge = maxOf(width, height)
    val scale = if (longEdge > maxEdgePx) maxEdgePx.toDouble() / longEdge else 1.0
    val dstW = (width * scale).coerceAtLeast(1.0)
    val dstH = (height * scale).coerceAtLeast(1.0)
    UIGraphicsBeginImageContextWithOptions(
        platform.CoreGraphics.CGSizeMake(dstW, dstH),
        false,
        1.0,
    )
    image.drawInRect(CGRectMake(0.0, 0.0, dstW, dstH))
    val scaled = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    val jpeg = scaled?.let { UIImageJPEGRepresentation(it, 0.85) } ?: return false
    return jpeg.writeToFile(destAbsolutePath, atomically = true)
}
