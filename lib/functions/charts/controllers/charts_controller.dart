import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/api_provider.dart';
import 'package:sangeet_api/models.dart';
import 'package:sangeet_api/sangeet_api.dart';

final chartControllerProvider =
    StateNotifierProvider<AlbumController, bool>((ref) {
  return AlbumController(
    api: ref.watch(sangeetAPIProvider),
  );
});

final chartByIdProvider =
    FutureProvider.family<PlaylistModel, String>((ref, String token) async {
  return ref
      .watch(chartControllerProvider.notifier)
      .fetchChartById(token: token);
});

class AlbumController extends StateNotifier<bool> {
  final SangeetAPI _api;
  AlbumController({required SangeetAPI api})
      : _api = api,
        super(false);

  Future<PlaylistModel> fetchChartById({required String token}) async {
    final album = await _api.explore.chart(token: token);

    if (album == null) {
      throw Error.throwWithStackTrace("Playlist not found", StackTrace.empty);
    }
    final accentColor = await ColorScheme.fromImageProvider(
      provider: NetworkImage(album.images[0].url),
      brightness: Brightness.dark,
    );

    final s = album.copyWith(
      playCount: accentColor.background.value,
    );

    return s;
  }
}
