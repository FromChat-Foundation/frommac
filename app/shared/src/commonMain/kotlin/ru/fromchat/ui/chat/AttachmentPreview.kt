package ru.fromchat.ui.chat

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.sizeIn
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AttachFile
import androidx.compose.material.icons.filled.Image
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.blur
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.unit.dp
import coil3.compose.AsyncImage
import coil3.compose.rememberAsyncImagePainter
import com.pr0gramm3r101.utils.crypto.Base64
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import ru.fromchat.api.DmEnvelope
import ru.fromchat.api.DmFile
import ru.fromchat.core.Logger
import ru.fromchat.crypto.decryptFile

private val IMAGE_SIZE = 160.dp
private val IMAGE_RADIUS = 8.dp

private fun isImageFilename(name: String): Boolean =
    name.endsWith(".png", true) || name.endsWith(".jpg", true) ||
        name.endsWith(".jpeg", true) || name.endsWith(".gif", true) || name.endsWith(".webp", true)

@Composable
fun AttachmentPreview(
    file: DmFile?,
    dmEnvelope: DmEnvelope?,
    currentUserId: Int?,
    pendingFileUri: String?,
    isUploading: Boolean,
    fileThumbnail: String? = null,
    fileAspectRatio: Float? = null,
    modifier: Modifier = Modifier
) {
    val isImage = file?.let { isImageFilename(it.name) } ?: pendingFileUri?.let {
        it.contains("image", ignoreCase = true) || it.endsWith(".jpg", true) ||
            it.endsWith(".png", true) || it.endsWith(".jpeg", true) ||
            it.endsWith(".gif", true) || it.endsWith(".webp", true)
    } ?: false

    val baseModifier = modifier
        .then(
            if (fileAspectRatio != null && fileAspectRatio > 0f) {
                Modifier.aspectRatio(fileAspectRatio).sizeIn(maxWidth = IMAGE_SIZE, maxHeight = IMAGE_SIZE)
            } else {
                Modifier.size(IMAGE_SIZE)
            }
        )
        .clip(RoundedCornerShape(IMAGE_RADIUS))
        .background(MaterialTheme.colorScheme.surfaceVariant)
    Box(
        modifier = baseModifier,
        contentAlignment = Alignment.Center
    ) {
        when {
            pendingFileUri != null -> {
                Logger.d("AttachmentPreview", "Rendering: pendingFileUri, isUploading=$isUploading")
                PendingImageContent(
                    uri = pendingFileUri,
                    isUploading = isUploading,
                    isImage = isImage
                )
            }
            file != null && isImage && dmEnvelope != null && !fileThumbnail.isNullOrBlank() -> {
                Logger.d("AttachmentPreview", "Rendering: DecryptedImageContent file=${file.name} thumbLen=${fileThumbnail.length} aspectRatio=$fileAspectRatio")
                DecryptedImageContent(
                    file = file,
                    envelope = dmEnvelope,
                    currentUserId = currentUserId,
                    thumbnailBase64 = fileThumbnail,
                    aspectRatio = fileAspectRatio
                )
            }
            file != null && !isImage -> {
                Logger.d("AttachmentPreview", "Rendering: FileIconContent file=${file.name}")
                FileIconContent(filename = file.name)
            }
            else -> {
                Logger.d("AttachmentPreview", "Rendering: fallback Icon (file=$file, isImage=$isImage, hasEnvelope=${dmEnvelope != null}, thumbBlank=${fileThumbnail.isNullOrBlank()})")
                Icon(
                    imageVector = Icons.Default.Image,
                    contentDescription = null,
                    modifier = Modifier.size(48.dp),
                    tint = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
    }
}

@Composable
private fun PendingImageContent(
    uri: String,
    isUploading: Boolean,
    isImage: Boolean
) {
    if (isImage) {
        Box(modifier = Modifier.fillMaxSize()) {
            AsyncImage(
                model = uri,
                contentDescription = null,
                modifier = Modifier
                    .fillMaxSize()
                    .clip(RoundedCornerShape(IMAGE_RADIUS))
                    .then(if (isUploading) Modifier.blur(8.dp) else Modifier),
                contentScale = ContentScale.Crop
            )
            AnimatedVisibility(
                visible = isUploading,
                enter = fadeIn(),
                exit = fadeOut(animationSpec = tween(300))
            ) {
                Box(
                    modifier = Modifier
                        .fillMaxSize()
                        .background(MaterialTheme.colorScheme.surface.copy(alpha = 0.5f)),
                    contentAlignment = Alignment.Center
                ) {
                    InfiniteCircularProgress()
                }
            }
        }
    } else {
        Box(
            modifier = Modifier.fillMaxSize(),
            contentAlignment = Alignment.Center
        ) {
            if (isUploading) {
                InfiniteCircularProgress()
            } else {
                Icon(
                    imageVector = Icons.Default.AttachFile,
                    contentDescription = null,
                    modifier = Modifier.size(48.dp),
                    tint = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
    }
}

@Composable
private fun InfiniteCircularProgress() {
    CircularProgressIndicator(
        modifier = Modifier.size(32.dp),
        strokeWidth = 3.dp
    )
}

@Composable
private fun DecryptedImageContent(
    file: DmFile,
    envelope: DmEnvelope,
    currentUserId: Int?,
    thumbnailBase64: String,
    aspectRatio: Float?
) {
    var fullBytes by remember(file.path) { mutableStateOf<ByteArray?>(null) }
    val thumbnailBytes = remember(thumbnailBase64) {
        runCatching { Base64.decode(thumbnailBase64) }.getOrNull()
    }

    LaunchedEffect(file.path) {
        Logger.d("AttachmentPreview", "DecryptedImageContent: fetching full image path=${file.path}")
        withContext(Dispatchers.Default) {
            fullBytes = runCatching { decryptFile(file, envelope, currentUserId) }.getOrNull()
            Logger.d("AttachmentPreview", "DecryptedImageContent: full image fetch done path=${file.path} success=${fullBytes != null} size=${fullBytes?.size ?: 0}")
        }
    }

    Box(modifier = Modifier.fillMaxSize()) {
        when {
            thumbnailBytes == null -> {
                Box(
                    modifier = Modifier.fillMaxSize(),
                    contentAlignment = Alignment.Center
                ) {
                    InfiniteCircularProgress()
                }
            }
            else -> {
                val thumbPainter = rememberAsyncImagePainter(
                    model = thumbnailBytes,
                    contentScale = ContentScale.Crop
                )
                val thumbState by thumbPainter.state.collectAsState()
                when (thumbState) {
                    is coil3.compose.AsyncImagePainter.State.Loading -> {
                        Box(
                            modifier = Modifier.fillMaxSize(),
                            contentAlignment = Alignment.Center
                        ) {
                            InfiniteCircularProgress()
                        }
                    }
                    is coil3.compose.AsyncImagePainter.State.Success -> {
                        Image(
                            painter = thumbPainter,
                            contentDescription = file.name,
                            modifier = Modifier
                                .fillMaxSize()
                                .clip(RoundedCornerShape(IMAGE_RADIUS))
                                .blur(8.dp),
                            contentScale = ContentScale.Crop
                        )
                        if (fullBytes != null) {
                            val fullPainter = rememberAsyncImagePainter(
                                model = fullBytes,
                                contentScale = ContentScale.Crop
                            )
                            val fullState by fullPainter.state.collectAsState()
                            when (fullState) {
                                is coil3.compose.AsyncImagePainter.State.Success -> {
                                    val alpha = remember { Animatable(0f) }
                                    LaunchedEffect(Unit) {
                                        alpha.animateTo(1f, animationSpec = tween(300))
                                    }
                                    Image(
                                        painter = fullPainter,
                                        contentDescription = file.name,
                                        modifier = Modifier
                                            .fillMaxSize()
                                            .clip(RoundedCornerShape(IMAGE_RADIUS))
                                            .alpha(alpha.value),
                                        contentScale = ContentScale.Crop
                                    )
                                }
                                else -> { }
                            }
                        }
                    }
                    else -> {
                        Box(
                            modifier = Modifier.fillMaxSize(),
                            contentAlignment = Alignment.Center
                        ) {
                            InfiniteCircularProgress()
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun FileIconContent(filename: String) {
    Column(
        modifier = Modifier.padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Icon(
            imageVector = Icons.Default.AttachFile,
            contentDescription = null,
            modifier = Modifier.size(40.dp),
            tint = MaterialTheme.colorScheme.onSurfaceVariant
        )
        Text(
            text = filename.take(20) + if (filename.length > 20) "…" else "",
            style = MaterialTheme.typography.labelSmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            maxLines = 2
        )
    }
}
