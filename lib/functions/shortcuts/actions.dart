import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sangeet/functions/notification/song_notifications.dart';
import 'package:sangeet/models/song_model.dart';

enum KeyAction {
  playPauseMusic,
  nextTrack,
  prevTrack,
  openPlaylist,
}

class BaseIntent extends Intent {
  final KeyAction key;
  const BaseIntent({
    required KeyAction keyAction,
  }) : key = keyAction;
}

class SongActions extends Action<BaseIntent> {
  final AudioPlayer _player;
  final SongNotifications notifications = SongNotifications();

  SongActions({
    required AudioPlayer audioPlayer,
  }) : _player = audioPlayer;

  @override
  void invoke(covariant BaseIntent intent) async {
    SongModel song = _player.audioSource?.sequence[_player.currentIndex!].tag;
    switch (intent.key) {
      case KeyAction.playPauseMusic:
        if (_player.playing) {
          await _player.pause();
          BotToast.showText(text: 'Song paused');
        } else {
          await _player.play();
          BotToast.showText(text: 'Song resumed');
        }
        await notifications.playPausekNotify(
          song: song,
          state: _player.playing ? "Playing" : "Paused",
        );
        break;

      case KeyAction.nextTrack:
        await _player.seekToNext();
        BotToast.showText(text: 'Next Track');
        await notifications.trackChangedNotify(song: song);
        break;

      case KeyAction.prevTrack:
        await _player.seekToPrevious();
        BotToast.showText(text: 'Previous Track');
        await notifications.trackChangedNotify(song: song);

        break;

      case KeyAction.openPlaylist:
        // await _player.seekToNext();
        BotToast.showText(text: 'Opened Playlist');
        break;

      default:
        BotToast.showText(text: 'No Action');
        break;
    }
  }
}
