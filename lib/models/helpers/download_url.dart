// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:savaan/models/helpers/download_quality.dart';

class DownloadUrl {
  SongQualityType quality;
  String url;
  DownloadUrl({
    required this.quality,
    required this.url,
  });

  DownloadUrl copyWith({
    SongQualityType? quality,
    String? url,
  }) {
    return DownloadUrl(
      quality: quality ?? this.quality,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'quality': quality.type,
      'url': url,
    };
  }

  factory DownloadUrl.fromMap(Map<String, dynamic> map) {
    return DownloadUrl(
      quality: (map['quality'] as String).toSongQualityTypeEnum(),
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DownloadUrl.fromJson(String source) =>
      DownloadUrl.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DownloadUrl(quality: $quality, url: $url)';

  @override
  bool operator ==(covariant DownloadUrl other) {
    if (identical(this, other)) return true;

    return other.quality == quality && other.url == url;
  }

  @override
  int get hashCode => quality.hashCode ^ url.hashCode;
}
