import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sangeet/core/core.dart';
import 'package:sangeet/core/utils.dart';
import 'package:sangeet/functions/player/controllers/player_controller.dart';
import 'package:sangeet/functions/playlist/controllers/playlist_controller.dart';
import 'package:sangeet/functions/playlist/widgets/playlist_top_details.dart';

class PlaylistView extends ConsumerWidget {
  static route(String id) => MaterialPageRoute(
        builder: (context) => PlaylistView(
          playlistId: id,
        ),
      );
  final String playlistId;
  const PlaylistView({this.playlistId = "", super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ModalRoute.of(context)?.settings.name ?? playlistId;

    return ref.watch(playlistByIdProvider(name)).when(
          data: (playlist) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(playlist.images[2].url),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: Navigator.of(context).canPop(),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: TextButton.icon(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      icon:
                                          const Icon(Icons.arrow_left_rounded),
                                      label: const Text("Back"),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.black12,
                                      ),
                                    ),
                                  ),
                                ),
                                PlaylistTopDetails(playlist: playlist),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  playlist.artists[0].image),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4),
                                              child: Text(
                                                playlist.artists[0].name,
                                                style:
                                                    GoogleFonts.caesarDressing()
                                                        .copyWith(
                                                            fontSize: 18,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => ref
                                            .watch(playerControllerProvider
                                                .notifier)
                                            .runRadio(
                                                radioId: playlist.id,
                                                type: MediaType.playlist),
                                        icon: const Icon(
                                          Icons.play_arrow_rounded,
                                          size: 35,
                                          color: Colors.white,
                                        ),
                                        style: IconButton.styleFrom(
                                          backgroundColor: Colors.teal,
                                        ),
                                        splashColor: Color(playlist.playCount),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: playlist.songs.length,
                                    itemBuilder: (context, index) {
                                      final song = playlist.songs[index];
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
                                  itemCount: playlist.artists.length,
                                  itemBuilder: (context, index) {
                                    final artist = playlist.artists[index];
                                    return ListTile(
                                      onTap: () {},
                                      title: Text(artist.name),
                                      subtitle: Text(artist.role),
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(artist.image),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          error: (err, st) => ErrorPage(error: err.toString()),
          loading: () => const LoadingPage(),
        );
  }
}
