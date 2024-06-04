import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saavn/functions/explore/views/explore_view.dart';
import 'package:saavn/functions/player/views/playlist_view.dart';
import 'package:saavn/functions/settings/views/settings_view.dart';

final appScreenConfigProvider =
    StateNotifierProvider<AppScreenConfig, Screens>((ref) {
  return AppScreenConfig();
});

enum Screens {
  explore(
    AppScreen(
      name: "Explore Saavn",
      view: ExploreView(),
    ),
  ),
  playlist(
    AppScreen(
      name: "Playlists",
      view: PlaylistView(),
    ),
  ),
  settings(
    AppScreen(
      name: "Settings",
      view: SettingsView(),
    ),
  );

  final AppScreen screen;
  const Screens(this.screen);
}

class AppScreenConfig extends StateNotifier<Screens> {
  AppScreenConfig() : super(Screens.explore);

  void goto({required Screens screen}) {
    state = screen;
  }
}

class AppScreen {
  final Widget view;
  final String name;

  const AppScreen({
    required this.view,
    required this.name,
  });
}
