import 'package:flutter_riverpod/flutter_riverpod.dart';

final appScreenConfigProvider =
    StateNotifierProvider<AppScreenConfig, int>((ref) {
  return AppScreenConfig();
});

class AppScreenConfig extends StateNotifier<int> {
  AppScreenConfig() : super(0);

  void onIndex(int idx) {
    state = idx;
  }
}
