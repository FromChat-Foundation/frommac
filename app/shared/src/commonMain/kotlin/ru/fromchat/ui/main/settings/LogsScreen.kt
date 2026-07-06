package ru.fromchat.ui.main.settings

import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.FastOutLinearInEasing
import androidx.compose.animation.core.FastOutSlowInEasing
import androidx.compose.animation.core.Spring
import androidx.compose.animation.core.spring
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInVertically
import androidx.compose.animation.slideOutVertically
import androidx.compose.animation.togetherWith
import androidx.compose.animation.animateContentSize
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.scrollBy
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.navigationBars
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyListState
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.selection.DisableSelection
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.rounded.InsertDriveFile
import androidx.compose.material.icons.filled.BugReport
import androidx.compose.material.icons.filled.CleaningServices
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Compress
import androidx.compose.material.icons.filled.ContentCopy
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Error
import androidx.compose.material.icons.filled.Folder
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.KeyboardArrowDown
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material.icons.filled.Report
import androidx.compose.material.icons.filled.Share
import androidx.compose.material.icons.automirrored.filled.Subject
import androidx.compose.material.icons.filled.Sync
import androidx.compose.material.icons.filled.Warning
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.DatePicker
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExperimentalMaterial3ExpressiveApi
import androidx.compose.material3.FilledTonalButton
import androidx.compose.material3.FabPosition
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.SmallFloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialShapes
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Slider
import androidx.compose.material3.Surface
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.material3.rememberDatePickerState
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.material3.rememberTopAppBarState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.input.nestedscroll.NestedScrollConnection
import androidx.compose.ui.input.nestedscroll.NestedScrollSource
import androidx.compose.ui.input.nestedscroll.nestedScroll
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.layout.positionInRoot
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.runtime.snapshotFlow
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.style.TextOverflow
import com.pr0gramm3r101.components.Category
import com.pr0gramm3r101.components.ListItem
import com.pr0gramm3r101.utils.supportClipboardManagerImpl
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import kotlinx.datetime.LocalDate
import kotlinx.datetime.TimeZone
import kotlinx.datetime.atStartOfDayIn
import kotlinx.datetime.toLocalDateTime
import org.jetbrains.compose.resources.stringResource
import ru.fromchat.Res
import ru.fromchat.action_copy
import ru.fromchat.action_delete
import ru.fromchat.back
import ru.fromchat.cancel
import ru.fromchat.cd_close_selection
import ru.fromchat.confirm
import ru.fromchat.logs_browse_files_cd
import ru.fromchat.logs_clean
import ru.fromchat.logs_clean_all_body
import ru.fromchat.logs_clean_apply
import ru.fromchat.logs_clean_date_body
import ru.fromchat.logs_clean_entries_body
import ru.fromchat.logs_clean_entries_count
import ru.fromchat.logs_clean_mode_all
import ru.fromchat.logs_clean_mode_date
import ru.fromchat.logs_clean_mode_entries
import ru.fromchat.logs_clean_mode_size
import ru.fromchat.logs_clean_size_body
import ru.fromchat.logs_clean_size_mb
import ru.fromchat.logs_clean_title
import ru.fromchat.logs_decompressing
import ru.fromchat.logs_delete_file_confirm_body
import ru.fromchat.logs_delete_file_confirm_title
import ru.fromchat.logs_empty
import ru.fromchat.logs_level_debug
import ru.fromchat.logs_level_error
import ru.fromchat.logs_level_fatal
import ru.fromchat.logs_level_info
import ru.fromchat.logs_level_verbose
import ru.fromchat.logs_level_warn
import ru.fromchat.logs_rotate
import ru.fromchat.logs_rotate_confirm_body
import ru.fromchat.logs_rotate_confirm_title
import ru.fromchat.logs_scroll_to_bottom_cd
import ru.fromchat.logs_selected_count
import ru.fromchat.logs_share
import ru.fromchat.logs_share_compressed
import ru.fromchat.logs_share_compressed_desc
import ru.fromchat.logs_share_how_title
import ru.fromchat.logs_share_uncompressed
import ru.fromchat.logs_share_uncompressed_desc
import ru.fromchat.logs_title
import ru.fromchat.more
import ru.fromchat.logging.AppLogEntry
import ru.fromchat.logging.AppLogLevel
import ru.fromchat.logging.AppLogStore
import ru.fromchat.logging.FromChatLogDirs
import ru.fromchat.logging.LogCleanMode
import ru.fromchat.logging.LogCleanRequest
import ru.fromchat.logging.LogFileInfo
import ru.fromchat.logging.LogShare
import ru.fromchat.logging.LogShareCompression
import ru.fromchat.logging.formatLogTimestamp
import ru.fromchat.ui.LocalNavController
import ru.fromchat.ui.components.BackHandler
import ru.fromchat.ui.components.ExpressiveIconFrame
import ru.fromchat.ui.components.PredictiveBackHandler
import ru.fromchat.ui.components.Text
import ru.fromchat.ui.main.chats.ChatSelectionTransitionSpring
import ru.fromchat.ui.main.chats.SelectionCheckmarkSlot
import ru.fromchat.utils.haptic.HapticFeedbackEvent
import ru.fromchat.utils.haptic.rememberHapticFeedback
import androidx.compose.ui.unit.dp

import kotlin.time.Instant

private val LogsSheetEnterTween = tween<Float>(durationMillis = 180, easing = FastOutSlowInEasing)
private val LogsSheetExitTween = tween<Float>(durationMillis = 120, easing = FastOutLinearInEasing)

private enum class LogsListMode {
    Normal,
    Selecting,
}

internal data class LogsShareRequest(
    val sourcePath: String?,
    val isCurrentLog: Boolean,
    val entries: List<AppLogEntry>? = null,
)

internal const val LOG_FILE_OPEN_RESULT_KEY = "logFileToOpen"

@OptIn(
    ExperimentalMaterial3Api::class,
    ExperimentalMaterial3ExpressiveApi::class,
    ExperimentalFoundationApi::class,
)
@Composable
fun LogsScreen() {
    val navController = LocalNavController.current
    val scope = rememberCoroutineScope()
    val clipboard = supportClipboardManagerImpl
    val haptic = rememberHapticFeedback()
    val density = LocalDensity.current
    val topAppBarState = rememberTopAppBarState()
    val scrollBehavior = TopAppBarDefaults.pinnedScrollBehavior(topAppBarState)
    val listState = rememberLazyListState()

    val liveEntries by AppLogStore.entries.collectAsState()
    var viewedEntries by remember { mutableStateOf<List<AppLogEntry>?>(null) }
    var viewingFilePath by remember { mutableStateOf<String?>(null) }

    val displayEntries = viewedEntries ?: liveEntries
    val displayFileName = viewingFilePath?.substringAfterLast('/')
        ?: FromChatLogDirs.CURRENT_LOG_FILE
    val isViewingCurrent = viewingFilePath == null

    var menuExpanded by remember { mutableStateOf(false) }
    var showCleanSheet by remember { mutableStateOf(false) }
    var showShareSheet by remember { mutableStateOf(false) }
    var showDecompressDialog by remember { mutableStateOf(false) }
    var showDeleteFileConfirm by remember { mutableStateOf(false) }
    var showRotateConfirm by remember { mutableStateOf(false) }
    var pendingDeletePaths by remember { mutableStateOf<Set<String>>(emptySet()) }

    var cleanMode by remember { mutableStateOf(LogCleanMode.Size) }
    var sizeLimitMb by remember { mutableIntStateOf(10) }
    var keepEntries by remember { mutableIntStateOf(1_000) }
    var cleanBeforeDate by remember { mutableStateOf<LocalDate?>(null) }

    var listMode by remember { mutableStateOf(LogsListMode.Normal) }
    var selectedEntryIds by remember { mutableStateOf<Set<Long>>(emptySet()) }
    val selectionTransitionProgress = remember { Animatable(0f) }
    val gestureState = rememberLogsListGestureState()
    var dragAnchorIndex by remember { mutableIntStateOf(-1) }
    var dragLastY by remember { mutableFloatStateOf(0f) }
    var listRootY by remember { mutableFloatStateOf(0f) }
    val followLatestState = remember { mutableStateOf(true) }
    var followLatest by followLatestState
    var isAtBottom by remember { mutableStateOf(true) }
    var isProgrammaticScroll by remember { mutableStateOf(false) }

    val disableFollowOnUserScroll = remember {
        object : NestedScrollConnection {
            override fun onPreScroll(available: Offset, source: NestedScrollSource): Offset {
                if (source == NestedScrollSource.UserInput) {
                    followLatestState.value = false
                }
                return Offset.Zero
            }
        }
    }

    var decompressProgress by remember { mutableFloatStateOf(0f) }
    var pendingShareRequest by remember { mutableStateOf<LogsShareRequest?>(null) }

    val shareTitle = stringResource(Res.string.logs_title)
    val selectionMode = listMode == LogsListMode.Selecting
    val selectionProgress = selectionTransitionProgress.value
    val showBrowseFab = AppLogStore.hasFilesBesidesCurrent() && !selectionMode
    val showScrollToBottomFab = isViewingCurrent &&
        !selectionMode &&
        displayEntries.isNotEmpty() &&
        !isAtBottom &&
        !isProgrammaticScroll
    val scrollToBottomCd = stringResource(Res.string.logs_scroll_to_bottom_cd)

    val selectedCountTitle = stringResource(Res.string.logs_selected_count, selectedEntryIds.size)
    val closeSelectionCd = stringResource(Res.string.cd_close_selection)
    val copyLabel = stringResource(Res.string.action_copy)
    val shareLabel = stringResource(Res.string.logs_share)
    val deleteLabel = stringResource(Res.string.action_delete)

    fun scrollToLatestLogs() {
        if (displayEntries.isEmpty()) return
        scope.launch {
            isProgrammaticScroll = true
            listState.animateScrollToItem(displayEntries.lastIndex)
            isProgrammaticScroll = false
            followLatest = listState.isScrolledToEnd()
        }
    }

    fun openLogFile(file: LogFileInfo) {
        scope.launch {
            if (file.isGzip) {
                decompressProgress = 0f
                showDecompressDialog = true
                val parsed = AppLogStore.loadEntriesFromPath(file.path) { decompressProgress = it }
                showDecompressDialog = false
                viewingFilePath = file.path
                viewedEntries = parsed
            } else {
                viewingFilePath = if (file.name == FromChatLogDirs.CURRENT_LOG_FILE) null else file.path
                viewedEntries = if (file.name == FromChatLogDirs.CURRENT_LOG_FILE) {
                    null
                } else {
                    AppLogStore.loadEntriesFromPath(file.path)
                }
            }
        }
    }

    fun enterEntrySelection(entryId: Long) {
        haptic(HapticFeedbackEvent.SelectionModeEntered)
        scope.launch { selectionTransitionProgress.snapTo(0f) }
        listMode = LogsListMode.Selecting
        selectedEntryIds = setOf(entryId)
    }

    fun exitEntrySelection() {
        gestureState.reset()
        scope.launch { selectionTransitionProgress.snapTo(0f) }
        listMode = LogsListMode.Normal
        selectedEntryIds = emptySet()
        dragAnchorIndex = -1
    }

    fun requestExitEntrySelection() {
        scope.launch {
            selectionTransitionProgress.animateTo(0f, ChatSelectionTransitionSpring)
            exitEntrySelection()
        }
    }

    fun performShare(compression: LogShareCompression) {
        val request = pendingShareRequest ?: return
        scope.launch {
            val path = AppLogStore.prepareSharePath(
                sourcePath = request.sourcePath,
                isCurrentLog = request.isCurrentLog,
                compression = compression,
                entries = request.entries,
            )
            val mimeType = when {
                compression == LogShareCompression.Compressed -> "application/gzip"
                path.endsWith(".gz") -> "application/gzip"
                else -> "text/plain"
            }
            LogShare.shareFile(shareTitle, path, mimeType)
            pendingShareRequest = null
            showShareSheet = false
            if (selectionMode) requestExitEntrySelection()
        }
    }

    fun applyDragSelectionRange(toIndex: Int) {
        val anchor = dragAnchorIndex
        if (anchor < 0 || toIndex < 0) return
        val start = minOf(anchor, toIndex)
        val end = maxOf(anchor, toIndex)
        selectedEntryIds = displayEntries.subList(start, end + 1).map { it.id }.toSet()
    }

    fun beginDragSelection(index: Int) {
        if (index !in displayEntries.indices) return
        gestureState.onDragSelectionStart()
        dragAnchorIndex = index
        if (!selectionMode) {
            enterEntrySelection(displayEntries[index].id)
        } else {
            applyDragSelectionRange(index)
        }
    }

    fun handleEntryTap(entry: AppLogEntry) {
        if (gestureState.shouldSuppressTap()) return
        if (!selectionMode) {
            scope.launch { clipboard.setText(entry.displayText()) }
            return
        }
        val wasSelected = entry.id in selectedEntryIds
        selectedEntryIds = if (wasSelected) {
            selectedEntryIds - entry.id
        } else {
            selectedEntryIds + entry.id
        }
    }

    fun resetToCurrentLog() {
        viewingFilePath = null
        viewedEntries = null
    }

    LaunchedEffect(Unit) {
        AppLogStore.ensureLoaded()
    }

    LaunchedEffect(navController.currentBackStackEntry) {
        navController.currentBackStackEntry
            ?.savedStateHandle
            ?.getStateFlow<String?>(LOG_FILE_OPEN_RESULT_KEY, null)
            ?.collect { path ->
                if (path == null) return@collect
                val file = AppLogStore.listLogFiles().firstOrNull { it.path == path } ?: return@collect
                openLogFile(file)
                navController.currentBackStackEntry?.savedStateHandle?.remove<String>(LOG_FILE_OPEN_RESULT_KEY)
            }
    }

    LaunchedEffect(displayEntries.size, isViewingCurrent, followLatest, selectionMode) {
        if (
            isViewingCurrent &&
            displayEntries.isNotEmpty() &&
            !selectionMode &&
            followLatest
        ) {
            isProgrammaticScroll = true
            listState.scrollToItem(displayEntries.lastIndex)
            isProgrammaticScroll = false
        }
    }

    LaunchedEffect(gestureState.dragSelectActive, listState) {
        if (!gestureState.dragSelectActive) return@LaunchedEffect
        val edgeThresholdPx = with(density) { 72.dp.toPx() }
        while (isActive && gestureState.dragSelectActive) {
            val viewportHeight = listState.layoutInfo.viewportSize.height.toFloat()
            when {
                dragLastY < edgeThresholdPx -> {
                    listState.scrollBy(-18f)
                    listState.indexAtY(dragLastY)?.let { applyDragSelectionRange(it) }
                }
                dragLastY > viewportHeight - edgeThresholdPx -> {
                    listState.scrollBy(18f)
                    listState.indexAtY(dragLastY)?.let { applyDragSelectionRange(it) }
                }
            }
            delay(16)
        }
    }

    LaunchedEffect(listState) {
        snapshotFlow {
            listState.isScrolledToEnd() to listState.isScrollInProgress
        }.collect { (atBottom, inProgress) ->
            isAtBottom = atBottom
            if (!isProgrammaticScroll && atBottom && !inProgress) {
                followLatest = true
            }
            if (listState.firstVisibleItemIndex > 0 || listState.firstVisibleItemScrollOffset > 0) {
                if (topAppBarState.overlappedFraction < 1f) {
                    topAppBarState.contentOffset = topAppBarState.heightOffsetLimit
                }
            }
        }
    }

    LaunchedEffect(selectionMode) {
        if (selectionMode) {
            followLatest = false
        } else if (isAtBottom) {
            followLatest = true
        }
    }

    LaunchedEffect(listMode) {
        if (listMode == LogsListMode.Selecting) {
            selectionTransitionProgress.animateTo(1f, ChatSelectionTransitionSpring)
        }
    }

    LaunchedEffect(selectedEntryIds, listMode) {
        if (listMode == LogsListMode.Selecting && selectedEntryIds.isEmpty()) {
            requestExitEntrySelection()
        }
    }

    DisposableEffect(Unit) {
        onDispose { exitEntrySelection() }
    }

    if (showDecompressDialog) {
        AlertDialog(
            onDismissRequest = {},
            title = { Text(stringResource(Res.string.logs_decompressing)) },
            text = {
                Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                    LinearProgressIndicator(
                        progress = { decompressProgress },
                        modifier = Modifier.fillMaxWidth(),
                    )
                }
            },
            confirmButton = {},
        )
    }

    if (showDeleteFileConfirm) {
        AlertDialog(
            onDismissRequest = { showDeleteFileConfirm = false },
            title = { Text(stringResource(Res.string.logs_delete_file_confirm_title)) },
            text = { Text(stringResource(Res.string.logs_delete_file_confirm_body)) },
            confirmButton = {
                TextButton(onClick = {
                    scope.launch {
                        pendingDeletePaths.forEach { path ->
                            AppLogStore.deleteLogFile(path)
                        }
                        if (viewingFilePath in pendingDeletePaths) {
                            resetToCurrentLog()
                        }
                        showDeleteFileConfirm = false
                        pendingDeletePaths = emptySet()
                    }
                }) {
                    Text(deleteLabel)
                }
            },
            dismissButton = {
                TextButton(onClick = { showDeleteFileConfirm = false }) {
                    Text(stringResource(Res.string.cancel))
                }
            },
        )
    }

    if (showRotateConfirm) {
        AlertDialog(
            onDismissRequest = { showRotateConfirm = false },
            title = { Text(stringResource(Res.string.logs_rotate_confirm_title)) },
            text = { Text(stringResource(Res.string.logs_rotate_confirm_body)) },
            confirmButton = {
                TextButton(onClick = {
                    showRotateConfirm = false
                    scope.launch {
                        AppLogStore.rotate()
                    }
                }) {
                    Text(stringResource(Res.string.confirm))
                }
            },
            dismissButton = {
                TextButton(onClick = { showRotateConfirm = false }) {
                    Text(stringResource(Res.string.cancel))
                }
            },
        )
    }

    if (showShareSheet) {
        val sheetState = rememberModalBottomSheetState(skipPartiallyExpanded = true)
        ModalBottomSheet(
            onDismissRequest = {
                showShareSheet = false
                pendingShareRequest = null
            },
            sheetState = sheetState,
        ) {
            LogsShareBottomSheet(
                onUncompressed = { performShare(LogShareCompression.Uncompressed) },
                onCompressed = { performShare(LogShareCompression.Compressed) },
            )
        }
    }

    if (showCleanSheet) {
        val sheetState = rememberModalBottomSheetState(skipPartiallyExpanded = true)
        ModalBottomSheet(
            onDismissRequest = { showCleanSheet = false },
            sheetState = sheetState,
        ) {
            LogsCleanBottomSheet(
                cleanMode = cleanMode,
                onCleanModeChange = { cleanMode = it },
                sizeLimitMb = sizeLimitMb,
                onSizeLimitMbChange = { sizeLimitMb = it },
                keepEntries = keepEntries,
                onKeepEntriesChange = { keepEntries = it },
                cleanBeforeDate = cleanBeforeDate,
                onCleanBeforeDateChange = { cleanBeforeDate = it },
                onDismiss = { showCleanSheet = false },
                onApply = {
                    scope.launch {
                        AppLogStore.clean(
                            LogCleanRequest(
                                mode = cleanMode,
                                maxTotalBytes = sizeLimitMb.toLong() * 1024L * 1024L,
                                keepNewestEntries = keepEntries,
                                deleteBefore = cleanBeforeDate,
                            ),
                        )
                        if (!isViewingCurrent) resetToCurrentLog()
                        sheetState.hide()
                        showCleanSheet = false
                    }
                },
            )
        }
    }

    BackHandler(enabled = selectionMode) { requestExitEntrySelection() }
    PredictiveBackHandler(
        enabled = selectionMode,
        onProgress = { backProgress ->
            scope.launch {
                selectionTransitionProgress.snapTo((1f - backProgress).coerceIn(0f, 1f))
            }
        },
        onCommit = { requestExitEntrySelection() },
        onCancel = {
            if (selectionMode) {
                scope.launch {
                    selectionTransitionProgress.animateTo(1f, ChatSelectionTransitionSpring)
                }
            }
        },
    )


    Scaffold(
        modifier = Modifier
            .fillMaxSize()
            .nestedScroll(scrollBehavior.nestedScrollConnection),
        containerColor = Color.Transparent,
        contentWindowInsets = WindowInsets.navigationBars,
        floatingActionButtonPosition = FabPosition.End,
        floatingActionButton = {
            val fabReveal = (1f - selectionProgress).coerceIn(0f, 1f)
            Column(
                horizontalAlignment = Alignment.End,
                verticalArrangement = Arrangement.spacedBy(12.dp),
            ) {
                LogsAnimatedFab(
                    visible = showScrollToBottomFab && fabReveal > 0f,
                    alpha = fabReveal,
                    onClick = { scrollToLatestLogs() },
                    contentDescription = scrollToBottomCd,
                    icon = Icons.Default.KeyboardArrowDown,
                    small = true,
                )
                LogsAnimatedFab(
                    visible = showBrowseFab && fabReveal > 0f,
                    alpha = fabReveal,
                    onClick = { navController.navigate(SettingsRoutes.LogFiles) },
                    contentDescription = stringResource(Res.string.logs_browse_files_cd),
                    icon = Icons.Default.Folder,
                )
            }
        },
        topBar = {
            Box {
                TopAppBar(
                    modifier = Modifier.graphicsLayer { alpha = 1f - selectionProgress },
                    navigationIcon = {
                        IconButton(
                            onClick = { navController.navigateUp() },
                            enabled = selectionProgress < 1f,
                        ) {
                            Icon(
                                imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                                contentDescription = stringResource(Res.string.back),
                            )
                        }
                    },
                    title = {
                        Column {
                            Text(stringResource(Res.string.logs_title))
                            Text(
                                text = displayFileName,
                                style = MaterialTheme.typography.bodyMedium,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                                maxLines = 1,
                                overflow = TextOverflow.Ellipsis,
                            )
                        }
                    },
                    actions = {
                        if (isViewingCurrent && !selectionMode) {
                            IconButton(
                                onClick = {
                                    pendingShareRequest = LogsShareRequest(
                                        sourcePath = FromChatLogDirs.currentLogPath(),
                                        isCurrentLog = true,
                                    )
                                    showShareSheet = true
                                },
                            ) {
                                Icon(
                                    imageVector = Icons.Default.Share,
                                    contentDescription = shareLabel,
                                )
                            }
                        }
                        Box {
                            IconButton(onClick = { menuExpanded = true }) {
                                Icon(
                                    imageVector = Icons.Default.MoreVert,
                                    contentDescription = stringResource(Res.string.more),
                                )
                            }
                            DropdownMenu(
                                expanded = menuExpanded,
                                onDismissRequest = { menuExpanded = false },
                            ) {
                                if (isViewingCurrent) {
                                    DropdownMenuItem(
                                        text = { Text(stringResource(Res.string.logs_rotate)) },
                                        leadingIcon = {
                                            Icon(Icons.Default.Sync, contentDescription = null)
                                        },
                                        onClick = {
                                            menuExpanded = false
                                            showRotateConfirm = true
                                        },
                                    )
                                    DropdownMenuItem(
                                        text = { Text(stringResource(Res.string.logs_clean)) },
                                        leadingIcon = {
                                            Icon(Icons.Default.CleaningServices, contentDescription = null)
                                        },
                                        onClick = {
                                            menuExpanded = false
                                            showCleanSheet = true
                                        },
                                    )
                                } else {
                                    DropdownMenuItem(
                                        text = { Text(deleteLabel) },
                                        leadingIcon = {
                                            Icon(Icons.Default.Delete, contentDescription = null)
                                        },
                                        onClick = {
                                            menuExpanded = false
                                            viewingFilePath?.let { path ->
                                                pendingDeletePaths = setOf(path)
                                                showDeleteFileConfirm = true
                                            }
                                        },
                                    )
                                }
                            }
                        }
                    },
                    scrollBehavior = scrollBehavior,
                )
                if (selectionMode || selectionProgress > 0f) {
                    TopAppBar(
                        modifier = Modifier.graphicsLayer { alpha = selectionProgress },
                        navigationIcon = {
                            IconButton(
                                onClick = { requestExitEntrySelection() },
                                enabled = selectionProgress > 0f,
                            ) {
                                Icon(
                                    imageVector = Icons.Default.Close,
                                    contentDescription = closeSelectionCd,
                                )
                            }
                        },
                        title = {
                            Text(
                                text = selectedCountTitle,
                                style = MaterialTheme.typography.titleLarge,
                                maxLines = 1,
                                overflow = TextOverflow.Ellipsis,
                            )
                        },
                        actions = {
                            IconButton(
                                onClick = {
                                    scope.launch {
                                        val text = displayEntries
                                            .filter { it.id in selectedEntryIds }
                                            .joinToString("\n") { it.displayText() }
                                        clipboard.setText(text)
                                        requestExitEntrySelection()
                                    }
                                },
                                enabled = selectionProgress > 0f && selectedEntryIds.isNotEmpty(),
                            ) {
                                Icon(Icons.Default.ContentCopy, contentDescription = copyLabel)
                            }
                            IconButton(
                                onClick = {
                                    pendingShareRequest = LogsShareRequest(
                                        sourcePath = viewingFilePath,
                                        isCurrentLog = isViewingCurrent,
                                        entries = displayEntries.filter { it.id in selectedEntryIds },
                                    )
                                    showShareSheet = true
                                },
                                enabled = selectionProgress > 0f && selectedEntryIds.isNotEmpty(),
                            ) {
                                Icon(Icons.Default.Share, contentDescription = shareLabel)
                            }
                        },
                    )
                }
            }
        },
    ) { innerPadding ->
        if (displayEntries.isEmpty()) {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(innerPadding),
                verticalArrangement = Arrangement.Center,
                horizontalAlignment = Alignment.CenterHorizontally,
            ) {
                Text(
                    text = stringResource(Res.string.logs_empty),
                    style = MaterialTheme.typography.bodyLarge,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
        } else {
            val listContent: @Composable () -> Unit = {
                LazyColumn(
                    state = listState,
                    modifier = Modifier
                        .fillMaxSize()
                        .nestedScroll(disableFollowOnUserScroll)
                        .onGloballyPositioned { listRootY = it.positionInRoot().y },
                    contentPadding = PaddingValues(
                        start = 16.dp,
                        end = 16.dp,
                        top = 8.dp,
                        bottom = 8.dp,
                    ),
                    verticalArrangement = Arrangement.spacedBy(8.dp),
                ) {
                    itemsIndexed(
                        items = displayEntries,
                        key = { _, entry -> entry.id },
                    ) { index, entry ->
                        LogEntryRow(
                            entry = entry,
                            selectionMode = selectionMode,
                            selectionProgress = selectionProgress,
                            isSelected = entry.id in selectedEntryIds,
                            gestureState = gestureState,
                            getListRootY = { listRootY },
                            onBeginDragSelection = { beginDragSelection(index) },
                            onDragAtListLocalY = { listLocalY ->
                                dragLastY = listLocalY
                                listState.indexAtY(listLocalY)?.let { applyDragSelectionRange(it) }
                            },
                            onRowTap = { handleEntryTap(entry) },
                        )
                    }
                }
            }

            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(innerPadding),
            ) {
                listContent()
            }
        }
    }
}

@Composable
internal fun LogsAnimatedFab(
    visible: Boolean,
    alpha: Float,
    onClick: () -> Unit,
    contentDescription: String,
    icon: ImageVector,
    small: Boolean = false,
) {
    AnimatedVisibility(
        visible = visible,
        enter = fadeIn(ChatSelectionTransitionSpring) + slideInVertically(
            animationSpec = spring(
                dampingRatio = Spring.DampingRatioNoBouncy,
                stiffness = Spring.StiffnessMediumLow,
            ),
            initialOffsetY = { fullHeight -> fullHeight },
        ),
        exit = fadeOut(ChatSelectionTransitionSpring) + slideOutVertically(
            animationSpec = spring(
                dampingRatio = Spring.DampingRatioNoBouncy,
                stiffness = Spring.StiffnessMediumLow,
            ),
            targetOffsetY = { fullHeight -> fullHeight },
        ),
    ) {
        if (small) {
            SmallFloatingActionButton(
                modifier = Modifier.graphicsLayer { this.alpha = alpha },
                onClick = onClick,
            ) {
                Icon(imageVector = icon, contentDescription = contentDescription)
            }
        } else {
            FloatingActionButton(
                modifier = Modifier.graphicsLayer { this.alpha = alpha },
                onClick = onClick,
            ) {
                Icon(imageVector = icon, contentDescription = contentDescription)
            }
        }
    }
}

@OptIn(ExperimentalMaterial3ExpressiveApi::class)
@Composable
internal fun LogsShareBottomSheet(
    onUncompressed: () -> Unit,
    onCompressed: () -> Unit,
) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .navigationBarsPadding()
            .padding(horizontal = 16.dp)
            .padding(bottom = 24.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp),
    ) {
        Text(
            text = stringResource(Res.string.logs_share_how_title),
            style = MaterialTheme.typography.titleLarge,
        )
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(12.dp),
        ) {
            Surface(
                onClick = onUncompressed,
                modifier = Modifier.weight(1f),
                shape = MaterialTheme.shapes.large,
                color = MaterialTheme.colorScheme.secondaryContainer,
            ) {
                Column(
                    modifier = Modifier.padding(20.dp),
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.spacedBy(12.dp),
                ) {
                    Icon(
                        imageVector = Icons.AutoMirrored.Rounded.InsertDriveFile,
                        contentDescription = null,
                        modifier = Modifier.size(48.dp),
                        tint = MaterialTheme.colorScheme.onSecondaryContainer,
                    )
                    Text(
                        text = stringResource(Res.string.logs_share_uncompressed),
                        style = MaterialTheme.typography.titleMedium,
                        color = MaterialTheme.colorScheme.onSecondaryContainer,
                    )
                    Text(
                        text = stringResource(Res.string.logs_share_uncompressed_desc),
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSecondaryContainer,
                    )
                }
            }
            Surface(
                onClick = onCompressed,
                modifier = Modifier.weight(1f),
                shape = MaterialTheme.shapes.large,
                color = MaterialTheme.colorScheme.tertiaryContainer,
            ) {
                Column(
                    modifier = Modifier.padding(20.dp),
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.spacedBy(12.dp),
                ) {
                    Icon(
                        imageVector = Icons.Default.Compress,
                        contentDescription = null,
                        modifier = Modifier.size(48.dp),
                        tint = MaterialTheme.colorScheme.onTertiaryContainer,
                    )
                    Text(
                        text = stringResource(Res.string.logs_share_compressed),
                        style = MaterialTheme.typography.titleMedium,
                        color = MaterialTheme.colorScheme.onTertiaryContainer,
                    )
                    Text(
                        text = stringResource(Res.string.logs_share_compressed_desc),
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onTertiaryContainer,
                    )
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class, ExperimentalMaterial3ExpressiveApi::class)
@Composable
private fun LogsCleanBottomSheet(
    cleanMode: LogCleanMode,
    onCleanModeChange: (LogCleanMode) -> Unit,
    sizeLimitMb: Int,
    onSizeLimitMbChange: (Int) -> Unit,
    keepEntries: Int,
    onKeepEntriesChange: (Int) -> Unit,
    cleanBeforeDate: LocalDate?,
    onCleanBeforeDateChange: (LocalDate?) -> Unit,
    onDismiss: () -> Unit,
    onApply: () -> Unit,
) {
    val scrollState = rememberScrollState()
    val datePickerState = rememberDatePickerState(
        initialSelectedDateMillis = cleanBeforeDate?.let { date ->
            date.atStartOfDayIn(TimeZone.currentSystemDefault()).toEpochMilliseconds()
        },
    )

    LaunchedEffect(datePickerState.selectedDateMillis) {
        val millis = datePickerState.selectedDateMillis ?: return@LaunchedEffect
        onCleanBeforeDateChange(
            Instant.fromEpochMilliseconds(millis)
                .toLocalDateTime(TimeZone.currentSystemDefault())
                .date,
        )
    }

    Column(
        modifier = Modifier
            .fillMaxWidth()
            .verticalScroll(scrollState)
            .navigationBarsPadding()
            .padding(bottom = 16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(12.dp),
    ) {
        ExpressiveIconFrame(
            icon = Icons.Default.CleaningServices,
            materialPolygon = MaterialShapes.Cookie7Sided,
            containerSize = 88.dp,
            iconSize = 40.dp,
        )

        Text(
            text = stringResource(Res.string.logs_clean_title),
            style = MaterialTheme.typography.headlineSmall,
        )

        Category(
            margin = PaddingValues(horizontal = 16.dp),
            containerColor = MaterialTheme.colorScheme.surfaceContainerHigh,
        ) {
            ListItem(
                headline = stringResource(Res.string.logs_clean_mode_size),
                trailingContent = {
                    RadioButton(
                        selected = cleanMode == LogCleanMode.Size,
                        onClick = null,
                    )
                },
                onClick = { onCleanModeChange(LogCleanMode.Size) },
                divider = true,
            )
            ListItem(
                headline = stringResource(Res.string.logs_clean_mode_all),
                trailingContent = {
                    RadioButton(
                        selected = cleanMode == LogCleanMode.All,
                        onClick = null,
                    )
                },
                onClick = { onCleanModeChange(LogCleanMode.All) },
                divider = true,
            )
            ListItem(
                headline = stringResource(Res.string.logs_clean_mode_entries),
                trailingContent = {
                    RadioButton(
                        selected = cleanMode == LogCleanMode.Entries,
                        onClick = null,
                    )
                },
                onClick = { onCleanModeChange(LogCleanMode.Entries) },
                divider = true,
            )
            ListItem(
                headline = stringResource(Res.string.logs_clean_mode_date),
                trailingContent = {
                    RadioButton(
                        selected = cleanMode == LogCleanMode.Date,
                        onClick = null,
                    )
                },
                onClick = { onCleanModeChange(LogCleanMode.Date) },
                divider = false,
            )
        }

        AnimatedContent(
            targetState = cleanMode,
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 16.dp)
                .animateContentSize(
                    animationSpec = spring(
                        dampingRatio = Spring.DampingRatioNoBouncy,
                        stiffness = Spring.StiffnessMedium,
                    ),
                ),
            transitionSpec = {
                fadeIn(LogsSheetEnterTween) + slideInVertically(
                    animationSpec = tween(durationMillis = 180, easing = FastOutSlowInEasing),
                    initialOffsetY = { height -> height / 8 },
                ) togetherWith fadeOut(LogsSheetExitTween) + slideOutVertically(
                    animationSpec = tween(durationMillis = 120, easing = FastOutLinearInEasing),
                    targetOffsetY = { height -> -height / 8 },
                )
            },
            label = "logs_clean_mode_body",
        ) { mode ->
            Column(
                modifier = Modifier.fillMaxWidth(),
                verticalArrangement = Arrangement.spacedBy(8.dp),
            ) {
                when (mode) {
                    LogCleanMode.Size -> {
                        Text(
                            text = stringResource(Res.string.logs_clean_size_body),
                            style = MaterialTheme.typography.bodyMedium,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                        Text(
                            text = stringResource(Res.string.logs_clean_size_mb, sizeLimitMb),
                            style = MaterialTheme.typography.labelLarge,
                        )
                        Slider(
                            value = sizeLimitMb.toFloat(),
                            onValueChange = { onSizeLimitMbChange(it.toInt().coerceIn(1, 100)) },
                            valueRange = 1f..100f,
                        )
                    }

                    LogCleanMode.All -> {
                        Text(
                            text = stringResource(Res.string.logs_clean_all_body),
                            style = MaterialTheme.typography.bodyMedium,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }

                    LogCleanMode.Entries -> {
                        Text(
                            text = stringResource(Res.string.logs_clean_entries_body),
                            style = MaterialTheme.typography.bodyMedium,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                        Text(
                            text = stringResource(Res.string.logs_clean_entries_count, keepEntries),
                            style = MaterialTheme.typography.labelLarge,
                        )
                        Slider(
                            value = keepEntries.toFloat(),
                            onValueChange = { onKeepEntriesChange(it.toInt().coerceIn(100, 10_000)) },
                            valueRange = 100f..10_000f,
                        )
                    }

                    LogCleanMode.Date -> {
                        Text(
                            text = stringResource(Res.string.logs_clean_date_body),
                            style = MaterialTheme.typography.bodyMedium,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                        DatePicker(state = datePickerState)
                    }
                }
            }
        }

        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 16.dp),
            horizontalArrangement = Arrangement.End,
        ) {
            TextButton(onClick = onDismiss) {
                Text(stringResource(Res.string.cancel))
            }
            FilledTonalButton(onClick = onApply) {
                Text(stringResource(Res.string.logs_clean_apply))
            }
        }
    }
}

@OptIn(ExperimentalLayoutApi::class)
@Composable
private fun LogEntryRow(
    entry: AppLogEntry,
    selectionMode: Boolean,
    selectionProgress: Float,
    isSelected: Boolean,
    gestureState: LogsListGestureState,
    getListRootY: () -> Float,
    onBeginDragSelection: () -> Unit,
    onDragAtListLocalY: (Float) -> Unit,
    onRowTap: () -> Unit,
) {
    val scope = rememberCoroutineScope()
    val rowInteractionSource = remember { MutableInteractionSource() }
    val rowRootYHolder = remember { LogsRowRootYHolder() }

    val tintProgress = if (isSelected) selectionProgress.coerceIn(0f, 1f) else 0f
    val colors = logsSelectionColors(
        isSelected = isSelected,
        selectionProgress = tintProgress,
        baseContainerColor = MaterialTheme.colorScheme.surfaceContainerLow,
    )

    val bodyStyle = MaterialTheme.typography.bodySmall.copy(
        fontFamily = FontFamily.Monospace,
        color = colors.bodyColor,
    )
    val mutedStyle = bodyStyle.copy(color = colors.mutedColor)

    Surface(
        modifier = Modifier
            .fillMaxWidth()
            .onGloballyPositioned { rowRootYHolder.y = it.positionInRoot().y }
            .clickable(
                interactionSource = rowInteractionSource,
                indication = null,
                onClick = {
                    if (!gestureState.shouldSuppressTap()) {
                        onRowTap()
                    }
                },
            )
            .logsRowDragSelectGestures(
                gestureState = gestureState,
                scope = scope,
                rowRootYHolder = rowRootYHolder,
                getListRootY = getListRootY,
                onDragStart = onBeginDragSelection,
                onDragAtListLocalY = onDragAtListLocalY,
            )
            .clip(MaterialTheme.shapes.medium),
        shape = MaterialTheme.shapes.medium,
        color = colors.containerColor,
    ) {
        LogEntryContent(
            entry = entry,
            bodyStyle = bodyStyle,
            mutedStyle = mutedStyle,
            levelChipContentColor = colors.mutedColor,
            isSelected = isSelected,
            selectionProgress = selectionProgress,
            modifier = Modifier
                .fillMaxWidth()
                .padding(12.dp),
        )
    }
}

@OptIn(ExperimentalLayoutApi::class)
@Composable
private fun LogEntryMetadata(
    entry: AppLogEntry,
    mutedStyle: androidx.compose.ui.text.TextStyle,
    levelChipContentColor: Color,
    selectionProgress: Float,
    isSelected: Boolean,
    modifier: Modifier = Modifier,
) {
    Row(
        modifier = modifier.fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        SelectionCheckmarkSlot(
            selectionTransitionProgress = selectionProgress,
            isSelected = isSelected,
        )
        FlowRow(
            modifier = Modifier.weight(1f),
            horizontalArrangement = Arrangement.spacedBy(8.dp),
            verticalArrangement = Arrangement.spacedBy(4.dp),
        ) {
            Text(
                text = formatLogTimestamp(entry.timestamp),
                style = mutedStyle,
                modifier = Modifier.align(Alignment.CenterVertically),
            )
            LogLevelChip(
                level = entry.level,
                contentColorOverride = levelChipContentColor,
                modifier = Modifier.align(Alignment.CenterVertically),
            )
            Text(
                text = entry.tag,
                style = MaterialTheme.typography.labelLarge,
                color = mutedStyle.color,
                modifier = Modifier.align(Alignment.CenterVertically),
            )
        }
    }
}

@Composable
private fun LogEntryMessageBody(
    entry: AppLogEntry,
    bodyStyle: androidx.compose.ui.text.TextStyle,
    mutedStyle: androidx.compose.ui.text.TextStyle,
) {
    Column(verticalArrangement = Arrangement.spacedBy(6.dp)) {
        Text(
            text = entry.message,
            style = bodyStyle,
            modifier = Modifier.fillMaxWidth(),
        )
        entry.stackTrace?.takeIf { it.isNotBlank() }?.let { trace ->
            Text(
                text = trace,
                style = mutedStyle,
                modifier = Modifier.fillMaxWidth(),
            )
        }
    }
}

@OptIn(ExperimentalLayoutApi::class)
@Composable
private fun LogEntryContent(
    entry: AppLogEntry,
    bodyStyle: androidx.compose.ui.text.TextStyle,
    mutedStyle: androidx.compose.ui.text.TextStyle,
    levelChipContentColor: Color,
    isSelected: Boolean,
    selectionProgress: Float,
    modifier: Modifier = Modifier,
) {
    DisableSelection {
        Column(
            modifier = modifier,
            verticalArrangement = Arrangement.spacedBy(6.dp),
        ) {
            LogEntryMetadata(
                entry = entry,
                mutedStyle = mutedStyle,
                levelChipContentColor = levelChipContentColor,
                selectionProgress = selectionProgress,
                isSelected = isSelected,
            )
            LogEntryMessageBody(
                entry = entry,
                bodyStyle = bodyStyle,
                mutedStyle = mutedStyle,
            )
        }
    }
}

@Composable
private fun LogLevelChipContent(
    level: AppLogLevel,
    label: String,
    containerColor: Color,
    contentColor: Color,
    labelStyle: androidx.compose.ui.text.TextStyle,
    horizontalPadding: androidx.compose.ui.unit.Dp,
    verticalPadding: androidx.compose.ui.unit.Dp,
    iconSize: androidx.compose.ui.unit.Dp,
    iconTextGap: androidx.compose.ui.unit.Dp,
    modifier: Modifier = Modifier,
) {
    Surface(
        modifier = modifier,
        shape = MaterialTheme.shapes.extraSmall,
        color = containerColor,
    ) {
        Row(
            modifier = Modifier.padding(horizontal = horizontalPadding, vertical = verticalPadding),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Icon(
                imageVector = level.icon(),
                contentDescription = null,
                modifier = Modifier.size(iconSize),
                tint = contentColor,
            )
            Text(
                text = label,
                modifier = Modifier.padding(start = iconTextGap),
                style = labelStyle,
            )
        }
    }
}

@Composable
private fun AppLogLevel.displayLabel(): String = stringResource(
    when (this) {
        AppLogLevel.Verbose -> Res.string.logs_level_verbose
        AppLogLevel.Debug -> Res.string.logs_level_debug
        AppLogLevel.Info -> Res.string.logs_level_info
        AppLogLevel.Warn -> Res.string.logs_level_warn
        AppLogLevel.Error -> Res.string.logs_level_error
        AppLogLevel.Fatal -> Res.string.logs_level_fatal
    },
)

@Composable
private fun logLevelChipColors(level: AppLogLevel): Pair<Color, Color> {
    val containerColor = when (level) {
        AppLogLevel.Debug -> MaterialTheme.colorScheme.surfaceContainerHighest
        AppLogLevel.Verbose -> MaterialTheme.colorScheme.surfaceContainerHigh
        AppLogLevel.Info -> MaterialTheme.colorScheme.secondaryContainer
        AppLogLevel.Warn -> MaterialTheme.colorScheme.tertiaryContainer
        AppLogLevel.Error -> MaterialTheme.colorScheme.errorContainer
        AppLogLevel.Fatal -> MaterialTheme.colorScheme.error
    }
    val contentColor = when (level) {
        AppLogLevel.Debug -> MaterialTheme.colorScheme.onSurfaceVariant
        AppLogLevel.Verbose -> MaterialTheme.colorScheme.onSurfaceVariant
        AppLogLevel.Info -> MaterialTheme.colorScheme.onSecondaryContainer
        AppLogLevel.Warn -> MaterialTheme.colorScheme.onTertiaryContainer
        AppLogLevel.Error -> MaterialTheme.colorScheme.onErrorContainer
        AppLogLevel.Fatal -> MaterialTheme.colorScheme.onError
    }
    return containerColor to contentColor
}

private fun AppLogLevel.icon(): ImageVector = when (this) {
    AppLogLevel.Verbose -> Icons.AutoMirrored.Filled.Subject
    AppLogLevel.Debug -> Icons.Default.BugReport
    AppLogLevel.Info -> Icons.Default.Info
    AppLogLevel.Warn -> Icons.Default.Warning
    AppLogLevel.Error -> Icons.Default.Error
    AppLogLevel.Fatal -> Icons.Default.Report
}

@Composable
private fun LogLevelChip(
    level: AppLogLevel,
    contentColorOverride: Color? = null,
    modifier: Modifier = Modifier,
) {
    val (containerColor, contentColor) = logLevelChipColors(level)
    val resolvedContentColor = contentColorOverride ?: contentColor
    val labelStyle = MaterialTheme.typography.labelSmall.copy(color = resolvedContentColor)
    LogLevelChipContent(
        level = level,
        label = level.displayLabel(),
        containerColor = containerColor,
        contentColor = resolvedContentColor,
        labelStyle = labelStyle,
        horizontalPadding = 8.dp,
        verticalPadding = 2.dp,
        iconSize = 14.dp,
        iconTextGap = 2.dp,
        modifier = modifier,
    )
}
