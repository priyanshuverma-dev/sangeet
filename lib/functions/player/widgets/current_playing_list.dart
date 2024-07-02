import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sangeet/functions/player/controllers/player_controller.dart';
import 'package:sangeet_api/modules/song/models/song_model.dart';

class CurrentPlayingList extends ConsumerStatefulWidget {
  const CurrentPlayingList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlaylistViewState();
}

class _PlaylistViewState extends ConsumerState<CurrentPlayingList> {
  @override
  Widget build(BuildContext context) {
    final player = ref.watch(getAudioPlayer);
    final playlist = ref.watch(playerControllerProvider.notifier).playlist;

    return StreamBuilder<SequenceState?>(
        stream: player.sequenceStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          final sequence = state?.sequence ?? [];

          // final song = sequence[state!.currentIndex].tag as SongModel;
          if (state!.currentIndex == playlist.length - 1) {
            // playlist.removeRange(0, 10);
            // ref
            //     .watch(playerControllerProvider.notifier)
            //     .loadMoreSongs(song: song);
          }

          return Column(children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Current Playing Radio.',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              onReorder: (int oldIndex, int newIndex) {
                if (oldIndex < newIndex) newIndex--;
                playlist.move(oldIndex, newIndex);
              },
              scrollDirection: Axis.vertical,
              itemCount: sequence.length,
              itemBuilder: (context, i) {
                final song = sequence[i].tag as SongModel;
                return Dismissible(
                  key: ValueKey(sequence[i]),
                  background: Container(
                    alignment: Alignment.centerRight,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.delete),
                    ),
                  ),
                  onDismissed: (dismissDirection) {
                    playlist.removeAt(i);
                  },
                  child: ListTile(
                    splashColor: song.accentColor,
                    title: Text(
                        "${song.title} ${i == state.currentIndex ? "(Playing)" : ""}"),
                    subtitle: Text(song.albumName),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Theme.of(context).primaryColorDark,
                      foregroundImage: NetworkImage(song.images[0].url),
                    ),
                    onTap: () {
                      player.seek(Duration.zero, index: i);
                    },
                  ),
                );
              },
            ),
          ]);
        });
    //         Row(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: ClipRRect(
    //                 borderRadius: BorderRadius.circular(8),
    //                 child: Image.network(
    //                   song.images[2].url,
    //                   height: 250,
    //                   width: 250,
    //                 ),
    //               ),
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Text(
    //                 song.title,
    //                 style: const TextStyle(
    //                   fontSize: 30,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ],
    //     );
    //   },
    // );
  }
}

        //   ReorderableListView.builder(
            //     shrinkWrap: true,
            //     onReorder: (int oldIndex, int newIndex) {
            //       if (oldIndex < newIndex) newIndex--;
            //       playlist.move(oldIndex, newIndex);
            //     },
            //     scrollDirection: Axis.vertical,
            //     itemCount: sequence.length,
            //     itemBuilder: (context, i) {
            //       final song = sequence[i].tag as SongModel;
            //       return Dismissible(
            //         key: ValueKey(sequence[i]),
            //         background: Container(
            //           alignment: Alignment.centerRight,
            //           child: const Padding(
            //             padding: EdgeInsets.only(right: 8.0),
            //             child: Icon(Icons.delete),
            //           ),
            //         ),
            //         onDismissed: (dismissDirection) {
            //           playlist.removeAt(i);
            //         },
            //         child: ListTile(
            //           tileColor: i == state!.currentIndex
            //               ? Theme.of(context).primaryColorLight.withOpacity(.4)
            //               : null,
            //           title: Text(
            //               "${song.title} ${i == state.currentIndex ? "(Playing)" : ""}"),
            //           subtitle: Text(song.albumName),
            //           leading: CircleAvatar(
            //             radius: 25,
            //             backgroundColor: Theme.of(context).primaryColorDark,
            //             foregroundImage: NetworkImage(song.images[0].url),
            //           ),
            //           onTap: () {
            //             player.seek(Duration.zero, index: i);
            //           },
            //         ),
            //       );
            //     },
            //   ),
            // ],
  