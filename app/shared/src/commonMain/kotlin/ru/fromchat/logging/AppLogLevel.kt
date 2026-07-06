package ru.fromchat.logging

enum class AppLogLevel {
    Verbose,
    Debug,
    Info,
    Warn,
    Error,
    Fatal,
    ;

    val letter: Char
        get() = when (this) {
            Verbose -> 'V'
            Debug -> 'D'
            Info -> 'I'
            Warn -> 'W'
            Error -> 'E'
            Fatal -> 'F'
        }

    companion object {
        fun fromLetter(letter: Char): AppLogLevel? = when (letter.uppercaseChar()) {
            'V' -> Verbose
            'D' -> Debug
            'I' -> Info
            'W' -> Warn
            'E' -> Error
            'F' -> Fatal
            else -> null
        }
    }
}
