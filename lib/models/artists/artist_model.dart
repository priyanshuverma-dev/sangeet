// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:savaan/models/helpers/song_image.dart';
import 'package:savaan/models/song_model.dart';

class ArtistModel {
  final String id;
  final String name;
  final String url;
  final String type;
  final int followerCount;
  final String fanCount;
  final bool isVerified;
  final String dominantLanguage;
  final String dominantType;
  final List<String> bio;
  final String? dob;
  final String? fb;
  final String? twitter;
  final String? wiki;
  final List<String> availableLanguages;
  final bool isRadioPresent;
  final List<ImageDownloadUrl> image;
  final List<SongModel> topSongs;
  ArtistModel({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
    required this.followerCount,
    required this.fanCount,
    required this.isVerified,
    required this.dominantLanguage,
    required this.dominantType,
    required this.bio,
    this.dob,
    this.fb,
    this.twitter,
    this.wiki,
    required this.availableLanguages,
    required this.isRadioPresent,
    required this.image,
    required this.topSongs,
  });

  ArtistModel copyWith({
    String? id,
    String? name,
    String? url,
    String? type,
    int? followerCount,
    String? fanCount,
    bool? isVerified,
    String? dominantLanguage,
    String? dominantType,
    List<String>? bio,
    String? dob,
    String? fb,
    String? twitter,
    String? wiki,
    List<String>? availableLanguages,
    bool? isRadioPresent,
    List<ImageDownloadUrl>? image,
    List<SongModel>? topSongs,
  }) {
    return ArtistModel(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      type: type ?? this.type,
      followerCount: followerCount ?? this.followerCount,
      fanCount: fanCount ?? this.fanCount,
      isVerified: isVerified ?? this.isVerified,
      dominantLanguage: dominantLanguage ?? this.dominantLanguage,
      dominantType: dominantType ?? this.dominantType,
      bio: bio ?? this.bio,
      dob: dob ?? this.dob,
      fb: fb ?? this.fb,
      twitter: twitter ?? this.twitter,
      wiki: wiki ?? this.wiki,
      availableLanguages: availableLanguages ?? this.availableLanguages,
      isRadioPresent: isRadioPresent ?? this.isRadioPresent,
      image: image ?? this.image,
      topSongs: topSongs ?? this.topSongs,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'url': url,
      'type': type,
      'followerCount': followerCount,
      'fanCount': fanCount,
      'isVerified': isVerified,
      'dominantLanguage': dominantLanguage,
      'dominantType': dominantType,
      'bio': bio,
      'dob': dob,
      'fb': fb,
      'twitter': twitter,
      'wiki': wiki,
      'availableLanguages': availableLanguages,
      'isRadioPresent': isRadioPresent,
      'image': image.map((x) => x.toMap()).toList(),
      'topSongs': topSongs.map((x) => x.toMap()).toList(),
    };
  }

  factory ArtistModel.fromMap(Map<String, dynamic> map) {
    return ArtistModel(
      id: map['id'] as String,
      name: map['name'] as String,
      url: map['url'] as String,
      type: map['type'] as String,
      followerCount: map['followerCount'] as int,
      fanCount: map['fanCount'] as String,
      isVerified: map['isVerified'] as bool,
      dominantLanguage: map['dominantLanguage'] as String,
      dominantType: map['dominantType'] as String,
      bio: List<String>.from((map['bio'] as List<String>)),
      dob: map['dob'] != null ? map['dob'] as String : null,
      fb: map['fb'] != null ? map['fb'] as String : null,
      twitter: map['twitter'] != null ? map['twitter'] as String : null,
      wiki: map['wiki'] != null ? map['wiki'] as String : null,
      availableLanguages:
          List<String>.from((map['availableLanguages'] as List<String>)),
      isRadioPresent: map['isRadioPresent'] as bool,
      image: List<ImageDownloadUrl>.from(
        (map['image']).map<ImageDownloadUrl>(
          (x) => ImageDownloadUrl.fromMap(x),
        ),
      ),
      topSongs: List<SongModel>.from(
        (map['topSongs']).map<SongModel>(
          (x) => SongModel.fromMap(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ArtistModel.fromJson(String source) =>
      ArtistModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ArtistModel(id: $id, name: $name, url: $url, type: $type, followerCount: $followerCount, fanCount: $fanCount, isVerified: $isVerified, dominantLanguage: $dominantLanguage, dominantType: $dominantType, bio: $bio, dob: $dob, fb: $fb, twitter: $twitter, wiki: $wiki, availableLanguages: $availableLanguages, isRadioPresent: $isRadioPresent, image: $image, topSongs: $topSongs)';
  }

  @override
  bool operator ==(covariant ArtistModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.url == url &&
        other.type == type &&
        other.followerCount == followerCount &&
        other.fanCount == fanCount &&
        other.isVerified == isVerified &&
        other.dominantLanguage == dominantLanguage &&
        other.dominantType == dominantType &&
        listEquals(other.bio, bio) &&
        other.dob == dob &&
        other.fb == fb &&
        other.twitter == twitter &&
        other.wiki == wiki &&
        listEquals(other.availableLanguages, availableLanguages) &&
        other.isRadioPresent == isRadioPresent &&
        listEquals(other.image, image) &&
        listEquals(other.topSongs, topSongs);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        url.hashCode ^
        type.hashCode ^
        followerCount.hashCode ^
        fanCount.hashCode ^
        isVerified.hashCode ^
        dominantLanguage.hashCode ^
        dominantType.hashCode ^
        bio.hashCode ^
        dob.hashCode ^
        fb.hashCode ^
        twitter.hashCode ^
        wiki.hashCode ^
        availableLanguages.hashCode ^
        isRadioPresent.hashCode ^
        image.hashCode ^
        topSongs.hashCode;
  }
}
