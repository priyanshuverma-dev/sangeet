import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sangeet/core/utils.dart';
import 'package:sangeet_api/models.dart';

class ArtistTopDetails extends StatelessWidget {
  final ArtistModel artist;
  const ArtistTopDetails({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            artist.images[2].url,
            width: 200,
            height: 200,
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
                  artist.name,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                  maxLines: 2,
                ),
                Text(
                  artist.subtitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w200,
                  ),
                  maxLines: 2,
                ),
                Visibility(
                  visible: artist.isVerified,
                  child: Row(
                    children: [
                      Text(
                        "Verified",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .color!
                              .withOpacity(.7),
                        ),
                      ),
                      const Icon(
                        Icons.verified_rounded,
                        color: Colors.blue,
                      )
                    ],
                  ),
                ),
                Text(
                  "Followers - ${formatNumber(artist.followersCount)}",
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
