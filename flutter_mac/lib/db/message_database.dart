import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// Local cache mirroring MessageDatabase.sq
class MessageDatabase {
  MessageDatabase._(this._db) : _memory = null;

  MessageDatabase._memory()
      : _db = null,
        _memory = _MemoryStore();

  final Database? _db;
  final _MemoryStore? _memory;

  static Future<MessageDatabase> open() async {
    String path;
    try {
      final dir = await getApplicationSupportDirectory();
      path = p.join(dir.path, 'fromchat_messages.db');
    } catch (_) {
      path = 'fromchat_messages.db';
    }
    final db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return MessageDatabase._(db);
  }

  /// Pure Dart fallback when the web SQLite worker is unavailable.
  static Future<MessageDatabase> openInMemory() async {
    debugPrint('Using in-memory MessageDatabase fallback');
    return MessageDatabase._memory();
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE server_binding (
  configKey TEXT NOT NULL PRIMARY KEY,
  activeInstanceId TEXT NOT NULL,
  updatedAt TEXT
);''');
    await db.execute('''
CREATE TABLE instance_registry (
  instanceId TEXT NOT NULL PRIMARY KEY,
  firstSeenAt TEXT NOT NULL,
  lastSeenAt TEXT NOT NULL
);''');
    await db.execute('''
CREATE TABLE conversation (
  instanceId TEXT NOT NULL,
  id TEXT NOT NULL,
  type TEXT NOT NULL,
  otherUserId INTEGER,
  displayName TEXT,
  lastMessageId INTEGER,
  lastMessagePreview TEXT,
  unreadCount INTEGER NOT NULL DEFAULT 0,
  updatedAt TEXT,
  archived INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (instanceId, id)
);''');
    await db.execute('''
CREATE TABLE message (
  instanceId TEXT NOT NULL,
  id INTEGER NOT NULL,
  conversationId TEXT NOT NULL,
  userId INTEGER NOT NULL,
  content TEXT NOT NULL,
  timestamp TEXT NOT NULL,
  isRead INTEGER NOT NULL,
  isEdited INTEGER NOT NULL,
  replyToId INTEGER,
  clientMessageId TEXT,
  deletedFlag INTEGER NOT NULL DEFAULT 0,
  sendStatus TEXT,
  username TEXT,
  PRIMARY KEY (instanceId, conversationId, id)
);''');
    await db.execute('''
CREATE TABLE attachment (
  instanceId TEXT NOT NULL,
  id INTEGER NOT NULL,
  messageId INTEGER NOT NULL,
  conversationId TEXT NOT NULL,
  remotePath TEXT,
  localPath TEXT,
  status TEXT NOT NULL,
  blurhash TEXT,
  aspectRatio REAL,
  size INTEGER,
  bytesTransferred INTEGER NOT NULL DEFAULT 0,
  clientMessageId TEXT,
  PRIMARY KEY (instanceId, id, messageId, conversationId)
);''');
    await db.execute('''
CREATE TABLE outbox (
  instanceId TEXT NOT NULL,
  clientMessageId TEXT NOT NULL,
  conversationId TEXT NOT NULL,
  kind TEXT NOT NULL,
  payloadJson TEXT NOT NULL,
  retryCount INTEGER NOT NULL DEFAULT 0,
  nextAttemptAt TEXT,
  bytesUploaded INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (instanceId, clientMessageId)
);''');
    await db.execute('''
CREATE TABLE profile_cache (
  instanceId TEXT NOT NULL,
  userId INTEGER NOT NULL,
  json TEXT NOT NULL,
  PRIMARY KEY (instanceId, userId)
);''');
    await db.execute('''
CREATE TABLE public_chat_profile (
  instanceId TEXT NOT NULL PRIMARY KEY,
  json TEXT NOT NULL
);''');
  }

  Future<void> upsertConversation({
    required String instanceId,
    required String id,
    required String type,
    int? otherUserId,
    String? displayName,
    int? lastMessageId,
    String? lastMessagePreview,
    int unreadCount = 0,
    String? updatedAt,
    bool archived = false,
  }) async {
    final row = {
      'instanceId': instanceId,
      'id': id,
      'type': type,
      'otherUserId': otherUserId,
      'displayName': displayName,
      'lastMessageId': lastMessageId,
      'lastMessagePreview': lastMessagePreview,
      'unreadCount': unreadCount,
      'updatedAt': updatedAt,
      'archived': archived ? 1 : 0,
    };
    final mem = _memory;
    if (mem != null) {
      mem.conversations['$instanceId|$id'] = row;
      return;
    }
    await _db!.insert(
      'conversation',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, Object?>>> listConversations(String instanceId) async {
    final mem = _memory;
    if (mem != null) {
      final list = mem.conversations.values
          .where((r) => r['instanceId'] == instanceId && r['archived'] == 0)
          .map((r) => Map<String, Object?>.from(r))
          .toList();
      list.sort((a, b) =>
          '${b['updatedAt']}'.compareTo('${a['updatedAt']}'));
      return list;
    }
    return _db!.query(
      'conversation',
      where: 'instanceId = ? AND archived = 0',
      whereArgs: [instanceId],
      orderBy: 'updatedAt DESC',
    );
  }

  Future<void> upsertMessage({
    required String instanceId,
    required int id,
    required String conversationId,
    required int userId,
    required String content,
    required String timestamp,
    required bool isRead,
    required bool isEdited,
    int? replyToId,
    String? clientMessageId,
    String? sendStatus,
    String? username,
  }) async {
    final row = {
      'instanceId': instanceId,
      'id': id,
      'conversationId': conversationId,
      'userId': userId,
      'content': content,
      'timestamp': timestamp,
      'isRead': isRead ? 1 : 0,
      'isEdited': isEdited ? 1 : 0,
      'replyToId': replyToId,
      'clientMessageId': clientMessageId,
      'deletedFlag': 0,
      'sendStatus': sendStatus,
      'username': username,
    };
    final mem = _memory;
    if (mem != null) {
      mem.messages['$instanceId|$conversationId|$id'] = row;
      return;
    }
    await _db!.insert(
      'message',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, Object?>>> messagesFor(
    String instanceId,
    String conversationId, {
    int limit = 100,
  }) async {
    final mem = _memory;
    if (mem != null) {
      final list = mem.messages.values
          .where(
            (r) =>
                r['instanceId'] == instanceId &&
                r['conversationId'] == conversationId &&
                r['deletedFlag'] == 0,
          )
          .map((r) => Map<String, Object?>.from(r))
          .toList();
      list.sort((a, b) =>
          '${a['timestamp']}'.compareTo('${b['timestamp']}'));
      if (list.length > limit) {
        return list.sublist(list.length - limit);
      }
      return list;
    }
    return _db!.query(
      'message',
      where: 'instanceId = ? AND conversationId = ? AND deletedFlag = 0',
      whereArgs: [instanceId, conversationId],
      orderBy: 'timestamp ASC',
      limit: limit,
    );
  }

  Future<void> enqueueOutbox({
    required String instanceId,
    required String clientMessageId,
    required String conversationId,
    required String kind,
    required String payloadJson,
  }) async {
    final row = {
      'instanceId': instanceId,
      'clientMessageId': clientMessageId,
      'conversationId': conversationId,
      'kind': kind,
      'payloadJson': payloadJson,
      'retryCount': 0,
      'bytesUploaded': 0,
    };
    final mem = _memory;
    if (mem != null) {
      mem.outbox['$instanceId|$clientMessageId'] = row;
      return;
    }
    await _db!.insert(
      'outbox',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, Object?>>> pendingOutbox(String instanceId) async {
    final mem = _memory;
    if (mem != null) {
      return mem.outbox.values
          .where((r) => r['instanceId'] == instanceId)
          .map((r) => Map<String, Object?>.from(r))
          .toList();
    }
    return _db!.query(
      'outbox',
      where: 'instanceId = ?',
      whereArgs: [instanceId],
      orderBy: 'clientMessageId ASC',
    );
  }

  Future<void> deleteOutbox(String instanceId, String clientMessageId) async {
    final mem = _memory;
    if (mem != null) {
      mem.outbox.remove('$instanceId|$clientMessageId');
      return;
    }
    await _db!.delete(
      'outbox',
      where: 'instanceId = ? AND clientMessageId = ?',
      whereArgs: [instanceId, clientMessageId],
    );
  }

  Future<void> setActiveInstance(String configKey, String instanceId) async {
    final mem = _memory;
    if (mem != null) {
      mem.bindings[configKey] = {
        'configKey': configKey,
        'activeInstanceId': instanceId,
        'updatedAt': DateTime.now().toIso8601String(),
      };
      return;
    }
    await _db!.insert(
      'server_binding',
      {
        'configKey': configKey,
        'activeInstanceId': instanceId,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> activeInstance(String configKey) async {
    final mem = _memory;
    if (mem != null) {
      return mem.bindings[configKey]?['activeInstanceId'] as String?;
    }
    final rows = await _db!.query(
      'server_binding',
      where: 'configKey = ?',
      whereArgs: [configKey],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['activeInstanceId'] as String?;
  }

  Future<void> close() async {
    await _db?.close();
  }
}

class _MemoryStore {
  final conversations = <String, Map<String, Object?>>{};
  final messages = <String, Map<String, Object?>>{};
  final outbox = <String, Map<String, Object?>>{};
  final bindings = <String, Map<String, Object?>>{};
}
