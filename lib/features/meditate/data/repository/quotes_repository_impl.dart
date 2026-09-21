import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/meditate/data/datasources/meditate_loacal_data_source.dart';
import 'package:quittr/features/meditate/domain/entities/quotes.dart';
import 'package:quittr/features/meditate/domain/repository/quotes_repository.dart';

class QuotesRepositoryImpl implements QuotesRepository {
  final MeditateLoacalDataSource meditateLocalDataSource;

  QuotesRepositoryImpl(this.meditateLocalDataSource);
  @override
  Future<Either<Failure, List<Quotes>>> getQuotes() async {
    try {
      final quotes = await meditateLocalDataSource.getQuotes();

      return Right(quotes);
    } on GeneralFailure catch (e) {
      return Left(GeneralFailure(e.message));
    }
  }
}
