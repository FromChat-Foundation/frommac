package ru.fromchat.crypto.backup

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlin.random.Random

actual object BackupCrypto {
    actual suspend fun encryptBackupWithPassword(
        password: String,
        bundle: PrivateKeyBundle
    ): EncryptedBackupBlob = withContext(Dispatchers.Default) {
        // iOS backup encryption is not implemented yet; fail fast if called.
        error("Backup encryption is not yet implemented on iOS.")
    }

    actual suspend fun decryptBackupWithPassword(
        password: String,
        blob: EncryptedBackupBlob
    ): PrivateKeyBundle = withContext(Dispatchers.Default) {
        // iOS backup decryption is not implemented yet; fail fast if called.
        error("Backup decryption is not yet implemented on iOS.")
    }

    actual fun randomBytes(length: Int): ByteArray {
        val bytes = ByteArray(length)
        Random.Default.nextBytes(bytes)
        return bytes
    }
}
