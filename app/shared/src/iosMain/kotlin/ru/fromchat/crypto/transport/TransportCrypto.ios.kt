package ru.fromchat.crypto.transport

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

actual object TransportCrypto {
    actual suspend fun encryptWithTransportKey(
        plaintext: String,
        transportPublicKeyB64: String
    ): TransportCiphertext = withContext(Dispatchers.Default) {
        error("TransportCrypto.encryptWithTransportKey is not yet implemented on iOS.")
    }
}

