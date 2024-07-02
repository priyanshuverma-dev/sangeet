import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerControllerButtons extends StatelessWidget {
  final AudioPlayer player;
  const PlayerControllerButtons({
    super.key,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<LoopMode>(
          stream: player.loopModeStream,
          builder: (context, snapshot) {
            final loopMode = snapshot.data ?? LoopMode.off;
            const icons = [
              Icon(Icons.repeat, color: Colors.white),
              Icon(Icons.repeat, color: Colors.teal),
              Icon(Icons.repeat_one, color: Colors.teal),
            ];
            const cycleModes = [
              LoopMode.off,
              LoopMode.all,
              LoopMode.one,
            ];
            final index = cycleModes.indexOf(loopMode);
            return IconButton(
              icon: icons[index],
              onPressed: () {
                player.setLoopMode(cycleModes[
                    (cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.skip_previous_rounded,
            color: Colors.white,
          ),
          onPressed: () => player.seekToPrevious(),
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                child: const CircularProgressIndicator(
                  strokeCap: StrokeCap.round,
                  strokeAlign: -4,
                ),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(
                  Icons.play_arrow_rounded,
                  size: 35,
                  color: Colors.white,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(
                  Icons.pause_rounded,
                  size: 35,
                  color: Colors.white,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(
                  Icons.replay_circle_filled_rounded,
                  size: 35,
                  color: Colors.white,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.skip_next_rounded,
            color: Colors.white,
          ),
          onPressed: () => player.seekToNext(),
        ),
        StreamBuilder<bool>(
          stream: player.shuffleModeEnabledStream,
          builder: (context, snapshot) {
            final shuffleModeEnabled = snapshot.data ?? false;
            return IconButton(
              icon: shuffleModeEnabled
                  ? const Icon(Icons.shuffle, color: Colors.teal)
                  : const Icon(Icons.shuffle, color: Colors.white),
              onPressed: () async {
                final enable = !shuffleModeEnabled;
                if (enable) {
                  await player.shuffle();
                }
                await player.setShuffleModeEnabled(enable);
              },
            );
          },
        ),
      ],
    );
  }
}
