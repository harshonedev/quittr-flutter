import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/journal/data/datasources/journal_firestore.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/repositories/journal_repository.dart';
import '../models/journal_entry_model.dart';

class JournalRepositoryImpl implements JournalRepository {
  final JournalFirestore _journalFirestore;
  final FirebaseAuth  _firebaseAuth = FirebaseAuth.instance;

  JournalRepositoryImpl({
    required JournalFirestore journalFirestore,
  })  :
        _journalFirestore = journalFirestore;

  @override
  Future<Either<Failure, List<JournalEntry>>> getEntries() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return Left(CacheFailure('User not authenticated'));
      }
      final data = await _journalFirestore.getEntries(user.uid);
      if (data.isEmpty) {
        return Right([]); // Return an empty list if no entries found
      }
      final journalEntries = data.map((entry) {
        return JournalEntryModel.fromMap(entry);
      }).toList();
      return Right(journalEntries);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, JournalEntry>> addEntry(
      String title, String description) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return Left(CacheFailure('User not authenticated'));
      }
      final savedId = await _journalFirestore.addEntry(
        title,
        description,
        user.uid,
      );
      if (savedId.isEmpty) {
        return Left(CacheFailure('Failed to save entry'));
      }
      final savedEntry = JournalEntryModel(
        id: savedId, // ID will be set by the Firestore
        title: title,
        description: description,
        createdAt: DateTime.now(),
      );

      return Right(savedEntry);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
