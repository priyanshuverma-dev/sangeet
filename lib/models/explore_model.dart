import 'package:savaan/models/artists/sub_artist_model.dart';
import 'package:savaan/models/song_model.dart';

class ExploreModel {
  final List<SongModel> songs;
  final List<SubArtistModel> artists;

  ExploreModel({
    required this.songs,
    required this.artists,
  });
}
