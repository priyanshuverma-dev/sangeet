import 'package:flutter/material.dart';
import 'package:sangeet/core/utils.dart';
import 'package:sangeet_api/models.dart';

class PlaylistTopDetails extends StatelessWidget {
  final PlaylistModel playlist;
  const PlaylistTopDetails({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Badge(
          backgroundColor:
              playlist.explicitContent ? Colors.teal : Colors.transparent,
          label: Visibility(
            visible: playlist.explicitContent,
            child: const Icon(
              Icons.explicit_rounded,
              size: 12,
            ),
          ),
          child: Hero(
            tag: "${playlist.id}-image",
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                playlist.images[2].url,
                width: 200,
                height: 200,
              ),
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
                  playlist.title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                  maxLines: 2,
                ),
                Text(
                  playlist.subtitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w200,
                  ),
                  maxLines: 2,
                ),
                Text(
                  "fans - ${formatNumber(playlist.fanCount)} \nfollowers - ${formatNumber(playlist.followerCount)}",
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
                  "Songs - ${playlist.songs.length}",
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
