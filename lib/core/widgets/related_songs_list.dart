import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/core.dart';
import 'package:sangeet/core/skeletions/media_loading_skeletion.dart';
import 'package:sangeet/functions/explore/controllers/explore_controller.dart';
import 'package:sangeet/functions/player/controllers/player_controller.dart';
import 'package:sangeet/functions/song/view/song_view.dart';

import 'media_card.dart';

class RelatedSongsList extends ConsumerWidget {
  final String songId;
  const RelatedSongsList({required this.songId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(playerControllerProvider.notifier);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ref.watch(getRelatedSongsProvider(songId)).when(
            data: (songlist) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: songlist.songs.length,
                itemBuilder: (context, index) {
                  final song = songlist.songs[index];
                  return MediaCard(
                    onDoubleTap: () => controller.runRadio(
                      radioId: song.id,
                      type: MediaType.song,
                      prevSongs: songlist.songs,
                      playCurrent: true,
                    ),
                    onTap: () => Navigator.of(context).push(
                      SongView.route(song.id),
                    ),
                    contextMenu: [
                      ContextMenuButtonConfig(
                        icon: const Icon(Icons.queue_music_rounded),
                        "Add in Queue",
                        onPressed: () => controller.addSongToQueue(song: song),
                      ),
                      ContextMenuButtonConfig(
                        icon: const Icon(Icons.play_circle_filled_rounded),
                        "Play Next",
                        onPressed: () => controller.addSongToNext(song: song),
                      )
                    ],
                    image: song.images[1].url,
                    title: song.title,
                    subtitle:
                        "${formatNumber(song.playCount)} listens, ${song.label}",
                    explicitContent: song.explicitContent,
                  );
                },
              );
            },
            error: (er, st) => ErrorPage(error: er.toString()),
            loading: () => const MediaLoader(),
          ),
    );
  }
}
