import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savaan/functions/explore/apis/explore_api.dart';
import 'package:savaan/models/song_model.dart';

final exploreControllerProvider =
    StateNotifierProvider<ExploreController, bool>((ref) {
  return ExploreController(exploreAPI: ref.watch(exploreAPIProvider));
});

final getExploreDataProvider = FutureProvider((ref) {
  final exploreController = ref.watch(exploreControllerProvider.notifier);
  return exploreController.getExploreData();
});

class ExploreController extends StateNotifier<bool> {
  final ExploreAPI _exploreAPI;
  ExploreController({required ExploreAPI exploreAPI})
      : _exploreAPI = exploreAPI,
        super(false);

  Future<List<SongModel>> getExploreData() async {
    late List<SongModel> songs;
    state = true;
    final res = await _exploreAPI.fetchInitData();
    res.fold((l) {}, (r) => songs = r);
    state = false;
    return songs;
  }
}
