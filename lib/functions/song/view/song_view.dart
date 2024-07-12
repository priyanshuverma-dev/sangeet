import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/core.dart';
import 'package:sangeet/core/skeletions/screen_loading_skeleton.dart';
import 'package:sangeet/core/widgets/blur_image_container.dart';
import 'package:sangeet/core/widgets/media_card.dart';
import 'package:sangeet/core/widgets/play_button.dart';
import 'package:sangeet/core/widgets/related_songs_list.dart';
import 'package:sangeet/core/widgets/split_view_container.dart';
import 'package:sangeet/core/widgets/top_details.dart';
import 'package:sangeet/functions/artist/view/artist_view.dart';
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
              isAsset: false,
              image: song.images[2].url,
              child: SplitViewContainer(
                leftChild: Column(
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
                      thirdLine: song.copyright,
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
                              const BackButton(),
                              IconButton(
                                tooltip: "More",
                                onPressed: () {},
                                icon: const Icon(Icons.more_vert_rounded),
                              ),
                            ],
                          ),
                          const Text(
                            'Song',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PlayButton(
                            onPressed: () => ref
                                .watch(playerControllerProvider.notifier)
                                .runRadio(
                                  radioId: song.id,
                                  type: MediaType.song,
                                ),
                          )
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
                    RelatedSongsList(songId: song.id),
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
                      physics: const BouncingScrollPhysics(),
                      itemCount: song.artists.length,
                      itemBuilder: (context, index) {
                        final artist = song.artists[index];
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
