import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savaan/core/core.dart';
import 'package:savaan/functions/explore/controllers/explore_controller.dart';
import 'package:savaan/functions/player/controllers/player_controller.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          ExploreList(),
        ],
      ),
    );
  }
}

class ExploreList extends ConsumerWidget {
  const ExploreList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.read(getAudioPlayer);

    return ref.watch(getExploreDataProvider).when(
          data: (songs) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return ListTile(
                    title: Text(song.name),
                    subtitle: Text("${song.label} - ${song.year}"),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Theme.of(context).primaryColorDark,
                      foregroundImage: NetworkImage(song.image[0].url),
                    ),
                    onTap: () async {
                      if (player.audioSource?.sequence[0].tag.id == song.id) {
                        return;
                      }

                      ref
                          .read(playerControllerProvider.notifier)
                          .setSong(song: song);
                    });
              },
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
