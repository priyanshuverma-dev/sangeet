import 'package:flutter/material.dart';

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

        return Container(
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            color: Colors.black12,
            width: 4,
          ))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColorDark,
                            foregroundImage:
                                NetworkImage(metadata.image[1].url),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${metadata.name} - ${metadata.label}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(metadata.album.name),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        ref
                            .watch(appScreenConfigProvider.notifier)
                            .goto(screen: Screens.playlist);
                      },
                      icon: const Icon(Icons.playlist_play_rounded),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder<PositionData>(
                      stream: ref
                          .watch(playerControllerProvider.notifier)
                          .positionDataStream,
                      builder: (context, snapshot) {
                        final positionData = snapshot.data;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: ProgressBar(
                            progress: positionData?.position ?? Duration.zero,
                            buffered:
                                positionData?.bufferedPosition ?? Duration.zero,
                            total: positionData?.duration ?? Duration.zero,
                            progressBarColor: Colors.red,
                            baseBarColor: Colors.white.withOpacity(0.24),
                            bufferedBarColor: Colors.white.withOpacity(0.24),
                            thumbColor: Colors.white,
                            barHeight: 3.0,
                            thumbRadius: 5.0,
                            onSeek: (duration) {
                              player.seek(duration);
                            },
                          ),
                        );
                      },
                    ),
                    PlayerControllerButtons(
                      player: player,
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
