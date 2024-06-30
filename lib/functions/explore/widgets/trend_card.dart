import 'package:flutter/material.dart';
import 'package:sangeet_api/models.dart';

class TrendCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final IconData badgeIcon;
  final VoidCallback onTap;
  final bool explicitContent;
  const TrendCard({
    super.key,
    required this.onTap,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.badgeIcon,
    required this.explicitContent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Badge(
                backgroundColor:
                    explicitContent ? Colors.redAccent : Colors.teal,
                label: Icon(
                  badgeIcon,
                  size: 10,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    image,
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          overflow: TextOverflow.fade,
                        ),
                        maxLines: 2,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Widget> trendCards(BrowseTrendingModel trendings) {
  final l = [
    for (SongModel album in trendings.songs)
      (TrendCard(
        onTap: () {},
        image: album.images[1].url,
        title: album.title,
        subtitle: album.subtitle,
        explicitContent: album.explicitContent,
        badgeIcon: Icons.music_note,
      )),
    for (AlbumModel album in trendings.albums)
      (TrendCard(
        onTap: () {},
        image: album.images[1].url,
        title: album.title,
        subtitle: album.artists.map((e) => e.name).join(','),
        explicitContent: album.explicitContent,
        badgeIcon: Icons.album,
      )),
    for (PlaylistMapModel album in trendings.playlists)
      (TrendCard(
        onTap: () {},
        image: album.images[1].url,
        title: album.title,
        subtitle: album.subtitle,
        explicitContent: album.explicitContent,
        badgeIcon: Icons.playlist_play_rounded,
      )),
  ];

  return l;
}
