import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sangeet/core/core.dart';
import 'package:sangeet/core/utils.dart';
import 'package:sangeet/core/app_config.dart';
import 'package:sangeet/core/widgets/media_card.dart';
import 'package:sangeet/functions/artist/view/artist_view.dart';
import 'package:sangeet/functions/explore/controllers/explore_controller.dart';
import 'package:sangeet/functions/player/controllers/player_controller.dart';
import 'package:sangeet/functions/player/widgets/common.dart';
import 'package:sangeet/functions/player/widgets/player_control_buttons.dart';
import 'package:sangeet_api/models.dart';

class CurrentPlayingView extends ConsumerWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CurrentPlayingView(),
      );
  const CurrentPlayingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(getAudioPlayer);
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

        final song = state!.currentSource!.tag as SongModel;
        final songs = state.sequence;

        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(song.images[2].url),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(1),
                    Colors.black54.withOpacity(0.1),
                    Colors.black.withOpacity(1),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                song.images[2].url,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.symmetric(vertical: 10),
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
                                    ),
                                  ),
                                  Text(
                                    song.albumName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: StreamBuilder<PositionData>(
                                      stream: ref
                                          .watch(
                                              playerControllerProvider.notifier)
                                          .positionDataStream,
                                      builder: (context, snapshot) {
                                        final positionData = snapshot.data;
                                        return ProgressBar(
                                          progress: positionData?.position ??
                                              Duration.zero,
                                          buffered:
                                              positionData?.bufferedPosition ??
                                                  Duration.zero,
                                          total: positionData?.duration ??
                                              Duration.zero,
                                          progressBarColor: Colors.teal,
                                          baseBarColor:
                                              Colors.white.withOpacity(0.24),
                                          bufferedBarColor:
                                              Colors.white.withOpacity(0.24),
                                          thumbColor: Colors.white,
                                          timeLabelLocation:
                                              TimeLabelLocation.sides,
                                          timeLabelType:
                                              TimeLabelType.totalTime,
                                          barHeight: 3.0,
                                          thumbRadius: 4.0,
                                          onSeek: (duration) {
                                            player.seek(duration);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  PlayerControllerButtons(
                                    player: player,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      'Next Songs.',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: TextButton.icon(
                                      onPressed: () => ref
                                          .watch(
                                              appScreenConfigProvider.notifier)
                                          .onIndex(0),
                                      icon:
                                          const Icon(Icons.arrow_left_rounded),
                                      label: const Text("Back"),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.black12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: songs.length,
                                itemBuilder: (context, index) {
                                  final s = songs[index].tag as SongModel;
                                  return ListTile(
                                    onTap: () {},
                                    title: Text(s.title),
                                    subtitle: Text(
                                      "${formatNumber(s.playCount)} listens, ${formatDuration(song.duration)} long",
                                    ),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        s.images[1].url,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // SUGGESTIONS
                  Visibility(
                    visible: MediaQuery.of(context).size.width > 750,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Artists.',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: song.artists.length,
                              itemBuilder: (context, index) {
                                final artist = song.artists[index];
                                return ListTile(
                                  onTap: () => Navigator.of(context)
                                      .push(ArtistView.route(artist.id)),
                                  title: Text(artist.name),
                                  subtitle: Text(artist.type),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(artist.image),
                                  ),
                                );
                              },
                            ),
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
                                        physics: const BouncingScrollPhysics(),
                                        children: [
                                          ...data.songs.map(
                                            (song) => MediaCard(
                                              onTap: () {},
                                              image: song.images[0].url,
                                              title: song.title,
                                              subtitle: song.albumName,
                                              badgeIcon:
                                                  Icons.music_note_rounded,
                                              explicitContent:
                                                  song.explicitContent,
                                            ),
                                          ),
                                          ...data.albums.map(
                                            (album) => MediaCard(
                                              onTap: () {},
                                              image: album.images[0].url,
                                              title: album.title,
                                              subtitle: album.artists
                                                  .map((e) => e.name)
                                                  .join(','),
                                              badgeIcon: Icons.album_rounded,
                                              explicitContent:
                                                  album.explicitContent,
                                              onDoubleTap: () {},
                                            ),
                                          ),
                                          ...data.playlists.map(
                                            (playlist) => MediaCard(
                                              onTap: () {},
                                              image: playlist.images[0].url,
                                              title: playlist.title,
                                              subtitle: playlist.subtitle,
                                              badgeIcon:
                                                  Icons.playlist_play_rounded,
                                              explicitContent:
                                                  playlist.explicitContent,
                                              onDoubleTap: () {},
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    error: (er, st) => ErrorPage(
                                      error: er.toString(),
                                    ),
                                    loading: () => const LoadingPage(),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
