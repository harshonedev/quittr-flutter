import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/core/usecases/usecase.dart';
import 'package:quittr/features/paywall/domain/entities/subscribed_product.dart';
import 'package:quittr/features/paywall/domain/repositories/purchase_repository.dart';

class CheckSubscriptionStatusUseCase extends UseCase<SubscribedProduct?, String> {
  final SubscriptionRepository repository;
  CheckSubscriptionStatusUseCase({required this.repository});
  @override
  FutureOr<Either<Failure, SubscribedProduct?>> call(String userId) async {
    return repository.checkSubscriptionStatus(userId);  
  }
  
}