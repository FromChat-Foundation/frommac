package ru.fromchat.api.local.cache

/** Matches server public-chat thumbnail long edge ([_THUMB_SIZE] in messaging.py). */
const val ATTACHMENT_DISK_THUMB_MAX_EDGE_PX = 80

/**
 * Writes a tiny JPEG next to a cached full image for instant cold-start tiles.
 * Returns true when [destAbsolutePath] exists after the call.
 */
expect fun generateAttachmentDiskThumbnail(
    sourceAbsolutePath: String,
    destAbsolutePath: String,
    maxEdgePx: Int = ATTACHMENT_DISK_THUMB_MAX_EDGE_PX,
): Boolean
