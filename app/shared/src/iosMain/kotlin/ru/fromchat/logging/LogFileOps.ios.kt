package ru.fromchat.logging

import kotlinx.cinterop.ExperimentalForeignApi
import kotlinx.cinterop.UByteVar
import kotlinx.cinterop.addressOf
import kotlinx.cinterop.alloc
import kotlinx.cinterop.allocArray
import kotlinx.cinterop.convert
import kotlinx.cinterop.memScoped
import kotlinx.cinterop.ptr
import kotlinx.cinterop.reinterpret
import kotlinx.cinterop.toCValues
import kotlinx.cinterop.usePinned
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import platform.Foundation.NSData
import platform.Foundation.NSFileManager
import platform.Foundation.NSString
import platform.Foundation.NSUTF8StringEncoding
import platform.Foundation.create
import platform.Foundation.dataWithContentsOfFile
import platform.Foundation.writeToFile
import platform.posix.memcpy

@OptIn(ExperimentalForeignApi::class)
internal actual object LogFileOps {
    actual fun readText(path: String): String {
        if (!NSFileManager.defaultManager.fileExistsAtPath(path)) return ""
        return NSString.stringWithContentsOfFile(path, encoding = NSUTF8StringEncoding, error = null) as? String
            ?: ""
    }

    actual fun readBytes(path: String): ByteArray {
        if (!NSFileManager.defaultManager.fileExistsAtPath(path)) return ByteArray(0)
        val raw = NSData.dataWithContentsOfFile(path) ?: return ByteArray(0)
        return raw.toByteArray()
    }

    actual suspend fun gzipFile(sourcePath: String, destinationPath: String) = withContext(Dispatchers.Default) {
        if (!NSFileManager.defaultManager.fileExistsAtPath(sourcePath)) return@withContext
        val raw = NSData.dataWithContentsOfFile(sourcePath) ?: return@withContext
        val bytes = raw.toByteArray()
        val gzipped = gzipCompress(bytes)
        val parent = destinationPath.substringBeforeLast('/', missingDelimiterValue = destinationPath)
        NSFileManager.defaultManager.createDirectoryAtPath(parent, true, null, null)
        NSData.create(bytes = gzipped, length = gzipped.size.toULong())
            .writeToFile(destinationPath, true)
        NSFileManager.defaultManager.removeItemAtPath(sourcePath, null)
    }

    actual suspend fun readGzipText(path: String, onProgress: (Float) -> Unit): String =
        withContext(Dispatchers.Default) {
            val bytes = gunzipToByteArray(path, onProgress)
            bytes.decodeToString()
        }

    actual suspend fun gunzipToFile(
        sourcePath: String,
        destinationPath: String,
        onProgress: (Float) -> Unit,
    ) = withContext(Dispatchers.Default) {
        val bytes = gunzipToByteArray(sourcePath, onProgress)
        val parent = destinationPath.substringBeforeLast('/', missingDelimiterValue = destinationPath)
        NSFileManager.defaultManager.createDirectoryAtPath(parent, true, null, null)
        NSData.create(bytes = bytes, length = bytes.size.toULong())
            .writeToFile(destinationPath, true)
    }

    actual suspend fun zipFiles(
        entries: List<Pair<String, String>>,
        destinationPath: String,
    ) = withContext(Dispatchers.Default) {
        if (entries.isEmpty()) return@withContext
        val zipEntries = entries.mapNotNull { (entryName, sourcePath) ->
            if (!NSFileManager.defaultManager.fileExistsAtPath(sourcePath)) return@mapNotNull null
            ZipFileEntry(entryName, readBytes(sourcePath))
        }
        val bytes = buildStoreZipArchive(zipEntries)
        val parent = destinationPath.substringBeforeLast('/', missingDelimiterValue = destinationPath)
        NSFileManager.defaultManager.createDirectoryAtPath(parent, true, null, null)
        NSData.create(bytes = bytes, length = bytes.size.toULong())
            .writeToFile(destinationPath, true)
    }

    @OptIn(ExperimentalForeignApi::class)
    private fun gunzipToByteArray(path: String, onProgress: (Float) -> Unit): ByteArray {
        if (!NSFileManager.defaultManager.fileExistsAtPath(path)) {
            onProgress(1f)
            return ByteArray(0)
        }
        val raw = NSData.dataWithContentsOfFile(path) ?: run {
            onProgress(1f)
            return ByteArray(0)
        }
        val compressed = raw.toByteArray()
        if (compressed.size < 18) {
            onProgress(1f)
            return ByteArray(0)
        }
        val deflated = compressed.copyOfRange(10, compressed.size - 8)
        val inflated = inflateGzipPayload(deflated)
        onProgress(1f)
        return inflated
    }

    @OptIn(ExperimentalForeignApi::class)
    private fun inflateGzipPayload(deflated: ByteArray): ByteArray = memScoped {
        if (deflated.isEmpty()) return@memScoped ByteArray(0)

        var capacity = (deflated.size * 4).coerceAtLeast(256)
        while (capacity <= deflated.size * 32) {
            val output = allocArray<UByteVar>(capacity)
            val destLength = alloc<platform.zlib.uLongVar>()
            destLength.value = capacity.convert<platform.zlib.uLong>()
            val source = deflated.toUByteArray().toCValues()
            val status = platform.zlib.uncompress(
                output,
                destLength.ptr,
                source.ptr.reinterpret(),
                deflated.size.convert(),
            )
            if (status == 0) {
                val size = destLength.value.toInt()
                return@memScoped ByteArray(size) { index -> output[index].toByte() }
            }
            capacity *= 2
        }
        ByteArray(0)
    }

    @OptIn(ExperimentalForeignApi::class)
    private fun NSData.toByteArray(): ByteArray {
        val length = this.length.toInt()
        if (length == 0) return ByteArray(0)
        val bytes = ByteArray(length)
        bytes.usePinned { pinned ->
            memcpy(pinned.addressOf(0), this.bytes, this.length)
        }
        return bytes
    }

    private fun ByteArray.toUByteArray(): UByteArray = UByteArray(size) { this[it].toUByte() }
}
