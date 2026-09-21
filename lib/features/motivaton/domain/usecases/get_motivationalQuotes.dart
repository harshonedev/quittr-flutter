import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/core/usecases/usecase.dart';
import 'package:quittr/features/motivaton/domain/entity/motivational_quotes.dart';
import 'package:quittr/features/motivaton/domain/repository/motivation_quotes_repository.dart';

class GetMotivationalquotes
    extends UseCase<List<MotivationalQuotes>, NoParams> {
  final MotivationQuotesRepository motivationalQuotesRepository;

  GetMotivationalquotes(this.motivationalQuotesRepository);
  @override
  FutureOr<Either<Failure, List<MotivationalQuotes>>> call(NoParams params)async {
   return await motivationalQuotesRepository.getMotivationalQuotes();
  }
}
