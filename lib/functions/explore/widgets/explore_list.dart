import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/core.dart';
import 'package:sangeet/functions/album/view/album_view.dart';
import 'package:sangeet/functions/charts/view/charts_view.dart';
import 'package:sangeet/functions/explore/controllers/explore_controller.dart';
import 'package:sangeet/functions/explore/views/explore_view.dart';
import 'package:sangeet/functions/explore/widgets/album_card.dart';
import 'package:sangeet/functions/explore/widgets/chart_card.dart';
import 'package:sangeet/functions/explore/widgets/playlist_card.dart';
import 'package:sangeet/functions/explore/widgets/radio_card.dart';
import 'package:sangeet/functions/explore/widgets/trend_card.dart';
import 'package:sangeet/functions/player/controllers/player_controller.dart';
import 'package:sangeet/functions/playlist/view/playlist_view.dart';
import 'package:sangeet/functions/song/view/song_view.dart';

class ExploreList extends ConsumerWidget {
  const ExploreList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final player = ref.read(getAudioPlayer);

    return ref.watch(getExploreDataProvider).when(
          data: (data) {
            final charts = data.charts;
            final radios = data.radios;
            final albums = data.albums;
            final playlists = data.topPlaylists;
            final trendings = data.trending;
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TRENDINGS
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Trendings.',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    height: 290.0,
                    child: GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: 0.2,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: trendings
                          .map(
                            (item) => TrendCard(
                              key: Key(item.id),
                              onPlay: () => ref
                                  .watch(playerControllerProvider.notifier)
                                  .runRadio(
                                    radioId: item.id,
                                    type: MediaType.fromString(item.type),
                                    redirect: () {
                                      if (item.type == 'song') {
                                        Navigator.of(context)
                                            .push(SongView.route(item.id));
                                      }
                                      if (item.type == 'album') {
                                        Navigator.of(context)
                                            .push(AlbumView.route(item.id));
                                      }
                                      if (item.type == 'playlist') {
                                        Navigator.of(context)
                                            .push(PlaylistView.route(item.id));
                                      }
                                    },
                                  ),
                              onLike: () {},
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  if (item.type == 'song') {
                                    return SongView(
                                      songId: item.id,
                                    );
                                  }
                                  if (item.type == 'album') {
                                    return AlbumView(
                                      albumId: item.id,
                                    );
                                  }
                                  if (item.type == 'playlist') {
                                    return PlaylistView(
                                      playlistId: item.id,
                                    );
                                  } else {
                                    return const ExploreView();
                                  }
                                }));
                              },
                              image: item.image,
                              accentColor: item.accentColor,
                              title: item.title,
                              subtitle: item.subtitle,
                              explicitContent: item.explicitContent,
                              badgeIcon: item.type == "song"
                                  ? Icons.music_note
                                  : item.type == "playlist"
                                      ? Icons.playlist_play_rounded
                                      : Icons.album_rounded,
                            ),
                          )
                          .toList(),
                    ),
                  ),

                  // ALBUMS //
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'New Albums.',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    height: 400.0,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: albums.length,
                      itemBuilder: (context, index) {
                        final album = albums[index];
                        return AlbumCard(
                          album: album,
                          onTap: () => Navigator.of(context)
                              .push(AlbumView.route(album.id)),
                        );
                      },
                    ),
                  ),

                  // CHARTS //
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Top Charts.',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    height: 200.0,
                    child: ListView.builder(
                      itemCount: charts.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final chart = charts[index];
                        return ChartCard(
                          chart: chart,
                          onTap: () => Navigator.of(context).push(
                            ChartView.route(chart.token),
                          ),
                        );
                      },
                    ),
                  ),

                  // RADIOS //
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Radios.',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    height: 400.0,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: radios.length,
                      itemBuilder: (context, index) {
                        final radio = radios[index];
                        return RadioCard(
                          radio: radio,
                          onTap: () => ref
                              .watch(playerControllerProvider.notifier)
                              .runRadio(
                                radioId: radio.id,
                                type: MediaType.radio,
                                redirect: () {},
                              ),
                        );
                      },
                    ),
                  ),

                  // PLAYLISTS //
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'New Playlists.',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    height: 400.0,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: playlists.length,
                      itemBuilder: (context, index) {
                        final playlist = playlists[index];
                        return PlaylistCard(
                          playlist: playlist,
                          onTap: () => Navigator.of(context).push(
                            PlaylistView.route(playlist.id),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          error: (error, stackTrace) {
            return ErrorText(
              error: error.toString(),
            );
          },
          loading: () => const Loader(),
        );
  }
}
