import 'package:fpdart/fpdart.dart';
import 'package:pet_app/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
