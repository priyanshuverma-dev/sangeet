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
  @override
  Widget build(BuildContext context) {
    final screen = ref.watch(appScreenConfigProvider).screen;

    return Scaffold(
      appBar: AppBar(
        title: Text(screen.name),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: screen.view,
      bottomNavigationBar: const BaseAudioPlayer(),
    );
  }
}
