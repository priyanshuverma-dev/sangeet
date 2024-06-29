import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/core.dart';
import 'package:sangeet/functions/player/controllers/player_controller.dart';
import 'package:sangeet/functions/search/controllers/search_controller.dart';
import 'package:sangeet/functions/search/widgets/searchbar.dart';
import 'package:sangeet/functions/search/widgets/song_tile.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final TextEditingController _searchController = TextEditingController();

  void search(String q) async {
    await ref.watch(searchControllerProvider.notifier).searchSong(query: q);
    ref.invalidate(searchDataProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BaseSearchBar(
          controller: _searchController,
          onPressed: () => search(_searchController.text),
          onSubmit: (value) => search(value),
        ),
        Expanded(
          child: (ref.watch(searchDataProvider).when(
                skipLoadingOnRefresh: false,
                data: (songs) {
                  if (songs.isEmpty) {
                    return const Center(
                      child: Text('Search results will be displayed here!'),
                    );
                  }

                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      for (final song in songs)
                        SearchSongTile(
                          song: song,
                          onTap: () => ref
                              .read(playerControllerProvider.notifier)
                              .setSong(song: song),
                        ),
                      const Center(
                        child: Text(
                            'Only 24 results because this feature is in test phase.'),
                      )
                    ],
                  );
                },
                error: (error, st) => ErrorPage(error: error.toString()),
                loading: () => const Loader(),
              )),
        ),
      ],
    );
  }
}
