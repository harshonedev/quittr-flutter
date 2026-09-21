import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/core/usecases/usecase.dart';
import 'package:quittr/features/paywall/domain/repositories/purchase_repository.dart';

class DisposeSubscriptionUseCase extends UseCase<void, NoParams> {
  final SubscriptionRepository repository;

  DisposeSubscriptionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    repository.dispose();
    return Right(null);
  }
}
