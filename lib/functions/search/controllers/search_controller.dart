import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/api_provider.dart';
import 'package:sangeet_api/models.dart';
import 'package:sangeet_api/sangeet_api.dart';

final searchControllerProvider =
    StateNotifierProvider<SearchController, bool>((ref) {
  return SearchController(
    api: ref.watch(sangeetAPIProvider),
  );
});

final searchDataProvider = FutureProvider<SearchResultModel?>((ref) async {
  final r = ref.watch(searchControllerProvider.notifier).searchData;
  // if (r == null) {
  //   throw Error.throwWithStackTrace("Can't find right now", StackTrace.empty);
  // }
  return r;
});

class SearchController extends StateNotifier<bool> {
  final SangeetAPI _api;
  SearchController({required SangeetAPI api})
      : _api = api,
        super(false);

  // ADD SEARCH METHODS

  SearchResultModel? searchData;

  Future<void> searchSong({required String query}) async {
    final results = await _api.search.global(query: query);
    if (results == null) {
      searchData = null;
      throw Error.throwWithStackTrace("Can't find right now", StackTrace.empty);
    }

    searchData = results;
  }
}
