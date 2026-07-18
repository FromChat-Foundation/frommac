import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:pinenacl/x25519.dart';

class TransportCiphertext {
  const TransportCiphertext({
    required this.clientPublicKeyB64,
    required this.nonceB64,
    required this.ciphertextB64,
  });

  final String clientPublicKeyB64;
  final String nonceB64;
  final String ciphertextB64;
}

/// NaCl box transport encryption — mirrors TweetNaclFast.Box on Android.
class TransportCrypto {
  static final _random = Random.secure();

  static Uint8List _randomBytes(int n) {
    final out = Uint8List(n);
    for (var i = 0; i < n; i++) {
      out[i] = _random.nextInt(256);
    }
    return out;
  }

  static (TransportCiphertext, Uint8List) encryptWithTransportKeyWithEphemeralSecret({
    required String plaintext,
    required String transportPublicKeyB64,
  }) {
    final transportPublicKey = base64Decode(transportPublicKeyB64);
    final keyPair = PrivateKey.generate();
    final box = Box(
      myPrivateKey: keyPair,
      theirPublicKey: PublicKey(transportPublicKey),
    );
    final nonce = _randomBytes(24);
    final encrypted = box.encrypt(
      Uint8List.fromList(utf8.encode(plaintext)),
      nonce: nonce,
    );
    // PineNaCl encrypt may prefix nonce; TweetNaCl box() returns ciphertext only.
    final cipherOnly = Uint8List.fromList(encrypted.cipherText);
    final result = TransportCiphertext(
      clientPublicKeyB64: base64Encode(Uint8List.fromList(keyPair.publicKey)),
      nonceB64: base64Encode(nonce),
      ciphertextB64: base64Encode(cipherOnly),
    );
    return (result, Uint8List.fromList(keyPair));
  }

  static TransportCiphertext encryptWithTransportKey({
    required String plaintext,
    required String transportPublicKeyB64,
  }) {
    final (cipher, secret) = encryptWithTransportKeyWithEphemeralSecret(
      plaintext: plaintext,
      transportPublicKeyB64: transportPublicKeyB64,
    );
    secret.fillRange(0, secret.length, 0);
    return cipher;
  }

  static Uint8List encryptFileForTransport({
    required Uint8List fileBytes,
    required String transportPublicKeyB64,
    required Uint8List ephemeralSecretKey,
  }) {
    final transportPublicKey = base64Decode(transportPublicKeyB64);
    final box = Box(
      myPrivateKey: PrivateKey(ephemeralSecretKey),
      theirPublicKey: PublicKey(transportPublicKey),
    );
    final nonce = _randomBytes(24);
    final encrypted = box.encrypt(fileBytes, nonce: nonce);
    final cipherOnly = Uint8List.fromList(encrypted.cipherText);
    final out = Uint8List(nonce.length + cipherOnly.length);
    out.setRange(0, nonce.length, nonce);
    out.setRange(nonce.length, out.length, cipherOnly);
    return out;
  }
}
