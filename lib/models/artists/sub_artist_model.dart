// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:saavn/models/helpers/song_image.dart';

class SubArtistModel {
  final String id;
  final String name;
  final String role;
  final List<ImageDownloadUrl> image;
  final String type;
  final String url;
  SubArtistModel({
    required this.id,
    required this.name,
    required this.role,
    required this.image,
    required this.type,
    required this.url,
  });

  SubArtistModel copyWith({
    String? id,
    String? name,
    String? role,
    List<ImageDownloadUrl>? image,
    String? type,
    String? url,
  }) {
    return SubArtistModel(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      image: image ?? this.image,
      type: type ?? this.type,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'role': role,
      'image': image.map((x) => x.toMap()).toList(),
      'type': type,
      'url': url,
    };
  }

  factory SubArtistModel.fromMap(Map<String, dynamic> map) {
    return SubArtistModel(
      id: map['id'] as String,
      name: map['name'] as String,
      role: map['role'] as String,
      image: List<ImageDownloadUrl>.from(
        (map['image']).map<ImageDownloadUrl>(
          (x) => ImageDownloadUrl.fromMap(x),
        ),
      ),
      type: map['type'] as String,
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubArtistModel.fromJson(String source) =>
      SubArtistModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SubArtistModel(id: $id, name: $name, role: $role, image: $image, type: $type, url: $url)';
  }

  @override
  bool operator ==(covariant SubArtistModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.role == role &&
        listEquals(other.image, image) &&
        other.type == type &&
        other.url == url;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        role.hashCode ^
        image.hashCode ^
        type.hashCode ^
        url.hashCode;
  }
}
