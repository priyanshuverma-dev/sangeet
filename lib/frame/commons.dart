import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/functions/explore/views/explore_view.dart';
import 'package:sangeet/functions/search/views/search_view.dart';
import 'package:sangeet/functions/settings/views/settings_view.dart';

final appScreenConfigProvider =
    StateNotifierProvider<AppScreenConfig, Screens>((ref) {
  return AppScreenConfig();
});

enum Screens {
  explore(
    AppScreen(
      name: "Explore Sangeet",
      index: 0,
      view: ExploreView(),
    ),
  ),
  search(
    AppScreen(
      name: "Search Songs",
      index: 1,
      view: SearchView(),
    ),
  ),
  settings(
    AppScreen(
      name: "Settings",
      index: 2,
      view: SettingsView(),
    ),
  );

  final AppScreen screen;
  const Screens(this.screen);
}

class AppScreenConfig extends StateNotifier<Screens> {
  AppScreenConfig() : super(Screens.explore);

  void onIndex(int idx) {
    state = Screens.values.firstWhere((e) => e.index == idx);
  }

  void goto({
    required Screens screen,
    Map<String, String> parameters = const {},
  }) {
    state = screen;
  }
}

class AppScreen {
  final Widget view;
  final String name;
  final int index;

  const AppScreen({
    required this.view,
    required this.name,
    required this.index,
  });
}
