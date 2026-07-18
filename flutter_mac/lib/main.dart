import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'app.dart';
import 'core/providers.dart';
import 'db/message_database.dart';
import 'platform/window_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // Needs web/sqflite_sw.js + web/sqlite3.wasm
    // (dart run sqflite_common_ffi_web:setup).
    databaseFactory = databaseFactoryFfiWeb;
  } else {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    await bootstrapDesktopWindow();
  }

  final prefs = await SharedPreferences.getInstance();
  MessageDatabase db;
  try {
    db = await MessageDatabase.open();
  } catch (e, st) {
    debugPrint('MessageDatabase.open failed: $e\n$st');
    // Last resort so Welcome/Auth still render if the web worker is missing.
    db = await MessageDatabase.openInMemory();
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        messageDbProvider.overrideWithValue(db),
        secureStorageProvider.overrideWithValue(
          const FlutterSecureStorage(),
        ),
      ],
      child: const FromChatApp(),
    ),
  );
}
