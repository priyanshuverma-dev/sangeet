import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'package:tray_manager/tray_manager.dart';

import 'package:sangeet/core/constants.dart';
import 'package:sangeet/functions/explore/views/explore_view.dart';
import 'package:sangeet/functions/player/controllers/player_controller.dart';
import 'package:sangeet/functions/player/widgets/base_audio_player.dart';
import 'package:sangeet/functions/search/views/search_view.dart';
import 'package:sangeet/functions/settings/views/settings_view.dart';
import 'package:sangeet/functions/shortcuts/actions.dart';

class HomeFrame extends ConsumerStatefulWidget {
  const HomeFrame({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeFrameState();
}

class _HomeFrameState extends ConsumerState<HomeFrame>
    with TrayListener, WindowListener {
  int _index = 0;

  void onDestinationSelected(int i) {
    setState(() {
      _index = i;
    });
  }

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
                selectedIndex: _index,
                onDestinationSelected: onDestinationSelected,
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
                labelType: NavigationRailLabelType.none,
                indicatorShape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: IndexedStack(
                        index: _index,
                        children: [
                          _buildNavigator(
                            0,
                            const ExploreView(),
                          ),
                          _buildNavigator(
                            1,
                            const SearchView(),
                          ),
                          _buildNavigator(
                            2,
                            const SettingsView(),
                          ),
                        ],
                      ),
                    ),
                    const BaseAudioPlayer(),
                  ],
                ),
              ),
            ],
          ),
          // bottomNavigationBar: const BaseAudioPlayer(),
        ),
      ),
    );
  }

  Widget _buildNavigator(int index, Widget child) {
    return Navigator(
      key: GlobalKey<NavigatorState>(debugLabel: 'navigator$index'),
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (context) => child,
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
