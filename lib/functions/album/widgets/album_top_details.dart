import 'package:flutter/material.dart';
import 'package:sangeet_api/models.dart';

class AlbumTopDetails extends StatelessWidget {
  final AlbumModel album;
  const AlbumTopDetails({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Badge(
          backgroundColor: Colors.teal,
          label: Visibility(
            visible: album.explicitContent,
            child: const Icon(
              Icons.explicit_rounded,
              size: 12,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              album.images[2].url,
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
                  album.title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                  maxLines: 2,
                ),
                Text(
                  album.subtitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w200,
                  ),
                  maxLines: 2,
                ),
                Text(
                  "${album.language} - ${album.year}",
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
                  "Songs - ${album.listCount}",
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
