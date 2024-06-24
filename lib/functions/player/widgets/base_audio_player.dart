import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saavn/frame/commons.dart';

import 'package:saavn/functions/player/controllers/player_controller.dart';
import 'package:saavn/functions/player/widgets/common.dart';
import 'package:saavn/functions/player/widgets/player_control_buttons.dart';

import 'package:saavn/models/song_model.dart';

// FOR APPBAR WIDGET
PreferredSizeWidget getBasePlayerAppbar(BuildContext context) {
  return PreferredSize(
    preferredSize: Size(MediaQuery.of(context).size.width, 200),
    child: const BaseAudioPlayer(),
  );
}

class BaseAudioPlayer extends ConsumerStatefulWidget {
  const BaseAudioPlayer({super.key});

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

        // Start
        return Container(
          margin: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder<PositionData>(
                stream: ref
                    .watch(playerControllerProvider.notifier)
                    .positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return Container(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: ProgressBar(
                      progress: positionData?.position ?? Duration.zero,
                      buffered: positionData?.bufferedPosition ?? Duration.zero,
                      total: positionData?.duration ?? Duration.zero,
                      progressBarColor: Colors.red,
                      baseBarColor: Colors.white.withOpacity(0.24),
                      bufferedBarColor: Colors.white.withOpacity(0.24),
                      thumbColor: Colors.white,
                      timeLabelLocation: TimeLabelLocation.sides,
                      timeLabelType: TimeLabelType.totalTime,
                      barHeight: 3.0,
                      thumbRadius: 5.0,
                      onSeek: (duration) {
                        player.seek(duration);
                      },
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Image.network(
                              metadata.image[1].url,
                              width: 80,
                              height: 80,
                              cacheHeight: 80,
                              cacheWidth: 80,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "${metadata.name} - ${metadata.label}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                metadata.album.name,
                                style: const TextStyle(
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),
                            PlayerControllerButtons(
                              player: player,
                              onPressed: () => ref
                                  .watch(appScreenConfigProvider.notifier)
                                  .goto(screen: Screens.playlist),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
