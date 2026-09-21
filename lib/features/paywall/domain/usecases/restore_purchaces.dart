import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/core/usecases/usecase.dart';
import 'package:quittr/features/paywall/domain/repositories/purchase_repository.dart';

class RestorePurchasesUseCase extends UseCase<void, NoParams> {
  final SubscriptionRepository repository;

  RestorePurchasesUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.restorePurchases();
  }
}
