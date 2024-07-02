import 'package:flutter/material.dart';
import 'package:sangeet_api/models.dart';

class AlbumCard extends StatelessWidget {
  final VoidCallback onTap;
  final AlbumModel album;
  const AlbumCard({super.key, required this.onTap, required this.album});

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
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  album.images[1].url,
                  width: 100,
                  height: 100,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                album.title,
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
                      album.artists.map((e) => e.name).toList()[0],
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: album.explicitContent,
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
