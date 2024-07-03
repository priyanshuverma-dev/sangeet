import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/core.dart';
import 'package:sangeet/core/utils.dart';
import 'package:sangeet/core/widgets/blur_image_container.dart';
import 'package:sangeet/core/widgets/top_details.dart';
import 'package:sangeet/functions/album/view/album_view.dart';
import 'package:sangeet/functions/artist/controller/artist_controller.dart';
import 'package:sangeet/functions/player/controllers/player_controller.dart';
import 'package:sangeet/functions/song/view/song_view.dart';

class ArtistView extends ConsumerWidget {
  static route(String id) => MaterialPageRoute(
        builder: (context) => ArtistView(
          artistId: id,
        ),
      );

  final String artistId;
  const ArtistView({this.artistId = "", super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ModalRoute.of(context)?.settings.name ?? artistId;

    return ref.watch(artistByIdProvider(name)).when(
          data: (artist) {
            return BlurImageContainer(
              image: artist.images[2].url,
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
                              image: artist.images[2].url,
                              subtitle: artist.subtitle,
                              title: artist.name,
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
                                  Visibility(
                                    visible: Navigator.of(context).canPop(),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: TextButton.icon(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        icon: const Icon(
                                            Icons.arrow_left_rounded),
                                        label: const Text("Back"),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.black12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => ref
                                        .watch(
                                            playerControllerProvider.notifier)
                                        .runRadio(
                                          radioId: artist.id,
                                          type: MediaType.artist,
                                          prevSongs: artist.topSongs,
                                        ),
                                    icon: const Icon(
                                      Icons.play_arrow_rounded,
                                      size: 35,
                                      color: Colors.white,
                                    ),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.teal,
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
                                itemCount: artist.topSongs.length,
                                itemBuilder: (context, index) {
                                  final song = artist.topSongs[index];
                                  return ListTile(
                                    onTap: () => Navigator.of(context).push(
                                      SongView.route(song.id),
                                    ),
                                    title: Text(song.title),
                                    subtitle: Text(
                                        "${formatDuration(song.duration)}, ${song.label}"),
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(song.images[1].url),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Top Albums.',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: artist.topAlbums.length,
                              itemBuilder: (context, index) {
                                final album = artist.topAlbums[index];
                                return ListTile(
                                  onTap: () => Navigator.of(context)
                                      .push(AlbumView.route(album.id)),
                                  title: Text(album.title),
                                  subtitle: Text(album.subtitle),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      album.images[1].url,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
          error: (err, st) => ErrorPage(error: err.toString()),
          loading: () => const LoadingPage(),
        );
  }
}
