import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/core.dart';
import 'package:sangeet/core/utils.dart';
import 'package:sangeet/core/widgets/blur_image_container.dart';
import 'package:sangeet/core/widgets/top_details.dart';
import 'package:sangeet/functions/artist/view/artist_view.dart';
import 'package:sangeet/functions/explore/controllers/explore_controller.dart';
import 'package:sangeet/functions/player/controllers/player_controller.dart';
import 'package:sangeet/functions/song/controllers/song_controller.dart';

class SongView extends ConsumerStatefulWidget {
  static route(String id) => MaterialPageRoute(
        builder: (context) => SongView(
          songId: id,
        ),
      );
  final String songId;
  const SongView({this.songId = "", super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SongViewState();
}

class _SongViewState extends ConsumerState<SongView> {
  @override
  Widget build(BuildContext context) {
    final name = ModalRoute.of(context)?.settings.name ?? widget.songId;

    return ref.watch(songByIdProvider(name)).when(
          data: (song) {
            return BlurImageContainer(
              image: song.images[2].url,
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
                              image: song.images[2].url,
                              subtitle: song.subtitle,
                              title: song.title,
                              badgeBackgroundColor: song.explicitContent
                                  ? Colors.teal
                                  : Colors.transparent,
                              badge: Visibility(
                                visible: song.explicitContent,
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
                                          radioId: song.id,
                                          type: MediaType.song,
                                        ),
                                    icon: const Icon(
                                      Icons.play_arrow_rounded,
                                      size: 35,
                                      color: Colors.white,
                                    ),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.teal,
                                    ),
                                    splashColor: song.accentColor,
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'Related Songs.',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: ref
                                  .watch(getRelatedSongsProvider(song.id))
                                  .when(
                                    data: (sug) {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemCount: sug.songs.length,
                                        itemBuilder: (context, index) {
                                          final song = sug.songs[index];
                                          return ListTile(
                                            onTap: () {},
                                            title: Text(song.title),
                                            subtitle: Text(
                                              "${formatNumber(song.playCount)} listens, ${formatDuration(song.duration)} long",
                                            ),
                                            leading: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                song.images[1].url,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    error: (er, st) =>
                                        ErrorPage(error: er.toString()),
                                    loading: () => const Loader(),
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
                                    onTap: () => Navigator.of(context).push(
                                      ArtistView.route(artist.id),
                                    ),
                                    title: Text(artist.name),
                                    subtitle: Text(artist.role),
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(artist.image),
                                    ),
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
