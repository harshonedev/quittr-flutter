
import 'package:quittr/core/usecases/usecase.dart';
import 'package:quittr/features/paywall/domain/repositories/purchase_repository.dart';

class StartListeningUpdatesUseCase {
  final SubscriptionRepository repository;
  StartListeningUpdatesUseCase(this.repository);

  void call(NoParams params) {
    repository.listenToPurchaseUpdates();
  }
}
