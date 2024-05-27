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
  return exploreController.getExploreData();
});
final getPlaylistProvider = Provider((ref) async {
  final exploreController = ref.watch(exploreControllerProvider.notifier);
  final songsObjects = await exploreController.getExploreData();
  final playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: [],
  );

  for (var i = 0; i < songsObjects.length; i++) {
    final uri = songsObjects[i]
        .downloadUrl
        .where((element) => element.quality == SongQualityType.high)
        .toList()[0]
        .url;

    playlist.add(AudioSource.uri(Uri.parse(uri)));
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
    res.fold((l) {}, (r) => songs = r);
    return songs;
  }
}
