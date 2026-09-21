import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/side%20effects/domian/entites/side_effect.dart';

abstract interface class SideEffectesRepository {
  Future<Either<Failure, List<SideEffect>>> getSideEffects();
}
