import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/core/usecases/usecase.dart';
import 'package:quittr/features/side%20effects/domian/entites/side_effect.dart';
import 'package:quittr/features/side%20effects/domian/repository/side_effectes_repository.dart';

class GetSideEffects extends UseCase<List<SideEffect>, NoParams> {
  final SideEffectesRepository sideEffectesRepository;

  GetSideEffects(this.sideEffectesRepository);

  @override
  FutureOr<Either<Failure, List<SideEffect>>> call(NoParams params) async {
    return await sideEffectesRepository.getSideEffects();
  }
}
