import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/constants.dart';
import 'package:sangeet_api/common/utils.dart';
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

  Future<SongQuality> getSongQuality() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getString(SharedPrefs.songQuality);
    if (val == null) return SongQuality.v320kbps;
    var quality = SongQuality.values
        .where((element) => element.quality == val)
        .toList()[0];

    return quality;
  }
}
