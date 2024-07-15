import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/core.dart';
import 'package:sangeet/core/skeletions/screen_loading_skeleton.dart';
import 'package:sangeet/core/widgets/blur_image_container.dart';
import 'package:sangeet/core/widgets/media_card.dart';
import 'package:sangeet/core/widgets/play_button.dart';
import 'package:sangeet/core/widgets/split_view_container.dart';
import 'package:sangeet/core/widgets/top_details.dart';
import 'package:sangeet/functions/artist/view/artist_view.dart';
import 'package:sangeet/functions/charts/controllers/charts_controller.dart';
import 'package:sangeet/functions/player/controllers/player_controller.dart';
import 'package:sangeet/functions/song/view/song_view.dart';

class ChartView extends ConsumerWidget {
  static route(String id) => MaterialPageRoute(
        builder: (context) => ChartView(
          chartId: id,
        ),
      );

  final String chartId;
  const ChartView({this.chartId = "", super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ModalRoute.of(context)?.settings.name ?? chartId;
    final controller = ref.watch(playerControllerProvider.notifier);

    return ref.watch(chartByIdProvider(name)).when(
          data: (chart) {
            return BlurImageContainer(
              image: chart.images[2].url,
              isAsset: false,
              child: SplitViewContainer(
                leftChild: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TopDetailsContainer(
                      key: const Key('chart_top'),
                      title: chart.title,
                      subtitle: chart.subtitle,
                      image: chart.images[2].url,
                      thirdLine:
                          "fans ${formatNumber(chart.fanCount)} \nfollowers ${formatNumber(chart.followerCount)}",
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            children: [
                              const BackButton(
                                key: Key("back_btn"),
                              ),
                              IconButton(
                                tooltip: "More",
                                onPressed: () {},
                                icon: const Icon(Icons.more_vert_rounded),
                              ),
                            ],
                          ),
                          const Text(
                            'Playlist',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PlayButton(
                            onPressed: () => controller.runRadio(
                              radioId: chart.id,
                              type: MediaType.playlist,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: chart.songs.length,
                        itemBuilder: (context, index) {
                          final song = chart.songs[index];
                          return MediaCard(
                            onDoubleTap: () => controller.runRadio(
                              radioId: song.id,
                              type: MediaType.song,
                              prevSongs: chart.songs,
                              playCurrent: true,
                            ),
                            onTap: () => Navigator.of(context).push(
                              SongView.route(song.id),
                            ),
                            contextMenu: [
                              ContextMenuButtonConfig(
                                icon: const Icon(Icons.queue_music_rounded),
                                "Add in Queue",
                                onPressed: () =>
                                    controller.addSongToQueue(song: song),
                              ),
                              ContextMenuButtonConfig(
                                icon: const Icon(
                                    Icons.play_circle_filled_rounded),
                                "Play Next",
                                onPressed: () =>
                                    controller.addSongToNext(song: song),
                              )
                            ],
                            image: song.images[1].url,
                            title: song.title,
                            subtitle:
                                "${formatNumber(song.playCount)} listens, ${formatDuration(song.duration)}",
                            explicitContent: song.explicitContent,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                rightChild: Column(
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
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: chart.artists.length,
                      itemBuilder: (context, index) {
                        final artist = chart.artists[index];
                        return MediaCard(
                          onTap: () => Navigator.of(context)
                              .push(ArtistView.route(artist.id)),
                          image: artist.image,
                          title: artist.name,
                          subtitle: artist.type,
                          explicitContent: false,
                          onMenuTap: () {},
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          error: (err, st) => ErrorPage(error: err.toString()),
          loading: () => const ScreenLoading(),
        );
  }
}
