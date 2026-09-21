import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/core/usecases/usecase.dart';
import '../entities/journal_entry.dart';
import '../repositories/journal_repository.dart';

class GetJournalEntries implements UseCase<List<JournalEntry>, NoParams> {
  final JournalRepository repository;

  GetJournalEntries(this.repository);

  @override
  Future<Either<Failure, List<JournalEntry>>> call(NoParams params) async {
    return await repository.getEntries();
  }
}
