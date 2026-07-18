import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../core/server_config.dart';
import '../models/models.dart';

typedef OnUnauthorized = void Function();
typedef OnInstanceId = void Function(String instanceId);

class ApiClient {
  ApiClient({
    required ServerConfigData config,
    this.onUnauthorized,
    this.onInstanceId,
  }) : _config = config {
    _dio = Dio(
      BaseOptions(
        baseUrl: config.apiBaseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 60),
        headers: {'Accept': 'application/json'},
      ),
    );
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          final id = response.headers.value('x-fromchat-instance-id');
          if (id != null && id.isNotEmpty) onInstanceId?.call(id);
          handler.next(response);
        },
        onError: (error, handler) {
          final status = error.response?.statusCode;
          final path = error.requestOptions.path;
          if (status == 401 &&
              !path.contains('/login') &&
              !path.contains('/register')) {
            onUnauthorized?.call();
          }
          handler.next(error);
        },
      ),
    );
  }

  late final Dio _dio;
  ServerConfigData _config;
  String? _token;
  OnUnauthorized? onUnauthorized;
  OnInstanceId? onInstanceId;

  void attachSessionHooks({
    OnUnauthorized? onUnauthorized,
    OnInstanceId? onInstanceId,
  }) {
    this.onUnauthorized = onUnauthorized;
    this.onInstanceId = onInstanceId;
  }

  String? get token => _token;
  ServerConfigData get config => _config;
  String get apiBaseUrl => _config.apiBaseUrl;

  void updateConfig(ServerConfigData config) {
    _config = config;
    _dio.options.baseUrl = config.apiBaseUrl;
  }

  void bindSession(String token) => _token = token;

  void clearSession() => _token = null;

  Future<String?> probeInstanceId() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/instance_id');
      return res.data?['instance_id'] as String? ??
          res.data?['instanceId'] as String?;
    } catch (_) {
      return null;
    }
  }

  Future<bool> checkUsername(String username) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/check_username',
      queryParameters: {'username': username},
    );
    return res.data?['exists'] as bool? ?? false;
  }

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/login',
      data: {'username': username, 'password': password},
    );
    return LoginResponse.fromJson(res.data!);
  }

  Future<LoginResponse> register({
    required String username,
    required String displayName,
    required String password,
    required String confirmPassword,
    String? bio,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/register',
      data: {
        'username': username,
        'display_name': displayName,
        'password': password,
        'confirm_password': confirmPassword,
        if (bio != null) 'bio': bio,
      },
    );
    return LoginResponse.fromJson(res.data!);
  }

  Future<Map<String, dynamic>> checkAuth() async {
    final res = await _dio.get<Map<String, dynamic>>('/check_auth');
    return res.data ?? {};
  }

  Future<void> logout() async {
    try {
      await _dio.get('/logout');
    } catch (_) {}
  }

  Future<void> uploadPublicKey(String publicKeyB64) async {
    await _dio.post(
      '/crypto/public-key',
      data: {'publicKey': publicKeyB64},
    );
  }

  Future<String?> fetchPublicKeyOf(int userId) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/crypto/public-key/of/$userId',
    );
    return res.data?['publicKey'] as String?;
  }

  Future<Map<String, dynamic>> transportPublicKey() async {
    final res =
        await _dio.get<Map<String, dynamic>>('/dm/key/transport/public');
    return res.data ?? {};
  }

  Future<List<DmConversation>> dmConversations() async {
    final res = await _dio.get<Map<String, dynamic>>('/dm/conversations');
    final list = res.data?['conversations'] as List? ?? [];
    return list
        .cast<Map<String, dynamic>>()
        .map(DmConversation.fromJson)
        .toList();
  }

  Future<List<ChatMessage>> getPublicMessages({
    int limit = 50,
    int? beforeId,
    int? currentUserId,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/get_messages',
      queryParameters: {
        'limit': limit,
        if (beforeId != null) 'before_id': beforeId,
      },
    );
    final list = res.data?['messages'] as List? ?? [];
    return list
        .cast<Map<String, dynamic>>()
        .map((e) => ChatMessage.fromPublicJson(e, currentUserId: currentUserId))
        .toList();
  }

  Future<List<DmEnvelope>> dmHistory(
    int otherUserId, {
    int limit = 50,
    int? beforeId,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/dm/history/$otherUserId',
      queryParameters: {
        'limit': limit,
        if (beforeId != null) 'before_id': beforeId,
      },
    );
    final list = res.data?['messages'] as List? ?? [];
    return list.cast<Map<String, dynamic>>().map(DmEnvelope.fromJson).toList();
  }

  Future<Map<String, dynamic>> sendDm(Map<String, dynamic> body) async {
    final res = await _dio.post<Map<String, dynamic>>('/dm/send', data: body);
    return res.data ?? {};
  }

  Future<void> markDmRead(int otherUserId, {int? upToEnvelopeId}) async {
    await _dio.post(
      '/dm/conversations/$otherUserId/read',
      data: {
        if (upToEnvelopeId != null) 'upToEnvelopeId': upToEnvelopeId,
      },
    );
  }

  Future<void> markPublicRead(List<int> messageIds) async {
    await _dio.post('/messages/read', data: {'messageIds': messageIds});
  }

  Future<Map<String, dynamic>> sendPublicMessage({
    required String content,
    String? clientMessageId,
    int? replyToId,
    List<MultipartFile>? files,
  }) async {
    final payload = jsonEncode({
      'content': content,
      if (clientMessageId != null) 'client_message_id': clientMessageId,
      if (replyToId != null) 'reply_to_id': replyToId,
    });
    if (files == null || files.isEmpty) {
      final res = await _dio.post<Map<String, dynamic>>(
        '/send_message',
        data: FormData.fromMap({'payload': payload}),
      );
      return res.data ?? {};
    }
    final map = <String, dynamic>{'payload': payload};
    for (var i = 0; i < files.length; i++) {
      map['files'] = files; // Dio FormData supports list
    }
    final form = FormData.fromMap({
      'payload': payload,
      'files': files,
    });
    final res = await _dio.post<Map<String, dynamic>>(
      '/send_message',
      data: form,
    );
    return res.data ?? {};
  }

  Future<User> getUser(int userId) async {
    final res = await _dio.get<Map<String, dynamic>>('/users/$userId');
    return User.fromJson(res.data!);
  }

  Future<User> getUserByUsername(String username) async {
    final res = await _dio.get<Map<String, dynamic>>('/users/by/$username');
    return User.fromJson(res.data!);
  }

  Future<User> updateProfile(Map<String, dynamic> body) async {
    final res = await _dio.patch<Map<String, dynamic>>('/profile', data: body);
    return User.fromJson(res.data?['user'] as Map<String, dynamic>? ?? res.data!);
  }

  Future<List<DeviceSessionInfo>> devices() async {
    final res = await _dio.get('/devices');
    final data = res.data;
    final list = data is List
        ? data
        : (data is Map ? (data['devices'] as List? ?? data['sessions'] as List? ?? []) : []);
    return list
        .cast<Map<String, dynamic>>()
        .map(DeviceSessionInfo.fromJson)
        .toList();
  }

  Future<void> revokeDevice(String id) async {
    await _dio.delete('/devices/$id');
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _dio.post(
      '/change_password',
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
      },
    );
  }

  Future<void> deleteAccount({required String password}) async {
    await _dio.post('/delete_account', data: {'password': password});
  }

  Future<Map<String, dynamic>> liveKitToken({
    required int peerUserId,
    String? roomName,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/livekit/token',
      data: {
        'peer_user_id': peerUserId,
        if (roomName != null) 'room_name': roomName,
      },
    );
    return res.data ?? {};
  }

  Future<Map<String, dynamic>> publicChatProfile() async {
    final res = await _dio.get<Map<String, dynamic>>('/public-chat/profile');
    return res.data ?? {};
  }

  Future<Map<String, dynamic>> startDmUpload({
    required String filename,
    required int size,
    required String contentType,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/dm/upload/start',
      data: {
        'filename': filename,
        'size': size,
        'content_type': contentType,
      },
    );
    return res.data ?? {};
  }

  Future<void> uploadDmChunk({
    required String uploadId,
    required int index,
    required Uint8List bytes,
  }) async {
    await _dio.post(
      '/dm/upload/$uploadId/chunk',
      data: FormData.fromMap({
        'index': index,
        'chunk': MultipartFile.fromBytes(
          bytes,
          filename: 'chunk_$index',
          contentType: MediaType('application', 'octet-stream'),
        ),
      }),
    );
  }

  Future<Map<String, dynamic>> completeDmUpload(String uploadId) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/dm/upload/$uploadId/complete',
    );
    return res.data ?? {};
  }

  Future<List<int>> downloadBytes(String path) async {
    final res = await _dio.get<List<int>>(
      path.startsWith('http') ? path : path,
      options: Options(responseType: ResponseType.bytes),
    );
    return res.data ?? [];
  }
}
