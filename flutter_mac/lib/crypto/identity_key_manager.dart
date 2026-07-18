import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../api/api_client.dart';

class IdentityKeys {
  const IdentityKeys({required this.publicKey, required this.privateKey});

  final Uint8List publicKey;
  final Uint8List privateKey;

  String get publicKeyB64 => base64Encode(publicKey);
  String get privateKeyB64 => base64Encode(privateKey);
}

/// Local identity keypair (32-byte keys), synced with /crypto/public-key.
class IdentityKeyManager {
  IdentityKeyManager(
    this._secure, {
    required ApiClient Function() apiGetter,
  }) : _apiGetter = apiGetter;

  final FlutterSecureStorage _secure;
  final ApiClient Function() _apiGetter;

  ApiClient get _api => _apiGetter();

  static const _pubKey = 'identity_public_key_b64';
  static const _privKey = 'identity_private_key_b64';

  IdentityKeys? _current;

  IdentityKeys? get current => _current;

  Future<IdentityKeys?> restoreFromLocal() async {
    final pub = await _secure.read(key: _pubKey);
    final priv = await _secure.read(key: _privKey);
    if (pub == null || priv == null) return null;
    _current = IdentityKeys(
      publicKey: base64Decode(pub),
      privateKey: base64Decode(priv),
    );
    return _current;
  }

  Future<void> _persist(IdentityKeys keys) async {
    await _secure.write(key: _pubKey, value: keys.publicKeyB64);
    await _secure.write(key: _privKey, value: keys.privateKeyB64);
    _current = keys;
  }

  static IdentityKeys generate() {
    final rnd = Random.secure();
    Uint8List bytes(int n) {
      final out = Uint8List(n);
      for (var i = 0; i < n; i++) {
        out[i] = rnd.nextInt(256);
      }
      return out;
    }

    return IdentityKeys(publicKey: bytes(32), privateKey: bytes(32));
  }

  Future<IdentityKeys> ensureKeysOnLogin() async {
    final local = await restoreFromLocal();
    if (local != null) {
      try {
        await _api.uploadPublicKey(local.publicKeyB64);
      } catch (_) {
        // best-effort sync
      }
      return local;
    }
    final keys = generate();
    await _api.uploadPublicKey(keys.publicKeyB64);
    await _persist(keys);
    return keys;
  }

  Future<void> clear() async {
    _current = null;
    await _secure.delete(key: _pubKey);
    await _secure.delete(key: _privKey);
  }
}
