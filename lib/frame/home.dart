import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saavn/frame/commons.dart';
import 'package:saavn/frame/widgets/sidebar.dart';
import 'package:saavn/functions/player/widgets/base_audio_player.dart';
import 'package:sidebarx/sidebarx.dart';

class HomeFrame extends ConsumerStatefulWidget {
  const HomeFrame({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeFrameState();
}

class _HomeFrameState extends ConsumerState<HomeFrame> {
  final SidebarXController sidebarXController =
      SidebarXController(selectedIndex: 0);

  void onPressSettings() {
    if (ref.watch(appScreenConfigProvider) == Screens.settings) {
      return ref
          .watch(appScreenConfigProvider.notifier)
          .goto(screen: Screens.explore);
    }
    return ref
        .watch(appScreenConfigProvider.notifier)
        .goto(screen: Screens.settings);
  }

  void onPressSearch() {
    if (ref.watch(appScreenConfigProvider) == Screens.search) {
      return ref
          .watch(appScreenConfigProvider.notifier)
          .goto(screen: Screens.explore);
    }
    return ref
        .watch(appScreenConfigProvider.notifier)
        .goto(screen: Screens.search);
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
}
