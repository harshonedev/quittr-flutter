import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/core/usecases/usecase.dart';
import '../entities/journal_entry.dart';
import '../repositories/journal_repository.dart';

class AddJournalEntry implements UseCase<JournalEntry, AddJournalEntryParams> {
  final JournalRepository repository;

  AddJournalEntry(this.repository);

  @override
  Future<Either<Failure, JournalEntry>> call(
      AddJournalEntryParams params) async {
    return await repository.addEntry(params.title, params.description);
  }
}

class AddJournalEntryParams extends Equatable {
  final String title;
  final String description;

  const AddJournalEntryParams({
    required this.title,
    required this.description,
  });

  @override
  List<Object> get props => [title, description];
}
