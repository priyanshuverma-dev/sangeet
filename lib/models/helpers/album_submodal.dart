// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Album {
  final String id;
  final String name;
  final String url;
  Album({
    required this.id,
    required this.name,
    required this.url,
  });

  Album copyWith({
    String? id,
    String? name,
    String? url,
  }) {
    return Album(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'url': url,
    };
  }

  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      id: map['id'] as String,
      name: map['name'] as String,
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Album.fromJson(String source) =>
      Album.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Album(id: $id, name: $name, url: $url)';

  @override
  bool operator ==(covariant Album other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.url == url;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ url.hashCode;
}
