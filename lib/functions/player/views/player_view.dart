import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:savaan/functions/explore/controllers/explore_controller.dart';
import 'package:savaan/models/song_model.dart';

class PlayerView extends ConsumerStatefulWidget {
  final List<SongModel> songs;
  const PlayerView(this.songs, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlayerViewState();
}

class _PlayerViewState extends ConsumerState<PlayerView> {
  final player = AudioPlayer();
  // Define the playlist
  @override
  void initState() {
    super.initState();
  }

  Future initPlayer() async {
    final playlist = await ref.read(getPlaylistProvider);
    await player.setAudioSource(playlist,
        initialIndex: 0, initialPosition: Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
