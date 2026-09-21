import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/reason/domain/entities/reason.dart';
import 'package:quittr/features/reason/domain/repositories/reason_repository.dart';
import '../datasources/reason_firestore.dart';

class ReasonRepositoryImpl implements ReasonRepository {
  final ReasonFirestore _reasonFirestore;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ReasonRepositoryImpl({
    required ReasonFirestore reasonFirestore,
  }) : _reasonFirestore = reasonFirestore;


  @override
  Future<Either<Failure, List<Reason>>> getReasons() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return Left(CacheFailure('User not authenticated'));
      final reasons = await _reasonFirestore.getReasons(user.uid);
      return Right(reasons);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, Reason>> addReason(String reasonText) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return Left(CacheFailure('User not authenticated'));
      final reason = await _reasonFirestore.addReason(
        user.uid,
        reasonText);
      return Right(reason);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReason(String id) async {
    try {
      await _reasonFirestore.deleteReason(id.toString());
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
