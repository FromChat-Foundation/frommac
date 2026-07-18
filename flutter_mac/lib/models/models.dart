class User {
  const User({
    required this.id,
    required this.createdAt,
    required this.online,
    required this.username,
    this.lastSeen,
    this.displayName,
    this.admin,
    this.bio,
    this.profilePicture,
    this.verified,
    this.verificationStatus,
    this.suspended,
    this.suspensionReason,
    this.deleted,
  });

  final int id;
  final String createdAt;
  final String? lastSeen;
  final bool online;
  final String username;
  final String? displayName;
  final bool? admin;
  final String? bio;
  final String? profilePicture;
  final bool? verified;
  final String? verificationStatus;
  final bool? suspended;
  final String? suspensionReason;
  final bool? deleted;

  String get displayLabel =>
      (displayName != null && displayName!.trim().isNotEmpty)
          ? displayName!
          : username;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int,
        createdAt: json['created_at'] as String? ?? '',
        lastSeen: json['last_seen'] as String?,
        online: json['online'] as bool? ?? false,
        username: json['username'] as String? ?? '',
        displayName: json['display_name'] as String?,
        admin: json['admin'] as bool?,
        bio: json['bio'] as String?,
        profilePicture: json['profile_picture'] as String?,
        verified: json['verified'] as bool?,
        verificationStatus: json['verification_status'] as String?,
        suspended: json['suspended'] as bool?,
        suspensionReason: json['suspension_reason'] as String?,
        deleted: json['deleted'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': createdAt,
        'last_seen': lastSeen,
        'online': online,
        'username': username,
        'display_name': displayName,
        'admin': admin,
        'bio': bio,
        'profile_picture': profilePicture,
        'verified': verified,
        'verification_status': verificationStatus,
        'suspended': suspended,
        'suspension_reason': suspensionReason,
        'deleted': deleted,
      };
}

class LoginResponse {
  const LoginResponse({required this.user, required this.token});

  final User user;
  final String token;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        user: User.fromJson(json['user'] as Map<String, dynamic>),
        token: json['token'] as String,
      );
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.userId,
    required this.content,
    required this.timestamp,
    required this.isRead,
    required this.isEdited,
    required this.username,
    this.profilePicture,
    this.clientMessageId,
    this.replyToId,
    this.isContentCorrupted = false,
    this.isMine = false,
    this.files,
    this.sendStatus,
  });

  final int id;
  final int userId;
  final String content;
  final String timestamp;
  final bool isRead;
  final bool isEdited;
  final String username;
  final String? profilePicture;
  final String? clientMessageId;
  final int? replyToId;
  final bool isContentCorrupted;
  final bool isMine;
  final List<Map<String, dynamic>>? files;
  final String? sendStatus;

  factory ChatMessage.fromPublicJson(
    Map<String, dynamic> json, {
    int? currentUserId,
  }) {
    final userId = json['user_id'] as int? ?? 0;
    return ChatMessage(
      id: json['id'] as int? ?? 0,
      userId: userId,
      content: json['content'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      isRead: json['is_read'] as bool? ?? false,
      isEdited: json['is_edited'] as bool? ?? false,
      username: json['username'] as String? ?? '',
      profilePicture: json['profile_picture'] as String?,
      clientMessageId: json['client_message_id'] as String?,
      replyToId: (json['reply_to'] as Map?)?['id'] as int?,
      isMine: currentUserId != null && userId == currentUserId,
      files: (json['files'] as List?)?.cast<Map<String, dynamic>>(),
    );
  }
}

class DmEnvelope {
  const DmEnvelope({
    required this.id,
    required this.senderId,
    required this.recipientId,
    required this.ivB64,
    required this.ciphertextB64,
    required this.timestamp,
    this.senderUsername,
    this.wrappedMekB64,
    this.clientMessageId,
    this.replyToId,
    this.files,
  });

  final int id;
  final int senderId;
  final int recipientId;
  final String? senderUsername;
  final String ivB64;
  final String ciphertextB64;
  final String? wrappedMekB64;
  final String timestamp;
  final String? clientMessageId;
  final int? replyToId;
  final List<Map<String, dynamic>>? files;

  factory DmEnvelope.fromJson(Map<String, dynamic> json) => DmEnvelope(
        id: json['id'] as int,
        senderId: json['senderId'] as int? ?? json['sender_id'] as int? ?? 0,
        recipientId:
            json['recipientId'] as int? ?? json['recipient_id'] as int? ?? 0,
        senderUsername: json['sender_username'] as String?,
        ivB64: json['iv_b64'] as String? ?? '',
        ciphertextB64: json['ciphertext_b64'] as String? ?? '',
        wrappedMekB64: json['wrapped_mek_b64'] as String?,
        timestamp: json['timestamp'] as String? ?? '',
        clientMessageId: json['client_message_id'] as String?,
        replyToId: json['reply_to_id'] as int?,
        files: (json['files'] as List?)?.cast<Map<String, dynamic>>(),
      );
}

class DmConversationUser {
  const DmConversationUser({
    required this.id,
    required this.username,
    this.displayName,
    this.profilePicture,
    this.online = false,
  });

  final int id;
  final String username;
  final String? displayName;
  final String? profilePicture;
  final bool online;

  String get displayLabel =>
      (displayName != null && displayName!.trim().isNotEmpty)
          ? displayName!
          : username;

  factory DmConversationUser.fromJson(Map<String, dynamic> json) =>
      DmConversationUser(
        id: json['id'] as int,
        username: json['username'] as String? ?? '',
        displayName: json['display_name'] as String?,
        profilePicture: json['profile_picture'] as String?,
        online: json['online'] as bool? ?? false,
      );
}

class DmConversation {
  const DmConversation({
    required this.user,
    this.lastMessage,
    this.unreadCount = 0,
  });

  final DmConversationUser user;
  final DmEnvelope? lastMessage;
  final int unreadCount;

  factory DmConversation.fromJson(Map<String, dynamic> json) => DmConversation(
        user: DmConversationUser.fromJson(
          json['user'] as Map<String, dynamic>,
        ),
        lastMessage: json['lastMessage'] != null
            ? DmEnvelope.fromJson(json['lastMessage'] as Map<String, dynamic>)
            : (json['last_message'] != null
                ? DmEnvelope.fromJson(
                    json['last_message'] as Map<String, dynamic>,
                  )
                : null),
        unreadCount: json['unreadCount'] as int? ??
            json['unread_count'] as int? ??
            0,
      );
}

class DeviceSessionInfo {
  const DeviceSessionInfo({
    required this.id,
    required this.deviceName,
    required this.lastActive,
    this.current = false,
  });

  final String id;
  final String deviceName;
  final String lastActive;
  final bool current;

  factory DeviceSessionInfo.fromJson(Map<String, dynamic> json) =>
      DeviceSessionInfo(
        id: '${json['id'] ?? json['session_id'] ?? ''}',
        deviceName:
            json['device_name'] as String? ?? json['name'] as String? ?? 'Device',
        lastActive: json['last_active'] as String? ??
            json['last_seen'] as String? ??
            '',
        current: json['current'] as bool? ?? json['is_current'] as bool? ?? false,
      );
}

sealed class SelectedChat {
  const SelectedChat();
}

class PublicChatSelection extends SelectedChat {
  const PublicChatSelection();
}

class DmChatSelection extends SelectedChat {
  const DmChatSelection(this.otherUserId, {this.displayName, this.username});

  final int otherUserId;
  final String? displayName;
  final String? username;
}
