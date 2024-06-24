import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saavn/core/core.dart';
import 'package:saavn/functions/explore/controllers/explore_controller.dart';
import 'package:saavn/functions/player/controllers/player_controller.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: ExploreList(),
    );
  }
}

class ExploreList extends ConsumerWidget {
  const ExploreList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.read(getAudioPlayer);

    return ref.watch(getExploreDataProvider).when(
          data: (data) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SONGS LIST //
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Trending Songs.',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.songs.length,
                  itemBuilder: (context, index) {
                    final song = data.songs[index];
                    return ListTile(
                        title: Text(song.name),
                        subtitle: Text("${song.label} - ${song.year}"),
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: Theme.of(context).primaryColorDark,
                          foregroundImage: NetworkImage(song.image[0].url),
                        ),
                        onTap: () async {
                          if (player.audioSource?.sequence[0].tag.id ==
                              song.id) {
                            return;
                          }

                          ref
                              .read(playerControllerProvider.notifier)
                              .setSong(song: song);
                        });
                  },
                )
                // ARTISTS GRID //
              ],
            );
          },
          error: (error, stackTrace) {
            return ErrorText(
              error: error.toString(),
            );
          },
          loading: () => const Loader(),
        );
  }
}
