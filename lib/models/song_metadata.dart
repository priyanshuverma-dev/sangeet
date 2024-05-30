// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:savaan/models/helpers/download_url.dart';
import 'package:savaan/models/helpers/song_image.dart';

class SongMetadata {
  final String title;
  final String album;
  final String albumArtist;
  final String artist;
  final String thumbnail;
  final String id;
  final String name;
  final String type;
  final String year;
  final String? releaseDate;
  final int duration;
  final String label;
  final bool explicitContent;
  final int playCount;
  final String language;
  final bool hasLyrics;
  final String? lyricsId;
  final String url;
  final String copyright;
  final List<DownloadUrl> downloadUrl;
  final List<ImageDownloadUrl> image;

  SongMetadata({
    required this.title,
    required this.album,
    required this.albumArtist,
    required this.artist,
    required this.thumbnail,
    required this.id,
    required this.name,
    required this.type,
    required this.year,
    required this.releaseDate,
    required this.duration,
    required this.label,
    required this.explicitContent,
    required this.playCount,
    required this.language,
    required this.hasLyrics,
    required this.lyricsId,
    required this.url,
    required this.copyright,
    required this.downloadUrl,
    required this.image,
  });
}
