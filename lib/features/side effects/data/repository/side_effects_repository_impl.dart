import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/side%20effects/data/data_sources/side_effects_local_datasource.dart';
import 'package:quittr/features/side%20effects/domian/entites/side_effect.dart';
import 'package:quittr/features/side%20effects/domian/repository/side_effectes_repository.dart';

class SideEffectsRepositoryImpl implements SideEffectesRepository {
  final SideEffectsLocalDatasource sideEffectsLocalDatasource;

  SideEffectsRepositoryImpl(this.sideEffectsLocalDatasource);
  @override
  Future<Either<Failure, List<SideEffect>>> getSideEffects() async {
    try {
      final sideEffects = await sideEffectsLocalDatasource.getSideEffects();

      return Right(sideEffects);
    } on GeneralFailure catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }
}
