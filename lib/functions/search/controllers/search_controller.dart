import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/apis/song_api.dart';
import 'package:sangeet/models/song_model.dart';

final searchControllerProvider =
    StateNotifierProvider<SearchController, bool>((ref) {
  return SearchController(
    songAPI: ref.watch(songAPIProvider),
  );
});

final searchDataProvider = FutureProvider<List<SongModel>>((ref) async {
  return ref.watch(searchControllerProvider.notifier).searchData;
});

class SearchController extends StateNotifier<bool> {
  final SongAPI _songAPI;

  SearchController({required SongAPI songAPI})
      : _songAPI = songAPI,
        super(false);

  // ADD SEARCH METHODS

  List<SongModel> searchData = [];

  Future<void> searchSong({required String query}) async {
    state = true;
    final fetchedsongs = await _songAPI.fetchSearchData(query: query);

    fetchedsongs.fold(
      (l) => throw Error.throwWithStackTrace(l.message, l.stackTrace),
      (r) => searchData = r,
    );

    state = false;
  }
}
