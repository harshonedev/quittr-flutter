import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/reason/data/datasources/reason_firestore.dart';
import 'package:quittr/features/reason/domain/repositories/reason_repository.dart';
import 'package:quittr/features/reason/domain/entities/reason.dart';

class ReasonRepositoryImpl implements ReasonRepository {
  final ReasonFirestore _reasonFirestore;
  final FirebaseAuth _auth  = FirebaseAuth.instance;

  ReasonRepositoryImpl({
    required ReasonFirestore reasonFirestore,
  })  :
        _reasonFirestore = reasonFirestore;

  @override
  Future<Either<Failure, List<Reason>>> getReasons() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return Left(AuthFailure("User not logged in"));
      }
      final reasons = await _reasonFirestore.getReasons(user.uid);
      return Right(reasons);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Reason>> addReason(String reasonText) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return Left(AuthFailure("User not logged in"));
      }
      final savedReason = await _reasonFirestore.addReason(user.uid, reasonText);
      return Right(savedReason);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReason(String id) async {
    try {
      await _reasonFirestore.deleteReason(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
