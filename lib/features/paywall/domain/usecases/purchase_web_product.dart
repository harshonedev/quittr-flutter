import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/core/usecases/usecase.dart';
import 'package:quittr/features/paywall/domain/repositories/purchase_repository.dart';

class PurchaseWebProduct extends UseCase<String, String> {
  final SubscriptionRepository repository;
  PurchaseWebProduct(this.repository);
  @override
  FutureOr<Either<Failure, String>> call(String params) {
    return repository.purchaseWeb(params);
  }
  
}