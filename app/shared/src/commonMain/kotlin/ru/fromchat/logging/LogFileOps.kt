package ru.fromchat.logging

internal expect object LogFileOps {
    fun readText(path: String): String

    fun readBytes(path: String): ByteArray

    suspend fun gzipFile(sourcePath: String, destinationPath: String)

    suspend fun readGzipText(path: String, onProgress: (Float) -> Unit): String

    suspend fun gunzipToFile(sourcePath: String, destinationPath: String, onProgress: (Float) -> Unit)

    suspend fun zipFiles(entries: List<Pair<String, String>>, destinationPath: String)
}
