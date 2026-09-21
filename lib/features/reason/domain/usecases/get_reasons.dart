import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/core/usecases/usecase.dart';
import '../entities/reason.dart';
import '../repositories/reason_repository.dart';

class GetReasons implements UseCase<List<Reason>, NoParams> {
  final ReasonRepository repository;

  GetReasons(this.repository);

  @override
  Future<Either<Failure, List<Reason>>> call(NoParams params) async {
    return await repository.getReasons();
  }
}
