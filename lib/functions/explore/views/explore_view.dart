import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:savaan/core/core.dart';
import 'package:savaan/core/size_manager.dart';
import 'package:savaan/functions/explore/controllers/explore_controller.dart';
import 'package:savaan/functions/player/controllers/player_controller.dart';
import 'package:savaan/functions/player/views/common.dart';
import 'package:savaan/functions/player/views/player_view.dart';
import 'package:savaan/models/song_metadata.dart';
// import 'package:savaan/models/song_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  @override
  Widget build(BuildContext context) {
    final player = ref.read(getAudioPlayer);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 200),
        child: StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) {
            final state = snapshot.data;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(height: AppSize.s0);
            }
            if (state?.sequence.isEmpty ?? true) {
              return const SizedBox();
            }
            final metadata = state!.currentSource!.tag as SongMetadata;

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
                                backgroundColor:
                                    Theme.of(context).primaryColorDark,
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
                                Text(metadata.album),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.playlist_add_check,
                          ),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: ProgressBar(
                                progress:
                                    positionData?.position ?? Duration.zero,
                                buffered: positionData?.bufferedPosition ??
                                    Duration.zero,
                                total: positionData?.duration ?? Duration.zero,
                                progressBarColor: Colors.red,
                                baseBarColor: Colors.white.withOpacity(0.24),
                                bufferedBarColor:
                                    Colors.white.withOpacity(0.24),
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
                        ControlButtons(player),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            ExploreList(),
          ],
        ),
      ),

      //bottomSheet: const BottomPlayerSheet(),
    );
  }
}

class ExploreList extends ConsumerWidget {
  const ExploreList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.read(getAudioPlayer);

    return ref.watch(getExploreDataProvider).when(
          data: (songs) {
            return Skeletonizer(
              ignoreContainers: true,
              enabled: true,
              child: ListView.builder(
                itemCount: 12,
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                          'Item number $index And The Song Name is This loading indicator'),
                      subtitle: const Text('Subtitle here'),
                      trailing: const Icon(
                        Icons.ac_unit,
                        size: 32,
                      ),
                    ),
                  );
                },
              ),
            );
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return ListTile(
                    title: Text(song.name),
                    subtitle: Text("${song.label} - ${song.year}"),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Theme.of(context).primaryColorDark,
                      foregroundImage: NetworkImage(song.image[0].url),
                    ),
                    onTap: () async {
                      if (player.audioSource?.sequence[0].tag.id == song.id) {
                        return;
                      }

                      ref
                          .read(playerControllerProvider.notifier)
                          .setSong(song: song);

                      await player.play();
                    });
              },
            );
          },
          error: (error, stackTrace) {
            return ErrorText(
              error: error.toString(),
            );
          },
          loading: () => Center(
            child: Skeletonizer(
              ignoreContainers: true,
              enabled: true,
              child: ListView.builder(
                itemCount: 8,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('Item number $index as title'),
                      subtitle: const Text('Subtitle here'),
                      trailing: const Icon(
                        Icons.ac_unit,
                        size: 32,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
  }
}
