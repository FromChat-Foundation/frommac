package ru.fromchat.logging

import kotlinx.datetime.LocalDate
import kotlinx.datetime.LocalTime
import kotlinx.datetime.TimeZone
import kotlinx.datetime.atTime
import kotlinx.datetime.number
import kotlinx.datetime.toInstant
import kotlinx.datetime.toLocalDateTime
import kotlin.time.Instant

private val FORMATTED_PRIMARY_LINE_REGEX = Regex(
    """^(\d{2}\.\d{2}\.\d{4}) (\d{2}:\d{2}) \[([A-Z]+)\] (\S+) (.*)$""",
)

data class AppLogEntry(
    val id: Long,
    val timestamp: Instant,
    val level: AppLogLevel,
    val tag: String,
    val message: String,
    val stackTrace: String? = null,
) {
    fun formattedLine(): String = buildString {
        append(formatLogTimestamp(timestamp))
        append(' ')
        append(level.bracketLabel())
        append(' ')
        append(tag)
        append(' ')
        append(message)
        stackTrace?.takeIf { it.isNotBlank() }?.let { trace ->
            append('\n')
            append(trace.prependIndent("\t"))
        }
    }

    fun displayText(): String = formattedLine()
}

fun AppLogLevel.bracketLabel(): String = "[${bracketLevelName()}]"

fun AppLogLevel.bracketLevelName(): String = when (this) {
    AppLogLevel.Debug -> "DEBUG"
    AppLogLevel.Fatal -> "FATAL"
    else -> letter.toString()
}

fun formatLogTimestamp(
    instant: Instant,
    timeZone: TimeZone = TimeZone.currentSystemDefault(),
): String {
    val local = instant.toLocalDateTime(timeZone)
    val date = local.date
    val day = date.day.toString().padStart(2, '0')
    val month = date.month.number.toString().padStart(2, '0')
    val hour = local.hour.toString().padStart(2, '0')
    val minute = local.minute.toString().padStart(2, '0')
    return "$day.$month.${date.year} $hour:$minute"
}

internal fun parseFormattedPrimaryLine(line: String, id: Long): AppLogEntry? {
    val match = FORMATTED_PRIMARY_LINE_REGEX.matchEntire(line) ?: return null
    val (datePart, timePart, levelPart, tag, message) = match.destructured
    val level = levelFromBracket(levelPart) ?: return null
    val timestamp = parseLocalLogTimestamp(datePart, timePart) ?: return null
    return AppLogEntry(
        id = id,
        timestamp = timestamp,
        level = level,
        tag = tag,
        message = message,
    )
}

internal fun parseLocalLogTimestamp(datePart: String, timePart: String): Instant? {
    val dateParts = datePart.split('.')
    val timeParts = timePart.split(':')
    if (dateParts.size != 3 || timeParts.size != 2) return null
    val localDate = runCatching {
        LocalDate(dateParts[2].toInt(), dateParts[1].toInt(), dateParts[0].toInt())
    }.getOrNull() ?: return null
    val localTime = runCatching {
        LocalTime(timeParts[0].toInt(), timeParts[1].toInt())
    }.getOrNull() ?: return null
    return runCatching {
        localDate.atTime(localTime).toInstant(TimeZone.currentSystemDefault())
    }.getOrNull()
}

private fun levelFromBracket(levelPart: String): AppLogLevel? = when (levelPart) {
    "DEBUG" -> AppLogLevel.Debug
    "FATAL" -> AppLogLevel.Fatal
    else -> AppLogLevel.fromLetter(levelPart.firstOrNull() ?: return null)
}
