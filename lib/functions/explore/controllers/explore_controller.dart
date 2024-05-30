import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:savaan/functions/explore/apis/explore_api.dart';
import 'package:savaan/models/helpers/download_quality.dart';
import 'package:savaan/models/song_model.dart';

final exploreControllerProvider =
    StateNotifierProvider<ExploreController, bool>((ref) {
  return ExploreController(exploreAPI: ref.watch(exploreAPIProvider));
});

final getExploreDataProvider = FutureProvider((ref) {
  final exploreController = ref.watch(exploreControllerProvider.notifier);
  print("songs loading");
  return exploreController.getExploreData();
});

final getPlaylistProvider = Provider.family((ref, SongModel song) async {
  final exploreController = ref.watch(exploreControllerProvider.notifier);
  final songsObjects =
      await exploreController.getSongRecommendationData(song.id);
  final playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: [],
  );
  songsObjects.add(song);

  for (var i = 0; i < songsObjects.length; i++) {
    final uri = songsObjects[i]
        .downloadUrl
        .where((element) => element.quality == SongQualityType.high)
        .toList()[0]
        .url;

    playlist.add(AudioSource.uri(Uri.parse(uri), tag: songsObjects[i]));
  }
  return playlist;
});

class ExploreController extends StateNotifier<bool> {
  final ExploreAPI _exploreAPI;
  ExploreController({required ExploreAPI exploreAPI})
      : _exploreAPI = exploreAPI,
        super(false);

  Future<List<SongModel>> getExploreData() async {
    List<SongModel> songs = [];
    final res = await _exploreAPI.fetchInitData();

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
    print('RECOMMENDED');
    final res = await _exploreAPI.fetchSongRecommedationData(id: id);
    print(res);
    res.fold((l) {
      if (kDebugMode) {
        print("RECOMMENDED EXPLORE DATA ERROR: ${l.message}");
      }
    }, (r) => songs = r);
    return songs;
  }
}
