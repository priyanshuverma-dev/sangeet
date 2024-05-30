import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:savaan/core/size_manager.dart';
import 'package:savaan/functions/player/controllers/player_controller.dart';
import 'package:savaan/functions/player/views/common.dart';
import 'package:savaan/functions/player/views/player_view.dart';
import 'package:savaan/models/song_model.dart';

class BottomPlayerSheet extends ConsumerStatefulWidget {
  const BottomPlayerSheet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      BottomPlayerSheetState();
}

class BottomPlayerSheetState extends ConsumerState<BottomPlayerSheet> {
  @override
  Widget build(BuildContext context) {
    final player = ref.watch(getAudioPlayer);

    return StreamBuilder<SequenceState?>(
      stream: player.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(height: AppSize.s0);
        }
        if (state?.sequence.isEmpty ?? true) {
          return const SizedBox();
        }
        final metadata = state!.currentSource!.tag as SongModel;
        return BottomSheet(
          elevation: AppSize.s30,
          onClosing: () {},
          enableDrag: false,
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppSize.s10),
                      topRight: Radius.circular(AppSize.s10),
                    ),
                  ),
                  leading: Image.network(metadata.image[2].url),
                  title: Text(
                    metadata.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    metadata.label,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_up),
                  onTap: () {
                    // Navigator.pushNamed(context, Routes.showSongRoute);
                  },
                ),
                ControlButtons(player),
                StreamBuilder<PositionData>(
                  stream: ref
                      .watch(playerControllerProvider.notifier)
                      .positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return SeekBar(
                      duration: positionData?.duration ?? Duration.zero,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition:
                          positionData?.bufferedPosition ?? Duration.zero,
                      onChangeEnd: (newPosition) {
                        player.seek(newPosition);
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 240.0,
                  child: StreamBuilder<SequenceState?>(
                    stream: player.sequenceStateStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      final sequence = state?.sequence ?? [];
                      return ReorderableListView(
                        onReorder: (int oldIndex, int newIndex) {
                          if (oldIndex < newIndex) newIndex--;
                          // _playlist.move(oldIndex, newIndex);
                        },
                        children: [
                          for (var i = 0; i < sequence.length; i++)
                            Dismissible(
                              key: ValueKey(sequence[i]),
                              background: Container(
                                color: Colors.redAccent,
                                alignment: Alignment.centerRight,
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child:
                                      Icon(Icons.delete, color: Colors.white),
                                ),
                              ),
                              onDismissed: (dismissDirection) {
                                // playlist.removeAt(i);
                              },
                              child: Material(
                                color: i == state!.currentIndex
                                    ? Colors.grey.shade900
                                    : null,
                                child: ListTile(
                                  title: Text(sequence[i].tag.name as String),
                                  onTap: () {
                                    player.seek(Duration.zero, index: i);
                                  },
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
