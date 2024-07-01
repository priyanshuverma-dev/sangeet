import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sangeet/core/core.dart';
import 'package:sangeet/core/utils.dart';
import 'package:sangeet/functions/album/controllers/album_controller.dart';
import 'package:sangeet/functions/album/widgets/album_top_details.dart';

class AlbumView extends ConsumerWidget {
  final String albumId;
  const AlbumView({this.albumId = "", super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ModalRoute.of(context)?.settings.name ?? albumId;

    return ref.watch(albumByIdProvider(name)).when(
          data: (album) {
            return Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(album.playCount),
                  ),
                ],
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: Navigator.of(context).canPop(),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: TextButton.icon(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: const Icon(Icons.arrow_left_rounded),
                                  label: const Text("Back"),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.black12,
                                  ),
                                ),
                              ),
                            ),
                            AlbumTopDetails(album: album),
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
                                  InkWell(
                                    // onTap: () => Navigator.of(context).pop(),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              album.artists[0].image),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Text(
                                            album.artists[0].name,
                                            style: GoogleFonts.caesarDressing()
                                                .copyWith(
                                                    fontSize: 18,
                                                    decoration: TextDecoration
                                                        .underline),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.play_arrow_rounded,
                                      size: 35,
                                      color: Colors.white,
                                    ),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.teal,
                                    ),
                                    splashColor: Color(album.playCount),
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
                                itemCount: album.songs.length,
                                itemBuilder: (context, index) {
                                  final song = album.songs[index];
                                  return ListTile(
                                    onTap: () {},
                                    title: Text(song.title),
                                    subtitle: Text(
                                        "${formatNumber(song.playCount)} listens, ${formatDuration(song.duration)} long"),
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
                        margin: EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(10),
                        ),
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
                              itemCount: album.artists.length,
                              itemBuilder: (context, index) {
                                final artist = album.artists[index];
                                return ListTile(
                                  onTap: () {},
                                  title: Text(artist.name),
                                  subtitle: Text(artist.type),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(artist.image),
                                  ),
                                );
                              },
                            ),
                          ],
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
