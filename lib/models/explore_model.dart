import 'package:sangeet/models/artists/sub_artist_model.dart';
import 'package:sangeet/models/song_model.dart';

class ExploreModel {
  final List<SongModel> songs;
  final List<SubArtistModel> artists;

  ExploreModel({
    required this.songs,
    required this.artists,
  });
}
