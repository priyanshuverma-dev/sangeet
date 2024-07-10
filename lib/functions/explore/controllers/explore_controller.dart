import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/api_provider.dart';
import 'package:sangeet_api/models.dart';
import 'package:sangeet_api/sangeet_api.dart';

final exploreControllerProvider =
    StateNotifierProvider<ExploreController, bool>((ref) {
  return ExploreController(
    api: ref.watch(sangeetAPIProvider),
  );
});

final getExploreDataProvider = FutureProvider((ref) {
  final exploreController = ref.watch(exploreControllerProvider.notifier);
  return exploreController.getExploreData();
});

final getRelatedSongsProvider = FutureProvider.family((ref, String id) {
  final exploreController = ref.watch(exploreControllerProvider.notifier);
  return exploreController.getRadio(id);
});
final getTrendingSongsProvider = FutureProvider((ref) {
  final exploreController = ref.watch(exploreControllerProvider.notifier);
  return exploreController.getTrendingSongs();
});

class ExploreController extends StateNotifier<bool> {
  final SangeetAPI _api;
  ExploreController({required SangeetAPI api})
      : _api = api,
        super(false);

  Future<BrowseModel> getExploreData() async {
    final data = await _api.explore.browse();

    if (data == null) {
      throw Error.throwWithStackTrace(
        "Unable to fetch data!",
        StackTrace.current,
      );
    }

    return data;
  }

  Future<BrowseTrendingModel> getTrendingSongs() async {
    final data = await _api.explore.trending();
    if (data == null) {
      throw Error.throwWithStackTrace(
        "Unable to fetch data!",
        StackTrace.current,
      );
    }

    return data;
  }

  Future<SongRadioModel> getRadio(String id) async {
    final data = await _api.song.radio(
      songId: id,
    );

    if (data == null) {
      throw Error.throwWithStackTrace(
        "Unable to fetch data!",
        StackTrace.current,
      );
    }
    return data;
  }
}
