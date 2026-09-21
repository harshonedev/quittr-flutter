import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/core/usecases/usecase.dart';
import 'package:quittr/features/paywall/domain/entities/subscribed_product.dart';
import 'package:quittr/features/paywall/domain/repositories/purchase_repository.dart';

class PurchaseByCoupon extends UseCase<SubscribedProduct, String> {
  final SubscriptionRepository repository;

  PurchaseByCoupon(this.repository);

  @override
  Future<Either<Failure, SubscribedProduct>> call(String couponCode) {
    return repository.purchaseByCoupon(couponCode);
  }
}
