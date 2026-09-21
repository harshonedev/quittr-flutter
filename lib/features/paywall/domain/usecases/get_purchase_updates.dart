import 'dart:async';

import 'package:dartz/dartz.dart';
// import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/core/usecases/usecase.dart';
import 'package:quittr/features/paywall/domain/entities/subscribed_product.dart';
import '../repositories/purchase_repository.dart';

// class GetPurchaseUpdates implements UseCase<Stream<PurchasedItem?>, NoParams> {
//   final PurchaseRepository repository;

//   GetPurchaseUpdates(this.repository);

//   @override
//   Either<Failure, Stream<PurchasedItem?>> call(NoParams params) {
//     try {
//       return Right(repository.purchaseStream);
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }
// }

// abstract class StreamUseCase<Type, Params> {
//   Stream<Type> call(Params params);
// }

class ListenToPurchaseUpdatesUseCase {
  final SubscriptionRepository repository;

  ListenToPurchaseUpdatesUseCase(this.repository);

  Stream<Either<Failure, SubscribedProduct>> call(
      NoParams params) {
    return repository.subscriptionUpdates;
  }
}
