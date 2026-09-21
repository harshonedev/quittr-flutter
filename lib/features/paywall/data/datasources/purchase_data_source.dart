import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SubscriptionDataSource {
  Stream<List<PurchaseDetails>> get purchaseUpdates;
  Future<bool> isAvailable();
  Future<ProductDetailsResponse> fetchProducts(Set<String> productIds);
  Future<void> restorePurchases();
  Future<void> deliverProduct(
      PurchaseDetails purchaseDetails, int purchaseDuration);
  Future<void> completePurchase(PurchaseDetails purchaseDetails);
  Future<bool> purchase(ProductDetails productDetails); // New purchase method
  void dispose();
}

class SubscriptionDataSourceImpl implements SubscriptionDataSource {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final Logger _logger;

  SubscriptionDataSourceImpl({
    required Logger logger,
  }) : _logger = logger;

  @override
  Stream<List<PurchaseDetails>> get purchaseUpdates =>
      _inAppPurchase.purchaseStream;

  @override
  Future<bool> isAvailable() => _inAppPurchase.isAvailable();



  @override
  Future<ProductDetailsResponse> fetchProducts(Set<String> productIds) async {
    final response = await _inAppPurchase.queryProductDetails(productIds);
    if (response.notFoundIDs.isNotEmpty) {
      _logger.w("Products not found: ${response.notFoundIDs}");
      throw Exception("Products not found: ${response.notFoundIDs}");
    }
    _logger.i("Fetched products: ${response.productDetails}");
    for (var product in response.productDetails) {
      _logger.i(
          "Product ID: ${product.id}, Title: ${product.title} ,Price: ${product.price}, Description: ${product.description}, ${product.rawPrice}");
    }
    return response;
  }

  @override
  Future<void> restorePurchases() async {
    await _inAppPurchase.restorePurchases();
  }

  @override
  Future<bool> purchase(ProductDetails productDetails) async {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    return _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Future<void> deliverProduct(
      PurchaseDetails purchaseDetails, int purchaseDuration) async {
    _logger.i("Delivering product: ${purchaseDetails.productID}");

    // Store subscription information in SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Set flag that user has active subscription
    await prefs.setBool('has_active_subscription', true);


    // Calculate and store the renewal date if available
    if (Platform.isAndroid &&
        purchaseDetails.status == PurchaseStatus.purchased) {
      // For Android purchases - use a default date since we can't directly access purchaseTime
      DateTime now = DateTime.now();
      // Assuming all subscriptions are monthly for now - in a real app you'd get this from the product info
      DateTime renewalDate = now.add(Duration(days: purchaseDuration));
      String formattedRenewalDate =
          DateFormat('MMM d, yyyy').format(renewalDate);
      await prefs.setString('renewal_date', formattedRenewalDate);
    } else if (Platform.isIOS) {
      // For iOS, we'd typically use the transaction info
      // This is a simplified example - in production, you'd parse the transactionReceipt
      DateTime now = DateTime.now();
      DateTime renewalDate = now.add(const Duration(days: 30));
      String formattedRenewalDate =
          DateFormat('MMM d, yyyy').format(renewalDate);
      await prefs.setString('renewal_date', formattedRenewalDate);
    }
  }
  @override
  void dispose() {
    // disable the purchase stream listener
    _inAppPurchase.purchaseStream.drain();
  }

  @override
  Future<void> completePurchase(PurchaseDetails purchaseDetails) {
    return _inAppPurchase.completePurchase(purchaseDetails);
  }
  

}
