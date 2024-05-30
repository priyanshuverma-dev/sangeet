import 'dart:convert';

enum ImageQualityType {
  low('50x50'),
  medium('150x150'),
  high('500x500');

  final String type;
  const ImageQualityType(this.type);
}

extension ConvertQuality on String {
  ImageQualityType toImageQualityTypeEnum() {
    switch (this) {
      case '50x50':
        return ImageQualityType.low;
      case '150x150':
        return ImageQualityType.medium;
      case '500x500':
        return ImageQualityType.high;
      default:
        return ImageQualityType.medium;
    }
  }
}

class ImageDownloadUrl {
  ImageQualityType quality;
  String url;
  ImageDownloadUrl({
    required this.quality,
    required this.url,
  });

  ImageDownloadUrl copyWith({
    ImageQualityType? quality,
    String? url,
  }) {
    return ImageDownloadUrl(
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

  factory ImageDownloadUrl.fromMap(Map<String, dynamic> map) {
    return ImageDownloadUrl(
      quality: (map['quality'] as String).toImageQualityTypeEnum(),
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ImageDownloadUrl.fromJson(String source) =>
      ImageDownloadUrl.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DownloadUrl(quality: $quality, url: $url)';

  @override
  bool operator ==(covariant ImageDownloadUrl other) {
    if (identical(this, other)) return true;

    return other.quality == quality && other.url == url;
  }

  @override
  int get hashCode => quality.hashCode ^ url.hashCode;
}
