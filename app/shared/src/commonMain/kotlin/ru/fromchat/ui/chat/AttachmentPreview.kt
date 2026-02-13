package ru.fromchat.ui.chat

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
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
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.blur
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.unit.dp
import coil3.compose.AsyncImage
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.withContext
import ru.fromchat.api.ApiClient
import ru.fromchat.api.DmEnvelope
import ru.fromchat.api.DmFile
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
    modifier: Modifier = Modifier
) {
    val isImage = file?.let { isImageFilename(it.name) } ?: pendingFileUri?.let {
        it.contains("image", ignoreCase = true) || it.endsWith(".jpg", true) ||
            it.endsWith(".png", true) || it.endsWith(".jpeg", true) ||
            it.endsWith(".gif", true) || it.endsWith(".webp", true)
    } ?: false

    Box(
        modifier = modifier
            .size(IMAGE_SIZE)
            .clip(RoundedCornerShape(IMAGE_RADIUS))
            .background(MaterialTheme.colorScheme.surfaceVariant),
        contentAlignment = Alignment.Center
    ) {
        when {
            pendingFileUri != null -> {
                PendingImageContent(
                    uri = pendingFileUri,
                    isUploading = isUploading,
                    isImage = isImage
                )
            }
            file != null && isImage && dmEnvelope != null -> {
                DecryptedImageContent(
                    file = file,
                    envelope = dmEnvelope,
                    currentUserId = currentUserId
                )
            }
            file != null && !isImage -> {
                FileIconContent(filename = file.name)
            }
            else -> {
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
    currentUserId: Int?
) {
    var thumbnailBytes by remember(file.path) { mutableStateOf<ByteArray?>(null) }
    var fullBytes by remember(file.path) { mutableStateOf<ByteArray?>(null) }
    var imageReadyToUnblur by remember(file.path) { mutableStateOf(false) }

    LaunchedEffect(file.path) {
        withContext(Dispatchers.Default) {
            coroutineScope {
                val thumbDeferred = async {
                    ApiClient.fetchThumbnail(file.path)
                }
                val fullDeferred = async {
                    runCatching { decryptFile(file, envelope, currentUserId) }.getOrNull()
                }
                thumbnailBytes = thumbDeferred.await()
                fullBytes = fullDeferred.await()
            }
        }
    }

    val hasThumb = thumbnailBytes != null
    val hasFull = fullBytes != null
    val showContent = hasThumb || hasFull

    if (!showContent) {
        Box(
            modifier = Modifier.fillMaxSize(),
            contentAlignment = Alignment.Center
        ) {
            CircularProgressIndicator(modifier = Modifier.size(24.dp))
        }
        return
    }

    LaunchedEffect(hasFull) {
        if (hasFull) {
            delay(80)
            imageReadyToUnblur = true
        }
    }
    val blurProgress by animateFloatAsState(
        targetValue = if (imageReadyToUnblur) 0f else 1f,
        animationSpec = tween(300),
        label = "blur"
    )
    val blurRadius = with(LocalDensity.current) { (blurProgress * 8.dp.toPx()).toDp() }
    val displayBytes = fullBytes ?: thumbnailBytes!!

    Box(modifier = Modifier.fillMaxSize()) {
        AsyncImage(
            model = displayBytes,
            contentDescription = file.name,
            modifier = Modifier
                .fillMaxSize()
                .clip(RoundedCornerShape(IMAGE_RADIUS))
                .then(if (blurProgress > 0.01f) Modifier.blur(blurRadius) else Modifier),
            contentScale = ContentScale.Crop
        )
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
