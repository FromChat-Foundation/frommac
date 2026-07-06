package ru.fromchat.logging

expect object LogShare {
    fun shareText(title: String, text: String)

    fun shareFile(title: String, filePath: String, mimeType: String = "text/plain")
}
