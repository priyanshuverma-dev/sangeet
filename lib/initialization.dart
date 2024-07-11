import 'package:audio_session/audio_session.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sangeet/core/constants.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

Future<void> initialiseAppFunctions() async {
  await initWindowManager();
  final tempDir = await getTemporaryDirectory();
  await FastCachedImageConfig.init(
    subDir: "${tempDir.path}/sangeet-cache",
    clearCacheAfter: const Duration(days: 15),
  );
  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration.speech());
  await session.setActive(false);
}

Future<void> initWindowManager() async {
  await windowManager.ensureInitialized();
  await Window.initialize();

  WindowOptions windowOptions = const WindowOptions(
    center: true,
    title: "Sangeet Desktop",
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setMinimumSize(const Size(600, 800));
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
