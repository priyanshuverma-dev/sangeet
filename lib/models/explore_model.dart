import 'package:saavn/models/artists/sub_artist_model.dart';
import 'package:saavn/models/song_model.dart';

class ExploreModel {
  final List<SongModel> songs;
  final List<SubArtistModel> artists;

  ExploreModel({
    required this.songs,
    required this.artists,
  });
}
