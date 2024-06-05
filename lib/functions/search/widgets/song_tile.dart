import 'package:flutter/material.dart';
import 'package:saavn/models/song_model.dart';

class SearchSongTile extends StatelessWidget {
  final SongModel song;
  final VoidCallback onTap;
  const SearchSongTile({super.key, required this.song, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(song.name),
      subtitle: Text("${song.label} - ${song.year}"),
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Theme.of(context).primaryColorDark,
        foregroundImage: NetworkImage(song.image[0].url),
      ),
      onTap: onTap,
    );
  }
}
