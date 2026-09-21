import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/meditate/domain/entities/quotes.dart';

abstract interface class QuotesRepository {
  Future<Either<Failure, List<Quotes>>> getQuotes();
}
