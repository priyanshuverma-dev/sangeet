import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/core.dart';
import 'package:sangeet/core/widgets/play_button.dart';
import 'package:sangeet/core/widgets/blur_image_container.dart';
import 'package:sangeet/core/widgets/media_card.dart';
import 'package:sangeet/core/widgets/top_details.dart';
import 'package:sangeet/functions/album/controllers/album_controller.dart';
import 'package:sangeet/functions/artist/view/artist_view.dart';
import 'package:sangeet/functions/player/controllers/player_controller.dart';

class AlbumView extends ConsumerWidget {
  static route(String id) => MaterialPageRoute(
        builder: (context) => AlbumView(
          albumId: id,
        ),
      );
  final String albumId;
  const AlbumView({this.albumId = "", super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ModalRoute.of(context)?.settings.name ?? albumId;

    return ref.watch(albumByIdProvider(name)).when(
          data: (album) {
            return BlurImageContainer(
              image: album.images[2].url,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TopDetailsContainer(
                              image: album.images[2].url,
                              subtitle: album.subtitle,
                              title: album.title,
                              badgeBackgroundColor: album.explicitContent
                                  ? Colors.teal
                                  : Colors.transparent,
                              badge: Visibility(
                                visible: album.explicitContent,
                                child: const Icon(
                                  Icons.explicit_rounded,
                                  size: 12,
                                ),
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
                                  Wrap(
                                    children: [
                                      const BackButton(),
                                      IconButton(
                                        tooltip: "More",
                                        onPressed: () {},
                                        icon:
                                            const Icon(Icons.more_vert_rounded),
                                      ),
                                    ],
                                  ),
                                  PlayButton(
                                    onPressed: () => ref
                                        .watch(
                                            playerControllerProvider.notifier)
                                        .runRadio(
                                            radioId: album.id,
                                            type: MediaType.album),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: album.songs.length,
                                itemBuilder: (context, index) {
                                  final song = album.songs[index];
                                  return MediaCard(
                                    onTap: () {},
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
                                itemCount: album.artists.length,
                                itemBuilder: (context, index) {
                                  final artist = album.artists[index];
                                  return MediaCard(
                                    onTap: () => Navigator.of(context)
                                        .push(ArtistView.route(artist.id)),
                                    image: artist.image,
                                    title: artist.name,
                                    subtitle: artist.type,
                                    explicitContent: false,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            );
          },
          error: (err, st) => ErrorPage(error: err.toString()),
          loading: () => const LoadingPage(),
        );
  }
}
