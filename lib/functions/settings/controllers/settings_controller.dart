import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saavn/core/constants.dart';
import 'package:saavn/models/helpers/download_quality.dart';
import 'package:shared_preferences/shared_preferences.dart';

final songQualityProvider = FutureProvider((ref) {
  return ref.watch(settingsControllerProvider.notifier).getSongQuality();
});

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, bool>((ref) {
  return SettingsController();
});

class SettingsController extends StateNotifier<bool> {
  SettingsController() : super(false);

  // ADD METHODS

  // SongQualityType get songQuality => setSongQuality();

  Future<SongQualityType> getSongQuality() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getString(SharedPrefs.songQuality);
    print("SETTED: $val");
    if (val == null) return SongQualityType.high;
    var quality = SongQualityType.values
        .where((element) => element.type == val)
        .toList()[0];

    return quality;
  }
}
