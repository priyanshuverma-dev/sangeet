import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savaan/apis/song_api.dart';
import 'package:savaan/models/song_model.dart';

final exploreControllerProvider =
    StateNotifierProvider<ExploreController, bool>((ref) {
  return ExploreController(songAPI: ref.watch(songAPIProvider));
});

final getExploreDataProvider = FutureProvider((ref) {
  final exploreController = ref.watch(exploreControllerProvider.notifier);
  return exploreController.getExploreData();
});

class ExploreController extends StateNotifier<bool> {
  final SongAPI _songAPI;
  ExploreController({required SongAPI songAPI})
      : _songAPI = songAPI,
        super(false);

  Future<List<SongModel>> getExploreData() async {
    List<SongModel> songs = [];
    final res = await _songAPI.fetchInitData();

    res.fold((l) {
      if (kDebugMode) {
        print("INIT EXPLORE DATA ERROR: ${l.message}");
      }
      throw Error.throwWithStackTrace(l.message, l.stackTrace);
    }, (r) => songs = r);
    return songs;
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
