import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import '../entities/journal_entry.dart';

abstract class JournalRepository {
  Future<Either<Failure, List<JournalEntry>>> getEntries();
  Future<Either<Failure, JournalEntry>> addEntry(
    String title,
    String description,
  );
}
