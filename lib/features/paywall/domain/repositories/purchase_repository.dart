import 'package:dartz/dartz.dart';
// import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/paywall/domain/entities/product.dart';
import 'package:quittr/features/paywall/domain/entities/subscribed_product.dart';


abstract class SubscriptionRepository {
  /// Check if in-app purchases are available
  Future<Either<Failure, bool>> isAvailable();

  /// Fetch product details
  Future<Either<Failure, List<Product>>> fetchProducts(
      Set<String> productIds);

  /// Stream of purchase updates
  Stream<Either<Failure, SubscribedProduct>> get subscriptionUpdates;

  /// Initiate a purchase
  Future<Either<Failure, bool>> purchase(Product product);

  /// Restore previous purchases
  Future<Either<Failure, void>> restorePurchases();

  /// Check if user has a valid subscription
  Future<Either<Failure, SubscribedProduct?>> checkSubscriptionStatus(String userId);

  Future<Either<Failure, String>> purchaseWeb(String productId);

  // Purchase using coupon code
  Future<Either<Failure, SubscribedProduct>> purchaseByCoupon(String couponCode);
  

  void listenToPurchaseUpdates();



  /// Dispose resources
  void dispose();
}
