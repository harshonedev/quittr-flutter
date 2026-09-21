import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, User>> signInWithApple();
  Future<Either<Failure, User>> signInWithEmailAndPassword(
      String email, String password);
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, void>> signOut();
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<Either<Failure, void>> deleteAccount();
}
