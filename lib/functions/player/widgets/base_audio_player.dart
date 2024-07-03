import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/app_config.dart';
import 'package:sangeet/functions/player/controllers/player_controller.dart';
import 'package:sangeet/functions/player/widgets/common.dart';
import 'package:sangeet/functions/player/widgets/player_control_buttons.dart';
import 'package:sangeet_api/modules/song/models/song_model.dart';

class BaseAudioPlayer extends ConsumerStatefulWidget {
  const BaseAudioPlayer({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BaseAudioPlayerState();
}

class _BaseAudioPlayerState extends ConsumerState<BaseAudioPlayer> {
  @override
  Widget build(BuildContext context) {
    final player = ref.read(getAudioPlayer);

    return StreamBuilder<SequenceState?>(
      stream: player.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(height: 0);
        }
        if (state?.sequence.isEmpty ?? true) {
          return const SizedBox();
        }

        final metadata = state!.currentSource!.tag as SongModel;

        return Card(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        metadata.images[1].url,
                        height: 70,
                        width: 70,
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              metadata.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                            ),
                            Text(
                              metadata.albumName,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamBuilder<PositionData>(
                        stream: ref
                            .watch(playerControllerProvider.notifier)
                            .positionDataStream,
                        builder: (context, snapshot) {
                          final positionData = snapshot.data;
                          return ProgressBar(
                            progress: positionData?.position ?? Duration.zero,
                            buffered:
                                positionData?.bufferedPosition ?? Duration.zero,
                            total: positionData?.duration ?? Duration.zero,
                            progressBarColor: Colors.teal,
                            baseBarColor: Colors.white.withOpacity(0.24),
                            bufferedBarColor: Colors.white.withOpacity(0.24),
                            thumbColor: Colors.white,
                            timeLabelLocation: TimeLabelLocation.sides,
                            timeLabelType: TimeLabelType.totalTime,
                            barHeight: 3.0,
                            thumbRadius: 4.0,
                            onSeek: (duration) {
                              player.seek(duration);
                            },
                          );
                        },
                      ),
                      PlayerControllerButtons(
                        player: player,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: MediaQuery.of(context).size.width >= 880 ? 1 : 0,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => ref
                            .watch(appScreenConfigProvider.notifier)
                            .onIndex(2),
                        icon: const Icon(Icons.open_in_full_rounded),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
