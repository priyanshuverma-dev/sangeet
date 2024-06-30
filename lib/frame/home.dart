import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:sangeet/core/constants.dart';
import 'package:sangeet/frame/commons.dart';
import 'package:sangeet/functions/player/controllers/player_controller.dart';
import 'package:sangeet/functions/player/widgets/base_audio_player.dart';
import 'package:sangeet/functions/shortcuts/actions.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class HomeFrame extends ConsumerStatefulWidget {
  const HomeFrame({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeFrameState();
}

class _HomeFrameState extends ConsumerState<HomeFrame>
    with TrayListener, WindowListener {
  @override
  void initState() {
    super.initState();
    trayManager.addListener(this);
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenConfig = ref.watch(appScreenConfigProvider.notifier);
    final screen = ref.watch(appScreenConfigProvider).screen;
    return Actions(
      actions: <Type, Action<Intent>>{
        BaseIntent: SongActions(
          audioPlayer: ref.watch(playerControllerProvider.notifier).getPlayer,
        )
      },
      child: GlobalShortcuts(
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.keyW, alt: true): BaseIntent(
            keyAction: KeyAction.playPauseMusic,
          ),
          SingleActivator(LogicalKeyboardKey.keyD, alt: true): BaseIntent(
            keyAction: KeyAction.nextTrack,
          ),
          SingleActivator(LogicalKeyboardKey.keyA, alt: true): BaseIntent(
            keyAction: KeyAction.prevTrack,
          ),
        },
        child: Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: screen.index,
                onDestinationSelected: (i) => screenConfig.onIndex(i),
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text("Home"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.search),
                    label: Text("Search"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings),
                    label: Text("Settings"),
                  ),
                ],
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.asset(
                    'assets/app_icon.ico',
                    width: 35,
                  ),
                ),
                elevation: 10,
                labelType: NavigationRailLabelType.all,
                indicatorShape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              Expanded(
                child: screen.view,
              ),
            ],
          ),
          bottomNavigationBar: const BaseAudioPlayer(),
        ),
      ),
    );
  }

  @override
  void onTrayIconRightMouseDown() async {
    await trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    final player = ref.watch(playerControllerProvider.notifier).getPlayer;
    if (menuItem.key == SystemTrayActions.hideShow) {
      if (await windowManager.isVisible()) {
        await windowManager.hide();
      } else {
        await windowManager.show();
      }
    }
    if (menuItem.key == SystemTrayActions.exit) {
      await windowManager.destroy();
    }
    if (menuItem.key == SystemTrayActions.playPauseMusic) {
      if (player.playing) {
        await player.pause();
      } else {
        await player.play();
      }
    }
    if (player.playing) {
      if (menuItem.key == SystemTrayActions.nextTrack) {
        await player.seekToNext();
      }
      if (menuItem.key == SystemTrayActions.prevTrack) {
        await player.seekToPrevious();
      }
      if (menuItem.key == SystemTrayActions.openPlaylist) {
        await windowManager.show();
        ref
            .watch(appScreenConfigProvider.notifier)
            .goto(screen: Screens.playlist);
      }
    }

    super.onTrayMenuItemClick(menuItem);
  }

  @override
  void onWindowClose() async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          elevation: 0,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Close this window?'),
          content: const Text('Are you sure you want to close this window?'),
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Hide'),
              onPressed: () async {
                Navigator.of(context).pop();
                await windowManager.hide();
              },
            ),
            TextButton(
              child: const Text('Close'),
              onPressed: () async {
                Navigator.of(context).pop();
                await windowManager.destroy();
              },
            ),
          ],
        );
      },
    );
  }
}
