import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

Future<void> bootstrapDesktopWindow() async {
  await windowManager.ensureInitialized();
  const windowOptions = WindowOptions(
    size: Size(1280, 800),
    minimumSize: Size(960, 640),
    center: true,
    title: 'FromChat',
    titleBarStyle: TitleBarStyle.normal,
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}
