package ru.fromchat.crypto.transport

/**
 * Result of client-side transport encryption for DMs.
 *
 * Matches the Web client's encryptWithTransportKey output:
 * - client_public_key_b64: ephemeral X25519 public key, base64
 * - nonce_b64: 24-byte nonce, base64
 * - ciphertext_b64: transport-encrypted ciphertext, base64
 */
data class TransportCiphertext(
    val clientPublicKeyB64: String,
    val nonceB64: String,
    val ciphertextB64: String
)

/**
 * Platform-specific NaCl box-compatible transport crypto.
 *
 * Android provides a real implementation; iOS currently provides a stub.
 */
expect object TransportCrypto {
    suspend fun encryptWithTransportKey(
        plaintext: String,
        transportPublicKeyB64: String
    ): TransportCiphertext
}

