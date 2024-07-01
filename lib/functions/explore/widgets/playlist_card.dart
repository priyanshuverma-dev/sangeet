import 'package:flutter/material.dart';
import 'package:sangeet_api/models.dart';

class PlaylistCard extends StatelessWidget {
  final PlaylistMapModel playlist;
  final VoidCallback onTap;
  const PlaylistCard({super.key, required this.playlist, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 150,
          height: 100,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Badge(
                label: Text("${playlist.songCount}"),
                alignment: Alignment.bottomLeft,
                child: Hero(
                  tag: "${playlist.id}-image",
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.black,
                    foregroundImage: NetworkImage(playlist.images[2].url),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                playlist.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Text(
                      playlist.subtitle,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: playlist.explicitContent,
                    child: const Icon(
                      Icons.explicit,
                      size: 16,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
