import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saavn/core/constants.dart';
import 'package:saavn/frame/commons.dart';
import 'package:saavn/frame/widgets/sidebar.dart';
import 'package:saavn/functions/player/controllers/player_controller.dart';
import 'package:saavn/functions/player/widgets/base_audio_player.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class HomeFrame extends ConsumerStatefulWidget {
  const HomeFrame({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeFrameState();
}

class _HomeFrameState extends ConsumerState<HomeFrame>
    with TrayListener, WindowListener {
  final SidebarXController sidebarXController =
      SidebarXController(selectedIndex: 0);

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
    final screen = ref.watch(appScreenConfigProvider).screen;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(screen.name),
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: IconButton(
      //         onPressed: onPressSearch,
      //         icon: const Stack(
      //           children: [
      //             Icon(Icons.search),
      //             Positioned(
      //               // draw a red marble
      //               top: 0.0,
      //               right: 0.0,
      //               child: Icon(Icons.brightness_1,
      //                   size: 8.0, color: Colors.redAccent),
      //             )
      //           ],
      //         ),
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: IconButton(
      //         onPressed: onPressSettings,
      //         icon: const Icon(Icons.settings),
      //       ),
      //     ),
      //   ],
      // ),
      body: Row(
        children: [
          SideBar(controller: sidebarXController),
          Expanded(
            child: screen.view,
          ),
        ],
      ),
      bottomNavigationBar: const BaseAudioPlayer(),
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
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Minimize'),
              onPressed: () async {
                Navigator.of(context).pop();
                await windowManager.hide();
              },
            ),
          ],
        );
      },
    );
  }
}
