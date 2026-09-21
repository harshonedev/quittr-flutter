import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quittr/core/error/failures.dart';

abstract class UseCase<T, Params> {
  FutureOr<Either<Failure, T>> call(Params params);

}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
