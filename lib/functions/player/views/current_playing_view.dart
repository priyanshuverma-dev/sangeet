import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sangeet/core/core.dart';
import 'package:sangeet/core/app_config.dart';
import 'package:sangeet/core/skeletions/media_loading_skeletion.dart';
import 'package:sangeet/core/widgets/blur_image_container.dart';
import 'package:sangeet/core/widgets/media_card.dart';
import 'package:sangeet/core/widgets/split_view_container.dart';
import 'package:sangeet/functions/album/view/album_view.dart';
import 'package:sangeet/functions/explore/controllers/explore_controller.dart';
import 'package:sangeet/functions/player/controllers/player_controller.dart';

import 'package:sangeet/functions/playlist/view/playlist_view.dart';
import 'package:sangeet/functions/song/view/song_view.dart';
import 'package:sangeet_api/models.dart';

class CurrentPlayingView extends ConsumerWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CurrentPlayingView(),
      );
  const CurrentPlayingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerControllerProvider.notifier).getPlayer;
    final playlist = ref.watch(playerControllerProvider.notifier).playlist;

    return BlurImageContainer(
      child: SplitViewContainer(
        rightChild: getRightChild(context: context, ref: ref),
        leftChild: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // song image and title
            StreamBuilder<SequenceState?>(
              stream: player.sequenceStateStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SizedBox(
                      height: 400,
                      width: 400,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.data?.sequence.isEmpty ?? false) {
                  return Container();
                }
                final song = snapshot.data!.currentSource!.tag as SongModel;
                if (snapshot.data!.currentIndex == playlist.length - 1) {
                  ref
                      .watch(playerControllerProvider.notifier)
                      .loadMoreSongs(songId: song.id);
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          song.images[2].url,
                          width: 400,
                          height: 400,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      width: 400,
                      height: 100,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            song.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                          Text(
                            song.albumName,
                            style: const TextStyle(
                              fontSize: 18,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            // slider and control buttons
            // Disabling temporarily @see again
            // StreamBuilder(
            //   stream: player.sequenceStateStream,
            //   builder: (context, snapshot) {
            //     return Container(
            //       height: 70,
            //       padding: const EdgeInsets.all(8),
            //       margin: const EdgeInsets.symmetric(vertical: 10),
            //       decoration: BoxDecoration(
            //         color: Colors.black12,
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Expanded(
            //             flex: 1,
            //             child: StreamBuilder<PositionData>(
            //               stream: ref
            //                   .watch(playerControllerProvider.notifier)
            //                   .positionDataStream,
            //               builder: (context, snapshot) {
            //                 final positionData = snapshot.data;
            //                 return ProgressBar(
            //                   progress: positionData?.position ?? Duration.zero,
            //                   buffered: positionData?.bufferedPosition ??
            //                       Duration.zero,
            //                   total: positionData?.duration ?? Duration.zero,
            //                   progressBarColor: Colors.teal,
            //                   baseBarColor: Colors.white.withOpacity(0.24),
            //                   bufferedBarColor: Colors.white.withOpacity(0.24),
            //                   thumbColor: Colors.white,
            //                   timeLabelLocation: TimeLabelLocation.sides,
            //                   timeLabelType: TimeLabelType.totalTime,
            //                   barHeight: 3.0,
            //                   thumbRadius: 4.0,
            //                   onSeek: (duration) {
            //                     player.seek(duration);
            //                   },
            //                 );
            //               },
            //             ),
            //           ),
            //           PlayerControllerButtons(
            //             player: player,
            //           ),
            //         ],
            //       ),
            //     );
            //   },
            // )

            // back button and more options button
            Container(
              height: 70,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Radio.',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Wrap(
                    children: [
                      BackButton(
                        onPressed: () => ref
                            .watch(appScreenConfigProvider.notifier)
                            .onIndex(0),
                      ),
                      IconButton(
                        tooltip: "More",
                        onPressed: () {},
                        icon: const Icon(Icons.more_vert_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            StreamBuilder<SequenceState?>(
                stream: player.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  final sequence = state?.sequence ?? [];

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const NoPlayingView();
                  }

                  if (state?.sequence.isEmpty ?? false) {
                    return Container();
                  }

                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      buildDefaultDragHandles: true,
                      onReorder: (int oldIndex, int newIndex) {
                        if (oldIndex < newIndex) newIndex--;
                        playlist.move(oldIndex, newIndex);
                      },
                      scrollDirection: Axis.vertical,
                      itemCount: sequence.length,
                      itemBuilder: (context, i) {
                        final song = sequence[i].tag as SongModel;
                        return Dismissible(
                          key: ValueKey(sequence[i]),
                          onDismissed: (dismissDirection) {
                            playlist.removeAt(i);
                          },
                          child: ListTile(
                            splashColor: song.accentColor,
                            title: Text.rich(
                              TextSpan(
                                text: song.title,
                                children: <InlineSpan>[
                                  if (i == state!.currentIndex)
                                    (const TextSpan(
                                        text: " (Playing) ",
                                        style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        )))
                                ],
                              ),
                            ),
                            subtitle: Text(song.albumName),
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  Theme.of(context).primaryColorDark,
                              foregroundImage: NetworkImage(song.images[0].url),
                            ),
                            onTap: () {
                              player.seek(Duration.zero, index: i);
                            },
                          ),
                        );
                      },
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class NoPlayingView extends StatelessWidget {
  const NoPlayingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Nothing To Play",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          TextButton.icon(
            icon: const Icon(
              Icons.data_usage_outlined,
              color: Colors.black,
            ),
            onPressed: () {},
            // onPressed: () => ref
            //     .watch(playerControllerProvider.notifier)
            //     .runRadio(
            //       radioId: "uQKEtZYc",
            //       type: MediaType.song,
            //     ),
            label: const Text(
              "Random Song",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

Widget getRightChild({
  required BuildContext context,
  required WidgetRef ref,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Trending.',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Container(
        child: ref.watch(getTrendingSongsProvider).when(
              data: (data) {
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  semanticChildCount: data.total,
                  children: [
                    ...data.songs.map(
                      (song) => MediaCard(
                        onTap: () => Navigator.of(context).push(
                          SongView.route(song.id),
                        ),
                        image: song.images[1].url,
                        title: song.title,
                        subtitle: song.albumName,
                        badgeIcon: Icons.music_note_rounded,
                        explicitContent: song.explicitContent,
                      ),
                    ),
                    ...data.albums.map(
                      (album) => MediaCard(
                        onTap: () => Navigator.of(context).push(
                          AlbumView.route(album.id),
                        ),
                        image: album.images[1].url,
                        title: album.title,
                        subtitle: album.artists.map((e) => e.name).join(','),
                        badgeIcon: Icons.album_rounded,
                        explicitContent: album.explicitContent,
                        onDoubleTap: () {},
                      ),
                    ),
                    ...data.playlists.map(
                      (playlist) => MediaCard(
                        onTap: () => Navigator.of(context).push(
                          PlaylistView.route(playlist.id),
                        ),
                        image: playlist.images[0].url,
                        title: playlist.title,
                        subtitle: playlist.subtitle,
                        badgeIcon: Icons.playlist_play_rounded,
                        explicitContent: playlist.explicitContent,
                        onDoubleTap: () {},
                      ),
                    ),
                  ],
                );
              },
              error: (er, st) => ErrorPage(
                error: er.toString(),
              ),
              loading: () => const MediaLoader(),
            ),
      ),
    ],
  );
}
