import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/motivaton/data/data_sources/motivation_quotes_local_datasource.dart';
import 'package:quittr/features/motivaton/domain/entity/motivational_quotes.dart';
import 'package:quittr/features/motivaton/domain/repository/motivation_quotes_repository.dart';

class MotivationalQuotesRepositoryImpl implements MotivationQuotesRepository {
  final MotivationQuotesLocalDatasource motivationQuotesLocalDatasource;
  MotivationalQuotesRepositoryImpl(this.motivationQuotesLocalDatasource);
  @override
  Future<Either<Failure, List<MotivationalQuotes>>>
      getMotivationalQuotes() async {
    try {
      final motivationalQuotes =
          await motivationQuotesLocalDatasource.getMotivaionalQuotes();

      return Right(motivationalQuotes);
    } on GeneralFailure catch (e) {
      return Left(GeneralFailure(e.message));
    }
  }
}
