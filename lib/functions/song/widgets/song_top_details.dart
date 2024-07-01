import 'package:flutter/material.dart';
import 'package:sangeet/core/utils.dart';
import 'package:sangeet_api/models.dart';

class SongTopDetails extends StatelessWidget {
  final SongModel song;
  const SongTopDetails({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Badge(
          backgroundColor:
              song.explicitContent ? Colors.teal : Colors.transparent,
          label: Visibility(
            visible: song.explicitContent,
            child: const Icon(
              Icons.explicit_rounded,
              size: 12,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              song.images[2].url,
              width: 200,
              height: 200,
            ),
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                  maxLines: 2,
                ),
                Text(
                  song.subtitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w200,
                  ),
                  maxLines: 2,
                ),
                Text(
                  "${song.language} - ${song.year}",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .color!
                        .withOpacity(.7),
                  ),
                ),
                Text(
                  "Listens - ${formatNumber(song.playCount)}",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .color!
                        .withOpacity(.7),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
