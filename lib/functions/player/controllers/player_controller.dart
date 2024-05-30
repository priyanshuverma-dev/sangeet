import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:savaan/functions/player/views/common.dart';
import 'package:savaan/models/helpers/download_quality.dart';
import 'package:savaan/models/song_model.dart';

final playerControllerProvider =
    StateNotifierProvider<PlayerController, bool>((ref) {
  return PlayerController();
});

final getAudioPlayer = Provider.autoDispose(
    (ref) => ref.watch(playerControllerProvider.notifier).getPlayer);

class PlayerController extends StateNotifier<bool> {
  final _player = AudioPlayer();

  PlayerController() : super(false);

  @override
  void initState() {
    initializePlayer();
    // super.initState();
  }

  AudioPlayer get getPlayer => _player;
  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  void initializePlayer() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      // _playlist = await ref.read(getPlaylistProvider(SongModel.empty()));
      // print(_player);
      // await _player.setAudioSource(_playlist,
      //     preload: kIsWeb || defaultTargetPlatform != TargetPlatform.linux);
    } on PlayerException catch (e) {
      print("Error loading audio source: $e");
    }

    _player.positionDiscontinuityStream.listen((discontinuity) {
      if (discontinuity.reason == PositionDiscontinuityReason.autoAdvance) {
        // _showItemFinished(discontinuity.previousEvent.currentIndex);
      }
    });

    _player.processingStateStream.listen((state) {
      print("PLAYER PROCESSING STATE: $state");
      if (state == ProcessingState.completed) {
        // _showItemFinished(_player.currentIndex);
      }
    });
  }

  void setSong({required SongModel song}) async {
    await _player.setAudioSource(
      AudioSource.uri(
          Uri.parse(song.downloadUrl
              .where((element) => element.quality == SongQualityType.high)
              .toList()[0]
              .url),
          tag: song),
      preload: kIsWeb || defaultTargetPlatform != TargetPlatform.linux,
    );

    // await _player.play();
  }
}
