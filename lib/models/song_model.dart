// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:savaan/models/helpers/download_url.dart';

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
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      year: map['year'],
      releaseDate: map['releaseDate'],
      duration: map['duration'],
      label: map['label'],
      explicitContent: map['explicitContent'],
      playCount: map['playCount'],
      language: map['language'],
      hasLyrics: map['hasLyrics'],
      lyricsId: map['lyricsId'] != null ? map['lyricsId'] as String : null,
      url: map['url'],
      copyright: map['copyright'],
      downloadUrl: List<DownloadUrl>.from(
        (map['downloadUrl']).map<DownloadUrl>(
          (x) => DownloadUrl.fromMap(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SongModel.fromJson(String source) =>
      SongModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SongModel(id: $id, name: $name, type: $type, year: $year, releaseDate: $releaseDate, duration: $duration, label: $label, explicitContent: $explicitContent, playCount: $playCount, language: $language, hasLyrics: $hasLyrics, lyricsId: $lyricsId, url: $url, copyright: $copyright, downloadUrl: $downloadUrl)';
  }

  @override
  bool operator ==(covariant SongModel other) {
    if (identical(this, other)) return true;

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
        listEquals(other.downloadUrl, downloadUrl);
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
        downloadUrl.hashCode;
  }
}
