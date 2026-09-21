import 'package:dartz/dartz.dart';
// import 'package:flutter_inapp_purchase/modules.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/core/usecases/usecase.dart';
import 'package:quittr/features/paywall/domain/entities/product.dart';
import '../repositories/purchase_repository.dart';

// class GetSubscriptions implements UseCase<List<Product>, GetProductsParams> {
//   final PurchaseRepository repository;

//   GetSubscriptions(this.repository);

//   @override
//   Future<Either<Failure, List<Product>>> call(GetProductsParams params) async {
//     return await repository.getSubscriptions(params.productIds);
//   }
// }

// class GetProductsParams extends Equatable {
//   final List<String> productIds;

//   const GetProductsParams({required this.productIds});

//   @override
//   List<Object> get props => [productIds];
// }

class FetchProductsUseCase extends UseCase<List<Product>, FetchProductsParams> {
  final SubscriptionRepository repository;

  FetchProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(FetchProductsParams params) {
    return repository.fetchProducts(params.productIds);
  }
}

class FetchProductsParams {
  final Set<String> productIds;
  FetchProductsParams(this.productIds);
}
