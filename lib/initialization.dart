import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';

Future<void> initialiseAppFunctions() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemTheme.accentColor.load();
  await initWindowManager();
  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration.speech());
}

Future<void> initWindowManager() async {
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    center: true,
    title: "Saavn Music Desktop",
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}
