// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'package:sangeet/models/helpers/album_submodal.dart';
import 'package:sangeet/models/helpers/download_url.dart';
import 'package:sangeet/models/helpers/song_image.dart';

@immutable
class SongModel {
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
  final Album album;
  const SongModel({
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
    this.lyricsId,
    required this.url,
    required this.copyright,
    required this.downloadUrl,
    required this.image,
    required this.album,
  });

  SongModel copyWith({
    String? id,
    String? name,
    String? type,
    String? year,
    String? releaseDate,
    int? duration,
    String? label,
    bool? explicitContent,
    int? playCount,
    String? language,
    bool? hasLyrics,
    String? lyricsId,
    String? url,
    String? copyright,
    List<DownloadUrl>? downloadUrl,
    List<ImageDownloadUrl>? image,
    Album? album,
  }) {
    return SongModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      year: year ?? this.year,
      releaseDate: releaseDate ?? this.releaseDate,
      duration: duration ?? this.duration,
      label: label ?? this.label,
      explicitContent: explicitContent ?? this.explicitContent,
      playCount: playCount ?? this.playCount,
      language: language ?? this.language,
      hasLyrics: hasLyrics ?? this.hasLyrics,
      lyricsId: lyricsId ?? this.lyricsId,
      url: url ?? this.url,
      copyright: copyright ?? this.copyright,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      image: image ?? this.image,
      album: album ?? this.album,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'type': type,
      'year': year,
      'releaseDate': releaseDate,
      'duration': duration,
      'label': label,
      'explicitContent': explicitContent,
      'playCount': playCount,
      'language': language,
      'hasLyrics': hasLyrics,
      'lyricsId': lyricsId,
      'url': url,
      'copyright': copyright,
      'downloadUrl': downloadUrl.map((x) => x.toMap()).toList(),
      'image': image.map((x) => x.toMap()).toList(),
      'album': album.toMap(),
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: map['id'] as String,
      name: map['name'] as String,
      type: map['type'] as String,
      year: map['year'] as String,
      releaseDate:
          map['releaseDate'] != null ? map['releaseDate'] as String : null,
      duration: map['duration'] as int,
      label: map['label'] as String,
      explicitContent: map['explicitContent'] as bool,
      playCount: map['playCount'] as int,
      language: map['language'] as String,
      hasLyrics: map['hasLyrics'] as bool,
      lyricsId: map['lyricsId'] != null ? map['lyricsId'] as String : null,
      url: map['url'] as String,
      copyright: map['copyright'] as String,
      downloadUrl: List<DownloadUrl>.from(
        (map['downloadUrl']).map<DownloadUrl>(
          (x) => DownloadUrl.fromMap(x),
        ),
      ),
      image: List<ImageDownloadUrl>.from(
        (map['image']).map<ImageDownloadUrl>(
          (x) => ImageDownloadUrl.fromMap(x),
        ),
      ),
      album: Album.fromMap(map['album']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SongModel.fromJson(String source) =>
      SongModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SongModel(id: $id, name: $name, type: $type, year: $year, releaseDate: $releaseDate, duration: $duration, label: $label, explicitContent: $explicitContent, playCount: $playCount, language: $language, hasLyrics: $hasLyrics, lyricsId: $lyricsId, url: $url, copyright: $copyright, downloadUrl: $downloadUrl, image: $image, album: $album)';
  }

  @override
  bool operator ==(covariant SongModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.name == name &&
        other.type == type &&
        other.year == year &&
        other.releaseDate == releaseDate &&
        other.duration == duration &&
        other.label == label &&
        other.explicitContent == explicitContent &&
        other.playCount == playCount &&
        other.language == language &&
        other.hasLyrics == hasLyrics &&
        other.lyricsId == lyricsId &&
        other.url == url &&
        other.copyright == copyright &&
        listEquals(other.downloadUrl, downloadUrl) &&
        listEquals(other.image, image) &&
        other.album == album;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        type.hashCode ^
        year.hashCode ^
        releaseDate.hashCode ^
        duration.hashCode ^
        label.hashCode ^
        explicitContent.hashCode ^
        playCount.hashCode ^
        language.hashCode ^
        hasLyrics.hashCode ^
        lyricsId.hashCode ^
        url.hashCode ^
        copyright.hashCode ^
        downloadUrl.hashCode ^
        image.hashCode ^
        album.hashCode;
  }

  factory SongModel.empty() {
    return SongModel(
      copyright: "",
      downloadUrl: const [],
      duration: 0,
      explicitContent: false,
      hasLyrics: false,
      id: "",
      image: const [],
      label: "",
      language: "",
      name: "",
      playCount: 0,
      releaseDate: "",
      type: "",
      url: "",
      year: "",
      album: Album(
        id: "",
        name: "",
        url: "",
      ),
      lyricsId: "",
    );
  }
}
