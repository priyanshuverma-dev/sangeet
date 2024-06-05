import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saavn/apis/song_api.dart';
import 'package:saavn/models/song_model.dart';

final searchControllerProvider =
    StateNotifierProvider<SearchController, bool>((ref) {
  return SearchController(
    songAPI: ref.watch(songAPIProvider),
  );
});

class SearchController extends StateNotifier<bool> {
  final SongAPI _songAPI;

  SearchController({required SongAPI songAPI})
      : _songAPI = songAPI,
        super(false);

  // ADD SEARCH METHODS

  Future<List<SongModel>> searchSong({required String query}) async {
    List<SongModel> songs = [];
    final fetchedsongs = await _songAPI.fetchSearchData(query: query);

    fetchedsongs.fold((l) {
      throw Error.throwWithStackTrace(l.message, l.stackTrace);
    }, (r) => songs = r);

    return songs;
  }
}
