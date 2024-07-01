import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sangeet/core/api_provider.dart';
import 'package:sangeet/core/core.dart';
import 'package:sangeet/frame/commons.dart';
import 'package:sangeet/functions/explore/controllers/explore_controller.dart';
import 'package:sangeet/functions/player/widgets/common.dart';
import 'package:sangeet/functions/settings/controllers/settings_controller.dart';
import 'package:sangeet_api/modules/song/models/song_model.dart';
import 'package:sangeet_api/sangeet_api.dart';

final playerControllerProvider =
    StateNotifierProvider<PlayerController, bool>((ref) {
  return PlayerController(
    exploreController: ref.watch(exploreControllerProvider.notifier),
    settingsController: ref.watch(settingsControllerProvider.notifier),
    api: ref.watch(sangeetAPIProvider),
  );
});

final getAudioPlayer =
    Provider((ref) => ref.watch(playerControllerProvider.notifier).getPlayer);

class PlayerController extends StateNotifier<bool> {
  final ExploreController _exploreController;
  final SettingsController _settingsController;
  final SangeetAPI _api;

  final _player = AudioPlayer();
  final playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(
      random: Random(),
    ),
    children: [],
  );

  PlayerController({
    required ExploreController exploreController,
    required SettingsController settingsController,
    required SangeetAPI api,
  })  : _exploreController = exploreController,
        _settingsController = settingsController,
        _api = api,
        super(false);

  AudioPlayer get getPlayer => _player;
  ConcatenatingAudioSource get getplaylist => playlist;

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  Future<void> runRadio({
    required String radioId,
    SongModel? song,
    required MediaType type,
    bool featured = false,
  }) async {
    try {
      await playlist.clear();
      final quality = await _settingsController.getSongQuality();

      if (type == MediaType.song) {
        final songsObjects = await _exploreController.getRadio(radioId, false);
        songsObjects.songs.insert(0, song!);
        for (var i = 0; i < songsObjects.songs.length; i++) {
          final uri = songsObjects.songs[i].urls
              .where((element) => element.quality == quality.name)
              .toList()[0]
              .url;

          playlist
              .add(AudioSource.uri(Uri.parse(uri), tag: songsObjects.songs[i]));
        }
        await _player.setAudioSource(playlist, preload: true);
      }

      await _player.play();
    } on PlayerException catch (e) {
      if (kDebugMode) {
        print("Error message: ${e.message}");
      }
    } on PlayerInterruptedException catch (e) {
      if (kDebugMode) {
        print("Connection aborted: ${e.message}");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> setSong({required SongModel song}) async {
    try {
      await playlist.clear();
      final quality = await _settingsController.getSongQuality();
      final songsObjects = await _exploreController.getRadio(song.id, false);

      songsObjects.songs.insert(0, song);

      for (var i = 0; i < songsObjects.songs.length; i++) {
        final uri = songsObjects.songs[i].urls
            .where((element) => element.quality == quality.name)
            .toList()[0]
            .url;

        playlist
            .add(AudioSource.uri(Uri.parse(uri), tag: songsObjects.songs[i]));
      }

      await _player.setAudioSource(playlist,
          preload: kIsWeb || defaultTargetPlatform != TargetPlatform.linux);

      await _player.play();
    } on PlayerException catch (e) {
      // iOS/macOS: maps to NSError.code
      // Android: maps to ExoPlayerException.type
      // Web: maps to MediaError.code
      if (kDebugMode) {
        print("Error code: ${e.code}");
        // iOS/macOS: maps to NSError.localizedDescription
        // Android: maps to ExoPlaybackException.getMessage()
        // Web: a generic message
        print("Error message: ${e.message}");
      }
    } on PlayerInterruptedException catch (e) {
      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
      if (kDebugMode) {
        print("Connection aborted: ${e.message}");
      }
    } catch (e) {
      // Fallback for all errors
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> loadMoreSongs({required SongModel song}) async {
    try {
      final quality = await _settingsController.getSongQuality();
      final songsObjects = await _exploreController.getRadio(song.id, false);

      for (var i = 0; i < songsObjects.songs.length; i++) {
        final uri = songsObjects.songs[i].urls
            .where((element) => element.quality == quality.name)
            .toList()[0]
            .url;

        playlist
            .add(AudioSource.uri(Uri.parse(uri), tag: songsObjects.songs[i]));
      }
    } on PlayerException catch (e) {
      // iOS/macOS: maps to NSError.code
      // Android: maps to ExoPlayerException.type
      // Web: maps to MediaError.code
      if (kDebugMode) {
        print("Error code: ${e.code}");
        // iOS/macOS: maps to NSError.localizedDescription
        // Android: maps to ExoPlaybackException.getMessage()
        // Web: a generic message
        print("Error message: ${e.message}");
      }
    } on PlayerInterruptedException catch (e) {
      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
      if (kDebugMode) {
        print("Connection aborted: ${e.message}");
      }
    } catch (e) {
      // Fallback for all errors
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
  }
}
