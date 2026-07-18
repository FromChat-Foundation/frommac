import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';
import 'server_config.dart';

class AppSettings {
  AppSettings(this._prefs, this._secure);

  final SharedPreferences _prefs;
  final FlutterSecureStorage _secure;

  static const _serverIp = 'server_ip';
  static const _apiPort = 'api_port';
  static const _callsPort = 'calls_port';
  static const _https = 'https_enabled';
  static const _callsEnabled = 'calls_enabled';
  static const _theme = 'theme';
  static const _authToken = 'auth_token';
  static const _userInfo = 'user_info';
  static const _currentUserId = 'current_user_id';
  static const _instanceId = 'last_server_instance_id';
  static const _updatesSeqPrefix = 'updates_last_seq_user_';

  ServerConfigData loadServerConfig() {
    // DEV: --dart-define=FROMCHAT_WEB_PROXY=... always wins over saved prefs.
    const proxy = String.fromEnvironment('FROMCHAT_WEB_PROXY');
    if (proxy.isNotEmpty) {
      return ServerConfigData.effectiveDefaults;
    }
    final ip = _prefs.getString(_serverIp);
    if (ip == null || ip.isEmpty) return ServerConfigData.defaults;
    return ServerConfigData(
      serverIp: ip,
      apiPort: _prefs.getInt(_apiPort) ?? 443,
      callsPort: _prefs.getInt(_callsPort) ?? _prefs.getInt(_apiPort) ?? 443,
      httpsEnabled: _prefs.getBool(_https) ?? true,
      callsEnabled: _prefs.getBool(_callsEnabled) ?? true,
    );
  }

  Future<void> saveServerConfig(ServerConfigData config) async {
    await _prefs.setString(_serverIp, config.serverIp);
    await _prefs.setInt(_apiPort, config.apiPort);
    await _prefs.setInt(_callsPort, config.callsPort);
    await _prefs.setBool(_https, config.httpsEnabled);
    await _prefs.setBool(_callsEnabled, config.callsEnabled);
  }

  AppThemeMode get themeMode {
    final i = _prefs.getInt(_theme) ?? 0;
    return AppThemeMode.values[i.clamp(0, AppThemeMode.values.length - 1)];
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    await _prefs.setInt(_theme, mode.index);
  }

  Future<String?> getAuthToken() => _secure.read(key: _authToken);

  Future<void> setAuthToken(String? token) async {
    if (token == null) {
      await _secure.delete(key: _authToken);
    } else {
      await _secure.write(key: _authToken, value: token);
    }
  }

  User? getUserInfo() {
    final raw = _prefs.getString(_userInfo);
    if (raw == null) return null;
    try {
      return User.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> setUserInfo(User? user) async {
    if (user == null) {
      await _prefs.remove(_userInfo);
      await _prefs.remove(_currentUserId);
    } else {
      await _prefs.setString(_userInfo, jsonEncode(user.toJson()));
      await _prefs.setInt(_currentUserId, user.id);
    }
  }

  int? get currentUserId => _prefs.getInt(_currentUserId);

  String? get lastInstanceId => _prefs.getString(_instanceId);

  Future<void> setLastInstanceId(String? id) async {
    if (id == null) {
      await _prefs.remove(_instanceId);
    } else {
      await _prefs.setString(_instanceId, id);
    }
  }

  int getUpdatesSeq(int userId) =>
      _prefs.getInt('$_updatesSeqPrefix$userId') ?? 0;

  Future<void> setUpdatesSeq(int userId, int seq) async {
    await _prefs.setInt('$_updatesSeqPrefix$userId', seq);
  }

  Future<void> clearSession() async {
    await setAuthToken(null);
    await setUserInfo(null);
  }
}
