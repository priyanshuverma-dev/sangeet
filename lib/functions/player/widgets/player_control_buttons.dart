import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:saavn/functions/player/widgets/common.dart';

class PlayerControllerButtons extends StatelessWidget {
  final AudioPlayer player;
  final VoidCallback onPressed;
  const PlayerControllerButtons({
    super.key,
    required this.player,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(
            Icons.volume_up,
          ),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.skip_previous_rounded,
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
                  Icons.play_arrow,
                ),
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(
                  Icons.pause,
                ),
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(
                  Icons.replay,
                ),
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.skip_next_rounded,
          ),
          onPressed: () => player.seekToNext(),
        ),
        IconButton(
          onPressed: onPressed,
          icon: const Icon(Icons.playlist_play_rounded),
        ),
      ],
    );
  }
}
