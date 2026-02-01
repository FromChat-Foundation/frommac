package ru.fromchat.crypto.dm

import com.pr0gramm3r101.utils.crypto.Base64
import com.pr0gramm3r101.utils.crypto.Hmac
import com.pr0gramm3r101.utils.crypto.PasswordHash
import kotlinx.cinterop.ExperimentalForeignApi
import kotlinx.cinterop.alloc
import kotlinx.cinterop.allocArray
import kotlinx.cinterop.addressOf
import kotlinx.cinterop.memScoped
import kotlinx.cinterop.ptr
import kotlinx.cinterop.usePinned
import kotlinx.cinterop.value
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import platform.CoreCrypto.CCCryptorCreateWithMode
import platform.CoreCrypto.CCCryptorRelease
import platform.CoreCrypto.CCCryptorUpdate
import platform.CoreCrypto.CCCryptorFinal
import platform.CoreCrypto.kCCAlgorithmAES
import platform.CoreCrypto.kCCKeySizeAES256
import platform.CoreCrypto.kCCDecrypt
import platform.CoreCrypto.kCCSuccess

// GCM mode constant (value 11) - CommonCrypto GCM support via cinterop is limited
private const val kCCModeGCM = 11u

actual object DmCrypto {
    private const val AES_KEY_SIZE = 32
    private const val GCM_IV_SIZE = 12
    private const val GCM_TAG_SIZE = 16

    @OptIn(ExperimentalForeignApi::class)
    actual suspend fun unwrapMek(wrappedMekB64: String, wrappingKey: ByteArray): ByteArray =
        withContext(Dispatchers.Default) {
            require(wrappingKey.size == AES_KEY_SIZE) { "Wrapping key must be 32 bytes" }
            
            val wrapped = Base64.decode(wrappedMekB64)
            require(wrapped.size >= GCM_IV_SIZE + GCM_TAG_SIZE) { "Wrapped MEK too short" }
            
            // Extract IV and ciphertext+tag
            val iv = wrapped.sliceArray(0 until GCM_IV_SIZE)
            val ciphertext = wrapped.sliceArray(GCM_IV_SIZE until wrapped.size)
            
            // Decrypt using AES-GCM
            aesGcmDecrypt(wrappingKey, iv, ciphertext)
        }

    @OptIn(ExperimentalForeignApi::class)
    actual suspend fun decryptEnvelope(
        ivB64: String,
        ciphertextB64: String,
        mek: ByteArray
    ): ByteArray = withContext(Dispatchers.Default) {
        require(mek.size == AES_KEY_SIZE) { "MEK must be 32 bytes" }
        
        val iv = Base64.decode(ivB64)
        val ciphertext = Base64.decode(ciphertextB64)
        
        require(iv.size == GCM_IV_SIZE) { "IV must be 12 bytes" }
        require(ciphertext.size >= GCM_TAG_SIZE) { "Ciphertext too short" }
        
        // Decrypt using AES-GCM
        aesGcmDecrypt(mek, iv, ciphertext)
    }

    @OptIn(ExperimentalForeignApi::class)
    private fun aesGcmDecrypt(key: ByteArray, iv: ByteArray, ciphertext: ByteArray): ByteArray {
        require(iv.size == GCM_IV_SIZE) { "IV must be 12 bytes for GCM" }
        require(key.size == AES_KEY_SIZE) { "Key must be 32 bytes (256 bits)" }
        require(ciphertext.size >= GCM_TAG_SIZE) { "Ciphertext too short" }
        
        // TODO: Implement proper AES-GCM using CommonCrypto or CryptoKit
        // See BackupCrypto.ios.kt for implementation notes.
        // For now, delegate to BackupCrypto's implementation when available.
        
        error("AES-GCM decryption not yet implemented for iOS. Use CryptoKit via Swift interop or krypto library.")
    }
}
