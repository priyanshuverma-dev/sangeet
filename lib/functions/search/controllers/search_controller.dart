import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet_api/models.dart';

final searchControllerProvider =
    StateNotifierProvider<SearchController, bool>((ref) {
  return SearchController();
});

final searchDataProvider = FutureProvider<List<SongModel>>((ref) async {
  return ref.watch(searchControllerProvider.notifier).searchData;
});

class SearchController extends StateNotifier<bool> {
  SearchController() : super(false);

  // ADD SEARCH METHODS

  List<SongModel> searchData = [];

  Future<void> searchSong({required String query}) async {}
}
