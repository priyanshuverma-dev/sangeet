import 'package:fpdart/fpdart.dart';
import 'package:sangeet/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;

enum MediaType {
  artist,
  playlist,
  song,
  album,
  radio;

  const MediaType();

  static MediaType fromString(String type) {
    switch (type) {
      case "song":
        return MediaType.song;

      case "album":
        return MediaType.album;

      case "playlist":
        return MediaType.playlist;

      case "featured_radio":
        return MediaType.radio;
      default:
        return MediaType.song;
    }
  }
}
