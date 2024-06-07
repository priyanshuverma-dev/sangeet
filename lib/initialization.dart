import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:saavn/core/constants.dart';
import 'package:system_theme/system_theme.dart';
import 'package:tray_manager/tray_manager.dart';
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
  await Window.initialize();

  await Window.setEffect(
    effect: WindowEffect.acrylic,
    color: const Color(0xCC222222),
  );

  WindowOptions windowOptions = const WindowOptions(
    center: true,
    title: "Saavn Music Desktop",
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setPreventClose(true);

    await trayManager.setIcon('assets/app_icon.ico');

    Menu menu = Menu(
      items: [
        MenuItem(
          key: SystemTrayActions.hideShow,
          label: 'Hide/Show Window',
        ),
        MenuItem.separator(),
        MenuItem(
          key: SystemTrayActions.prevTrack,
          label: 'Previous Track',
        ),
        MenuItem(
          key: SystemTrayActions.playPauseMusic,
          label: 'Play/Pause Music',
        ),
        MenuItem(
          key: SystemTrayActions.nextTrack,
          label: 'Next Track',
        ),
        MenuItem(
          key: SystemTrayActions.openPlaylist,
          label: 'Open Playlist',
        ),
        MenuItem.separator(),
        MenuItem(
          key: SystemTrayActions.exit,
          label: 'Exit',
        ),
      ],
    );
    await trayManager.setContextMenu(menu);
  });
}
