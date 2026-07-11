package ru.fromchat.api.schema.messages.publicchat

import ru.fromchat.api.local.db.aspectRatioFromDimensionPair
import ru.fromchat.api.local.db.isPlaceholderAttachmentDimensions
import ru.fromchat.api.schema.messages.Message

/**
 * Maps public-API `[width, height]` pairs into layout fields used by attachment tiles.
 */
fun Message.resolvePublicAttachmentLayout(): Message {
    val dims = fileAspectRatioPairs
        ?.mapNotNull { pair ->
            if (pair.size >= 2) {
                val w = pair[0]
                val h = pair[1]
                if (w > 0 && h > 0 && !isPlaceholderAttachmentDimensions(w, h)) w to h else null
            } else {
                null
            }
        }
        ?.takeIf { it.isNotEmpty() }
        ?: fileDimensions?.filterNot { (w, h) -> isPlaceholderAttachmentDimensions(w, h) }
            ?.takeIf { it.isNotEmpty() }
    val ratios = dims
        ?.map { (w, h) -> aspectRatioFromDimensionPair(w, h) }
        ?.takeIf { it.isNotEmpty() }
        ?: fileAspectRatios
    if (dims == fileDimensions && ratios == fileAspectRatios) return this
    val resolved = copy(fileDimensions = dims, fileAspectRatios = ratios)
    if (fileAspectRatioPairs != null) {
        ru.fromchat.api.local.AttachmentMediaLog.aspect(
            "resolve_public_layout",
            "msgId" to id,
            "pairsIn" to fileAspectRatioPairs.firstOrNull(),
            "dimsOut" to resolved.fileDimensions?.firstOrNull(),
            "ratioOut" to resolved.fileAspectRatios?.firstOrNull(),
        )
    }
    return resolved
}
