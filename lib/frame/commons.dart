import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savaan/functions/explore/views/explore_view.dart';
import 'package:savaan/functions/player/views/playlist_view.dart';

final appScreenConfigProvider =
    StateNotifierProvider<AppScreenConfig, Screens>((ref) {
  return AppScreenConfig();
});

enum Screens {
  explore(ExploreView()),
  playlist(PlaylistView());

  final Widget screen;
  const Screens(this.screen);
}

class AppScreenConfig extends StateNotifier<Screens> {
  AppScreenConfig() : super(Screens.explore);

  void goto({required Screens screen}) {
    state = screen;
  }
}
