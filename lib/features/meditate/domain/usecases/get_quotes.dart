import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/core/usecases/usecase.dart';
import 'package:quittr/features/meditate/domain/entities/quotes.dart';
import 'package:quittr/features/meditate/domain/repository/quotes_repository.dart';

class GetQuotes extends UseCase<List<Quotes>, NoParams> {
  final QuotesRepository quotesRepository;
  GetQuotes(this.quotesRepository);
  @override
  FutureOr<Either<Failure, List<Quotes>>> call(NoParams params) async {
    return await quotesRepository.getQuotes();
  }
}
