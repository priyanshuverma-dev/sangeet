import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saavn/apis/artist_api.dart';
import 'package:saavn/apis/song_api.dart';
import 'package:saavn/models/artists/sub_artist_model.dart';
import 'package:saavn/models/explore_model.dart';
import 'package:saavn/models/song_model.dart';

final exploreControllerProvider =
    StateNotifierProvider<ExploreController, bool>((ref) {
  return ExploreController(
    songAPI: ref.watch(songAPIProvider),
    artistAPI: ref.watch(artistAPIProvider),
  );
});

final getExploreDataProvider = FutureProvider((ref) {
  final exploreController = ref.watch(exploreControllerProvider.notifier);
  return exploreController.getExploreData();
});

class ExploreController extends StateNotifier<bool> {
  final SongAPI _songAPI;
  final ArtistAPI _artistAPI;
  ExploreController({required SongAPI songAPI, required ArtistAPI artistAPI})
      : _songAPI = songAPI,
        _artistAPI = artistAPI,
        super(false);

  Future<ExploreModel> getExploreData() async {
    List<SongModel> songs = [];
    List<SubArtistModel> artists = [];
    final fetchedsongs = await _songAPI.fetchInitData();
    final fetchedArtists = await _artistAPI.fetchInitArtists();

    fetchedsongs.fold((l) {
      throw Error.throwWithStackTrace(l.message, l.stackTrace);
    }, (r) => songs = r);

    fetchedArtists.fold((l) {
      throw Error.throwWithStackTrace(l.message, l.stackTrace);
    }, (r) => artists = r);

    final data = ExploreModel(
      songs: songs,
      artists: artists,
    );

    return data;
  }

  Future<List<SongModel>> getSongRecommendationData(String id) async {
    List<SongModel> songs = [];

    final res = await _songAPI.fetchSongRecommedationData(id: id);

    res.fold((l) {
      if (kDebugMode) {
        print("RECOMMENDED EXPLORE DATA ERROR: ${l.message}");
      }
    }, (r) => songs = r);
    return songs;
  }
}
