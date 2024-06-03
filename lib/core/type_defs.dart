import 'package:fpdart/fpdart.dart';
import 'package:saavn/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
