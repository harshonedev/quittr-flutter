import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/core/usecases/usecase.dart';
import '../repositories/reason_repository.dart';

class DeleteReason implements UseCase<void, DeleteReasonParams> {
  final ReasonRepository repository;

  DeleteReason(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteReasonParams params) async {
    return await repository.deleteReason(params.id);
  }
}

class DeleteReasonParams extends Equatable {
  final String id;

  const DeleteReasonParams({required this.id});

  @override
  List<Object> get props => [id];
}
