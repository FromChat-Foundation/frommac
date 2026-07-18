import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// HKDF-SHA256 auth secret — mirrors Kotlin [deriveAuthSecret].
class PasswordHash {
  static Uint8List hkdfExtractAndExpand({
    required Uint8List ikm,
    required Uint8List salt,
    required Uint8List info,
    int length = 32,
  }) {
    final prk = Hmac(sha256, salt).convert(ikm).bytes;
    const hashLen = 32;
    final n = (length + hashLen - 1) ~/ hashLen;
    final okm = Uint8List(length);
    var offset = 0;
    var t = <int>[];
    for (var i = 0; i < n; i++) {
      final tInput = [...t, ...info, i + 1];
      t = Hmac(sha256, prk).convert(tInput).bytes;
      final copyLen = (t.length < length - offset) ? t.length : length - offset;
      okm.setRange(offset, offset + copyLen, t);
      offset += copyLen;
    }
    return okm;
  }

  static String deriveAuthSecret(String username, String password) {
    final salt = utf8.encode('fromchat.user:$username');
    final info = utf8.encode('auth-secret');
    final passwordBytes = utf8.encode(password);
    final derived = hkdfExtractAndExpand(
      ikm: Uint8List.fromList(passwordBytes),
      salt: Uint8List.fromList(salt),
      info: Uint8List.fromList(info),
      length: 32,
    );
    return base64Encode(derived);
  }
}
