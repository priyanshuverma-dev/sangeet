import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:savaan/core/size_manager.dart';
import 'package:savaan/functions/explore/controllers/explore_controller.dart';
import 'package:savaan/functions/player/views/common.dart';
import 'package:savaan/models/song_model.dart';

class BottomPlayerSheet extends ConsumerStatefulWidget {
  const BottomPlayerSheet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      BottomPlayerSheetState();
}

class BottomPlayerSheetState extends ConsumerState<BottomPlayerSheet> {
  late AudioPlayer _player;
  late ConcatenatingAudioSource _playlist;

  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      _playlist = await ref.read(getPlaylistProvider(SongModel.empty()));
      print(_player);
      await _player.setAudioSource(_playlist,
          preload: kIsWeb || defaultTargetPlatform != TargetPlatform.linux);
    } on PlayerException catch (e) {
      print("Error loading audio source: $e");
    }

    _player.positionDiscontinuityStream.listen((discontinuity) {
      if (discontinuity.reason == PositionDiscontinuityReason.autoAdvance) {
        _showItemFinished(discontinuity.previousEvent.currentIndex);
      }
    });
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        _showItemFinished(_player.currentIndex);
      }
    });
  }

  void _showItemFinished(int? index) {
    if (index == null) return;
    final sequence = _player.sequence;
    if (sequence == null) return;
    final source = sequence[index];
    final metadata = source.tag as SongModel;
    _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text('Finished playing ${metadata.name}'),
      duration: const Duration(seconds: 1),
    ));
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
      stream: _player.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(height: AppSize.s0);
        }
        if (state?.sequence.isEmpty ?? true) {
          return const SizedBox();
        }
        final metadata = state!.currentSource!.tag as SongModel;
        return BottomSheet(
          elevation: AppSize.s30,
          onClosing: () {},
          enableDrag: false,
          builder: (context) {
            return ListTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSize.s28),
                  topRight: Radius.circular(AppSize.s28),
                ),
              ),
              leading: const Icon(Icons.music_note),
              title: Text(
                metadata.name,
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                metadata.label,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.keyboard_arrow_up),
              onTap: () {
                // Navigator.pushNamed(context, Routes.showSongRoute);
              },
            );
          },
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Image.network(metadata.image[2].url)),
              ),
            ),
            Text(metadata.name, style: Theme.of(context).textTheme.titleLarge),
            Text(metadata.label),
          ],
        );
      },
    );
  }
}
