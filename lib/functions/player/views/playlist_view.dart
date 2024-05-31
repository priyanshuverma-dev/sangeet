import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:savaan/functions/player/controllers/player_controller.dart';
import 'package:savaan/models/song_metadata.dart';

class PlaylistView extends ConsumerStatefulWidget {
  const PlaylistView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlaylistViewState();
}

class _PlaylistViewState extends ConsumerState<PlaylistView> {
  @override
  Widget build(BuildContext context) {
    final player = ref.watch(getAudioPlayer);
    final playlist = ref.watch(playerControllerProvider.notifier).playlist;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
                border: Border(
              bottom: BorderSide(
                color: Colors.black12,
                width: 4,
              ),
            )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                StreamBuilder<LoopMode>(
                  stream: player.loopModeStream,
                  builder: (context, snapshot) {
                    final loopMode = snapshot.data ?? LoopMode.off;
                    const icons = [
                      Icon(Icons.repeat, color: Colors.grey),
                      Icon(Icons.repeat, color: Colors.orange),
                      Icon(Icons.repeat_one, color: Colors.orange),
                    ];
                    const cycleModes = [
                      LoopMode.off,
                      LoopMode.all,
                      LoopMode.one,
                    ];
                    final index = cycleModes.indexOf(loopMode);
                    return IconButton(
                      icon: icons[index],
                      onPressed: () {
                        player.setLoopMode(cycleModes[
                            (cycleModes.indexOf(loopMode) + 1) %
                                cycleModes.length]);
                      },
                    );
                  },
                ),
                Expanded(
                  child: Text(
                    "Radio Playlist",
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                StreamBuilder<bool>(
                  stream: player.shuffleModeEnabledStream,
                  builder: (context, snapshot) {
                    final shuffleModeEnabled = snapshot.data ?? false;
                    return IconButton(
                      icon: shuffleModeEnabled
                          ? const Icon(Icons.shuffle, color: Colors.orange)
                          : const Icon(Icons.shuffle, color: Colors.grey),
                      onPressed: () async {
                        final enable = !shuffleModeEnabled;
                        if (enable) {
                          await player.shuffle();
                        }
                        await player.setShuffleModeEnabled(enable);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          StreamBuilder<SequenceState?>(
            stream: player.sequenceStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              final sequence = state?.sequence ?? [];

              return ReorderableListView.builder(
                shrinkWrap: true,
                onReorder: (int oldIndex, int newIndex) {
                  if (oldIndex < newIndex) newIndex--;
                  playlist.move(oldIndex, newIndex);
                },
                itemCount: sequence.length,
                itemBuilder: (context, i) {
                  final song = sequence[i].tag as SongMetadata;
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
                      title: Text(song.name),
                      subtitle: Text("${song.label} - ${song.year}"),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Theme.of(context).primaryColorDark,
                        foregroundImage: NetworkImage(song.image[0].url),
                      ),
                      onTap: () {
                        player.seek(Duration.zero, index: i);
                      },
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
