import 'package:fpdart/fpdart.dart';
import 'package:sangeet/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;

enum MediaType { artist, playlist, song, album, radio }
