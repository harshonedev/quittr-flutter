import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import '../entities/reason.dart';

abstract class ReasonRepository {
  Future<Either<Failure, List<Reason>>> getReasons();
  Future<Either<Failure, Reason>> addReason(String reasonText);
  Future<Either<Failure, void>> deleteReason(String id);
}
