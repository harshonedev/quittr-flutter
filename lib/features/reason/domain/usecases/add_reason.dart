import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/core/usecases/usecase.dart';
import '../entities/reason.dart';
import '../repositories/reason_repository.dart';

class AddReason implements UseCase<Reason, AddReasonParams> {
  final ReasonRepository repository;

  AddReason(this.repository);

  @override
  Future<Either<Failure, Reason>> call(AddReasonParams params) async {
    return await repository.addReason(params.reasonText);
  }
}

class AddReasonParams extends Equatable {
  final String reasonText;

  const AddReasonParams({required this.reasonText});

  @override
  List<Object> get props => [reasonText];
}
