import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sangeet/core/core.dart';
import 'package:sangeet/core/skeletions/explore_loading_skeletion.dart';

import 'package:sangeet/functions/explore/widgets/browse_card.dart';
import 'package:sangeet/functions/explore/widgets/trend_card.dart';

import 'package:sangeet/functions/explore/controllers/explore_controller.dart';
import 'package:sangeet/functions/player/controllers/player_controller.dart';

import 'package:sangeet/functions/charts/view/charts_view.dart';
import 'package:sangeet/functions/album/view/album_view.dart';
import 'package:sangeet/functions/playlist/view/playlist_view.dart';
import 'package:sangeet/functions/song/view/song_view.dart';

class ExploreList extends ConsumerWidget {
  const ExploreList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                              key: Key("trend_${item.id}"),
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
                        return BrowseCard(
                          key: Key("album_card_$index"),
                          accentColor: album.accentColor,
                          explicitContent: album.explicitContent,
                          image: album.images[1].url,
                          subtitle: album.subtitle == ""
                              ? album.artists.map((e) => e.name).join(',')
                              : album.subtitle,
                          title: album.title,
                          onTap: () => Navigator.of(context).push(
                            AlbumView.route(album.id),
                          ),
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
                        return BrowseCard(
                          key: Key("chart_card_$index"),
                          explicitContent: chart.explicitContent,
                          image: chart.image,
                          subtitle: chart.subtitle == ""
                              ? chart.language
                              : chart.subtitle,
                          title: chart.title,
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
                        return BrowseCard(
                          explicitContent: radio.explicitContent,
                          image: radio.image,
                          subtitle: radio.subtitle,
                          title: radio.title,
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
                        return BrowseCard(
                          key: Key("playlist_card_$index"),
                          explicitContent: playlist.explicitContent,
                          image: playlist.images[1].url,
                          subtitle: playlist.subtitle,
                          title: playlist.title,
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
          loading: () => const ExploreLoader(),
        );
  }
}
