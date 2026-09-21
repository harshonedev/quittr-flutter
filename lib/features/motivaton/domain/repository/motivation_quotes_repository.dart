import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/motivaton/domain/entity/motivational_quotes.dart';

abstract interface class MotivationQuotesRepository {
  Future<Either<Failure, List<MotivationalQuotes>>> getMotivationalQuotes();
}
