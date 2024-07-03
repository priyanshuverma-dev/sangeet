import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/constants.dart';
import 'package:sangeet/functions/settings/controllers/settings_controller.dart';
import 'package:sangeet_api/common/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaybackQualitySetting extends ConsumerStatefulWidget {
  const PlaybackQualitySetting({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PlaybackQualitySettingState();
}

class _PlaybackQualitySettingState
    extends ConsumerState<PlaybackQualitySetting> {
  @override
  Widget build(BuildContext context) {
    var items = SongQuality.values
        .map(
          (e) => PopupMenuItem(
            child: Text(e.name),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString(SharedPrefs.songQuality, e.quality);
              ref.invalidate(songQualityProvider);
              setState(() {});
            },
          ),
        )
        .toList();

    return ref.watch(songQualityProvider).when(
          data: (data) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Playback Quality"),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: PopupMenuButton(
                        itemBuilder: (context) {
                          return items;
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            data.name,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );

            //    ListTile(
            //   title: const Text("Playback Quality"),
            //   trailing: PopupMenuButton(
            //     child: Text(
            //       data.name,
            //       style: const TextStyle(
            //         fontSize: 18,
            //       ),
            //     ),
            //     itemBuilder: (context) {
            //       return items;
            //     },
            //   ),
            // )
          },
          error: (er, st) => Text(er.toString()),
          loading: () => const CircularProgressIndicator(),
        );
  }
}
