package ru.fromchat.crypto

import com.pr0gramm3r101.utils.crypto.PasswordHash
import ru.fromchat.api.DmEnvelope
import ru.fromchat.crypto.dm.DmCrypto

/**
 * Unwrap a MEK (Message Encryption Key) using the appropriate wrapping key
 * Matches Web implementation: derive wrapping key from our public key using HKDF
 */
suspend fun unwrapMek(wrappedMekB64: String, envelope: DmEnvelope, currentUserId: Int?): ByteArray {
    val keys = IdentityKeyManager.getCurrentKeys()
        ?: IdentityKeyManager.restoreFromLocal()
        ?: throw IllegalStateException("Identity keys not initialized. Call ensureKeysOnLogin first.")
    
    // Determine context based on whether we're sender or recipient
    val isRecipient = envelope.recipientId == currentUserId
    val context = if (isRecipient) "recipient_wrap_key" else "sender_wrap_key"
    
    // Derive wrapping key from our public key using HKDF
    // Salt: 16 zero bytes, Info: context string UTF-8 bytes
    val salt = ByteArray(16) // zeros
    val info = context.encodeToByteArray()
    val wrappingKeyRaw = PasswordHash.hkdfExtractAndExpand(
        inputKeyMaterial = keys.publicKey,
        salt = salt,
        info = info,
        length = 32
    )
    
    // Unwrap the MEK using platform-specific AES-GCM implementation
    return DmCrypto.unwrapMek(wrappedMekB64, wrappingKeyRaw)
}

/**
 * Decrypt a DM envelope to plaintext
 */
suspend fun decryptEnvelope(envelope: DmEnvelope, currentUserId: Int?): String {
    val wrappedMekB64 = envelope.wrappedMekB64
        ?: throw IllegalArgumentException("No wrapped MEK available for decryption")
    
    // Unwrap the MEK
    val mek = unwrapMek(wrappedMekB64, envelope, currentUserId)
    
    // Decrypt the message using the unwrapped MEK
    val plaintext = DmCrypto.decryptEnvelope(envelope.ivB64, envelope.ciphertextB64, mek)
    return plaintext.decodeToString()
}
