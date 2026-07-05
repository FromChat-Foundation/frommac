package ru.fromchat.notifications

import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.asSharedFlow

data class NotificationLaunchTarget(
    val dmConversationUserId: Int? = null,
    val scrollToMessageId: Int? = null,
    val startAtPublicChat: Boolean = false,
    val launchId: Long = 0,
)

/**
 * Delivers notification tap targets to [ru.fromchat.ui.App] while the process is already running.
 * Each publish is a distinct event so navigation runs even when the same chat is tapped twice.
 */
object NotificationLaunchCoordinator {
    private var nextLaunchId = 0L
    private val pendingLaunchesFlow = MutableSharedFlow<NotificationLaunchTarget>(extraBufferCapacity = 1)
    val pendingLaunches: SharedFlow<NotificationLaunchTarget> = pendingLaunchesFlow.asSharedFlow()

    fun publish(target: NotificationLaunchTarget) {
        val launchId = ++nextLaunchId
        pendingLaunchesFlow.tryEmit(target.copy(launchId = launchId))
    }
}
