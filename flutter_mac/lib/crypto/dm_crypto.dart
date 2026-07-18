import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import 'password_hash.dart';

class DmEnvelopeCrypto {
  static const corruptedPlaceholder =
      'Сообщение повреждено и не может быть отображено.';

  /// AES-GCM unwrap of wrapped MEK (12-byte IV prefix in blob, as on Android).
  static Future<Uint8List> unwrapMek({
    required String wrappedMekB64,
    required Uint8List wrappingKey,
  }) async {
    final blob = base64Decode(wrappedMekB64);
    if (blob.length < 12 + 16) {
      throw StateError('wrapped MEK too short');
    }
    final iv = blob.sublist(0, 12);
    final cipherAndTag = blob.sublist(12);
    final algorithm = AesGcm.with256bits();
    final secretKey = SecretKey(wrappingKey);
    final clear = await algorithm.decrypt(
      SecretBox(
        cipherAndTag.sublist(0, cipherAndTag.length - 16),
        nonce: iv,
        mac: Mac(cipherAndTag.sublist(cipherAndTag.length - 16)),
      ),
      secretKey: secretKey,
    );
    return Uint8List.fromList(clear);
  }

  static Future<Uint8List> decryptBody({
    required String ivB64,
    required String ciphertextB64,
    required Uint8List mek,
  }) async {
    final iv = base64Decode(ivB64);
    final blob = base64Decode(ciphertextB64);
    final algorithm = AesGcm.with256bits();
    final secretKey = SecretKey(mek);
    final clear = await algorithm.decrypt(
      SecretBox(
        blob.sublist(0, blob.length - 16),
        nonce: iv,
        mac: Mac(blob.sublist(blob.length - 16)),
      ),
      secretKey: secretKey,
    );
    return Uint8List.fromList(clear);
  }

  static Future<Uint8List> deriveWrapKey({
    required Uint8List publicKey,
    required bool isRecipient,
  }) async {
    final context = isRecipient ? 'recipient_wrap_key' : 'sender_wrap_key';
    return PasswordHash.hkdfExtractAndExpand(
      ikm: publicKey,
      salt: Uint8List(16),
      info: Uint8List.fromList(utf8.encode(context)),
      length: 32,
    );
  }

  static Future<String> decryptEnvelope({
    required String ivB64,
    required String ciphertextB64,
    required String wrappedMekB64,
    required Uint8List identityPublicKey,
    required bool isRecipient,
  }) async {
    final wrapKey = await deriveWrapKey(
      publicKey: identityPublicKey,
      isRecipient: isRecipient,
    );
    final mek = await unwrapMek(
      wrappedMekB64: wrappedMekB64,
      wrappingKey: wrapKey,
    );
    final plain = await decryptBody(
      ivB64: ivB64,
      ciphertextB64: ciphertextB64,
      mek: mek,
    );
    return utf8.decode(plain);
  }

  static Future<Uint8List> encryptAesGcm({
    required Uint8List plaintext,
    required Uint8List key,
    required Uint8List iv,
  }) async {
    final algorithm = AesGcm.with256bits();
    final secretBox = await algorithm.encrypt(
      plaintext,
      secretKey: SecretKey(key),
      nonce: iv,
    );
    return Uint8List.fromList([
      ...secretBox.cipherText,
      ...secretBox.mac.bytes,
    ]);
  }
}
