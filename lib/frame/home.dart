import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savaan/frame/commons.dart';
import 'package:savaan/functions/player/widgets/base_audio_player.dart';

class HomeFrame extends ConsumerStatefulWidget {
  const HomeFrame({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeFrameState();
}

class _HomeFrameState extends ConsumerState<HomeFrame> {
  @override
  Widget build(BuildContext context) {
    final content = ref.watch(appScreenConfigProvider).screen;

    return Scaffold(
      appBar: getBasePlayerAppbar(context),
      body: content,
    );
  }
}
