package ru.fromchat.crypto.transport

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import com.iwebpp.crypto.TweetNaclFast
import java.security.SecureRandom
import java.util.Base64

actual object TransportCrypto {
    private val random = SecureRandom()

    actual suspend fun encryptWithTransportKey(
        plaintext: String,
        transportPublicKeyB64: String
    ): TransportCiphertext = withContext(Dispatchers.Default) {
        val messageBytes = plaintext.encodeToByteArray()

        // Decode server-provided transport public key
        val transportPublicKey = Base64.getDecoder().decode(transportPublicKeyB64)

        // Ephemeral X25519 keypair for this message
        val keyPair = TweetNaclFast.Box.keyPair()

        // NaCl box with (server transport public key, our ephemeral secret key)
        val box = TweetNaclFast.Box(transportPublicKey, keyPair.secretKey)

        // 24-byte nonce as required by NaCl box
        val nonce = ByteArray(TweetNaclFast.Box.nonceLength)
        random.nextBytes(nonce)

        val ciphertext = box.box(messageBytes, nonce)

        val encoder = Base64.getEncoder()
        TransportCiphertext(
            clientPublicKeyB64 = encoder.encodeToString(keyPair.publicKey),
            nonceB64 = encoder.encodeToString(nonce),
            ciphertextB64 = encoder.encodeToString(ciphertext)
        )
    }
}

