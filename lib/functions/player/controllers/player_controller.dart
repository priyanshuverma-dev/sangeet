import 'package:audio_session/audio_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:savaan/functions/player/views/common.dart';
import 'package:savaan/models/song_model.dart';

class PlayerController extends StateNotifier {
  final _player = AudioPlayer();

  PlayerController() : super(false);

  get getPlayer => _player;
  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  void initializePlayer() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
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
      if (state == ProcessingState.completed) {
        // _showItemFinished(_player.currentIndex);
      }
    });
  }


  void setSong({required SongModel song})async{

    _player.setUrl(AudioSource.uri(Uri.parse(song.url)))

  }



}
