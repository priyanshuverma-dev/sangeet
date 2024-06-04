import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saavn/frame/commons.dart';
import 'package:saavn/functions/player/widgets/base_audio_player.dart';

class HomeFrame extends ConsumerStatefulWidget {
  const HomeFrame({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeFrameState();
}

class _HomeFrameState extends ConsumerState<HomeFrame> {
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

  @override
  Widget build(BuildContext context) {
    final screen = ref.watch(appScreenConfigProvider).screen;

    return Scaffold(
      appBar: AppBar(
        title: Text(screen.name),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: onPressSettings,
              icon: const Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: screen.view,
      bottomNavigationBar: const BaseAudioPlayer(),
    );
  }
}
