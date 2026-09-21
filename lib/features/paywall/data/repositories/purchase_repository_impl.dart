import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logger/logger.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/paywall/data/datasources/subscription_firestore.dart';
import 'package:quittr/features/paywall/data/models/subscribed_product_model.dart';
import 'package:quittr/features/paywall/domain/entities/product.dart';
import 'package:quittr/features/paywall/domain/entities/subscribed_product.dart';
import '../../domain/repositories/purchase_repository.dart';
import '../datasources/purchase_data_source.dart';
import 'package:http/http.dart' as http;

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionDataSource dataSource;
  final Logger _logger = Logger();
  final SubscriptionFirestore subscriptionFirestore;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Product? _selectedProduct;
  List<ProductDetails> _productDetailsList = [];

  final _subscriptionController =
      StreamController<Either<Failure, SubscribedProduct>>.broadcast();

  SubscriptionRepositoryImpl(
      {required this.dataSource, required this.subscriptionFirestore});

  @override
  void listenToPurchaseUpdates() {
    try {
      dataSource.purchaseUpdates
          .listen((List<PurchaseDetails> purchaseDetailsList) {
        for (var purchaseDetails in purchaseDetailsList) {
          if (purchaseDetails.status == PurchaseStatus.purchased) {
            _logger.i("Purchase successful: ${purchaseDetails.productID}");
            _logger.i(
                "Purchase details: ${purchaseDetails.productID}, ${purchaseDetails.purchaseID}, ${purchaseDetails.transactionDate}, ${purchaseDetails.verificationData.localVerificationData}, ${purchaseDetails.verificationData.serverVerificationData}");
            // Handle successful purchase
            if (_selectedProduct != null) {
              _deliverProduct(purchaseDetails, _selectedProduct!);
            }
          } else if (purchaseDetails.status == PurchaseStatus.restored) {
            // Handle restored purchase
            _logger.i("Purchase restored: ${purchaseDetails.productID}");
            _logger.i(
                "Purchase details: ${purchaseDetails.productID}, ${purchaseDetails.purchaseID}, ${purchaseDetails.transactionDate}, ${purchaseDetails.verificationData.localVerificationData}, ${purchaseDetails.verificationData.serverVerificationData}");
            _restoredProduct(purchaseDetails);
          } else if (purchaseDetails.status == PurchaseStatus.error) {
            _logger.e("Purchase error: ${purchaseDetails.error?.message}");
            _subscriptionController.add(Left(PurchaseFailedFailure(
                purchaseDetails.error?.message ?? "Unknown error")));
          } else if (purchaseDetails.status == PurchaseStatus.canceled) {
            _logger.i("Purchase pending: ${purchaseDetails.productID}");
            _subscriptionController
                .add(Left(PurchaseCancelledFailure("Purchase canceled")));
            // Handle pending purchase
          } else if (purchaseDetails.status == PurchaseStatus.pending) {
            _logger.i("Purchase pending: ${purchaseDetails.productID}");
            _subscriptionController
                .add(Left(PurchasePendingFailure("Purchase pending")));
          }

          // If the purchase is pending completion, complete it
          if (purchaseDetails.pendingCompletePurchase) {
            _logger.i("Completing purchase: ${purchaseDetails.productID}");
            dataSource.completePurchase(purchaseDetails);
          }
        }
      }).onError((error) {
        _logger.e("Error listening to purchase updates: $error");
        _subscriptionController.add(Left(
            ServerFailure("Failed to listen to purchase updates: $error")));
      });
    } catch (e) {
      _logger.e("Error initializing purchase updates: $e");
      _subscriptionController.add(
          Left(ServerFailure("Failed to initialize purchase updates: $e")));
    }
  }

  @override
  Stream<Either<Failure, SubscribedProduct>> get subscriptionUpdates =>
      _subscriptionController.stream;

  @override
  Future<Either<Failure, bool>> isAvailable() async {
    try {
      final result = await dataSource.isAvailable();
      _logger.i("Billing Available: $result");
      return Right(result);
    } on ConnectionFailedFailure catch (e) {
      return Left(ConnectionFailedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> fetchProducts(
      Set<String> productIds) async {
    try {
      final response = await dataSource.fetchProducts(productIds);
      for (var product in response.productDetails) {
        _logger.i("Fetched product: ${product.id}");
      }

      if (response.notFoundIDs.isNotEmpty) {
        _logger.w(
            "Products not found: ${response.notFoundIDs}"); // Log the not found IDs
        return Left(ProductNotFoundFailure("Products not found"));
      }

      _productDetailsList = response.productDetails;

      final list = _getProductsFromProductDetails(response.productDetails);

      return Right(list);
    } on ServerFailure catch (e) {
      _logger.e("Server failure while fetching products: ${e.message}");
      return Left(ServerFailure(e.message));
    } on ProductNotFoundFailure catch (e) {
      return Left(ProductNotFoundFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> purchase(Product product) async {
    try {
      final productDetails = _productDetailsList.firstWhere(
          (element) => element.price == product.localizedPrice,
          orElse: () => throw ProductNotFoundFailure("Product not found"));
      final result = await dataSource.purchase(productDetails);
      _selectedProduct = product; // Store the selected product
      _logger.i("Purchase initiated for product: ${product.id}");
      return Right(result);
    } on PurchaseFailedFailure catch (e) {
      return Left(PurchaseFailedFailure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> restorePurchases() async {
    try {
      _logger.i("Restoring purchases...");
      await dataSource.restorePurchases();
      return const Right(null);
    } on PurchaseFailedFailure catch (e) {
      return Left(PurchaseFailedFailure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, SubscribedProduct?>> checkSubscriptionStatus(
      String userId) async {
    try {
      // In a real app, this would check a backend service or local storage
      // that's been updated by the purchase verification process

      final response = await subscriptionFirestore.getSubscription(userId);
      // convert response into product model
      if (response == null) {
        _logger.w("No subscription found for user: $userId");
        return Right(null);
      }

      final subscribedProduct = SubscribedProductModel.fromJson(response);

      final hasActiveSubscription =
          subscribedProduct.status == SubscriptionStatus.active;

      final renewalDate = subscribedProduct.subscriptionEndDate;

      final isPlanExpired = renewalDate.isBefore(DateTime.now());

      if (isPlanExpired) {
        _logger.i(
            "Subscription expired on $renewalDate Is plan expired? - $isPlanExpired");
        // If the plan is expired, we can also delete the subscription from Firestore
        await subscriptionFirestore.deleteSubscription(userId);
        _logger.i("Deleted expired subscription for user: $userId");
      } else {
        _logger.i(
            "Subscription active until $renewalDate Is plan expired? - $isPlanExpired");
      }

      _logger.i(
          "Checking subscription status: ${hasActiveSubscription && !isPlanExpired}");
      return Right(
          hasActiveSubscription && !isPlanExpired ? subscribedProduct : null);
    } catch (e) {
      _logger.e("Error checking subscription status: $e");
      return Left(ServerFailure("Failed to check subscription status: $e"));
    }
  }

  @override
  void dispose() {
    dataSource.dispose();
  }

  void _restoredProduct(PurchaseDetails purchaseDetails) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        _logger.e("No user logged in to restore subscription");
        _subscriptionController.add(Left(AuthFailure("User not logged in")));
        return;
      }

      // check if the subscription is already on Firestore
      final existingSubscription =
          await subscriptionFirestore.getSubscription(user.uid);

      if (existingSubscription != null) {
        _logger.i("Subscription already exists for user: ${user.uid}");
        final subscribedProduct =
            SubscribedProductModel.fromJson(existingSubscription);
        _subscriptionController.add(Right(subscribedProduct));
        return;
      }

      // Store subscription information in Firestore
      final subscribedProduct = SubscribedProductModel(
        purchaseId: purchaseDetails.purchaseID ?? '',
        productId: purchaseDetails.productID,
        userId: user.uid,
        title: "Premium Subscription",
        description: "Restored subscription",
        price: "undefined", // Price may not be available in restored purchases
        subscriptionEndDate: DateTime.now().add(Duration(days: 7)),
        subscriptionStartDate: DateTime.fromMillisecondsSinceEpoch(
            purchaseDetails.transactionDate != null
                ? int.parse(purchaseDetails.transactionDate!)
                : DateTime.now().millisecondsSinceEpoch),
        duration: 7,
        status: SubscriptionStatus.active,
      );
      await subscriptionFirestore.addSubscription(
          subscribedProduct.userId, subscribedProduct.toJson());

      _logger.i("Restored product successfully: ${purchaseDetails.productID}");
      _subscriptionController.add(Right(subscribedProduct));
    } catch (e) {
      _logger.i("Error while restore - $e");
    }
  }

  void _deliverProduct(PurchaseDetails purchaseDetails, Product product) async {
    try {
      // Store subscription information in local
      await dataSource.deliverProduct(purchaseDetails, product.duration);

      // Store subscription information in Firestore
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        _logger.e("No user logged in to store subscription");
        _subscriptionController.add(Left(AuthFailure("User not logged in")));
        return;
      }
      final subscribedProduct = SubscribedProductModel(
        purchaseId: purchaseDetails.purchaseID ?? '',
        productId: product.productId,
        userId: user.uid,
        title: product.label,
        description: product.body,
        price: product.localizedPrice,
        subscriptionEndDate:
            DateTime.now().add(Duration(days: product.duration)),
        subscriptionStartDate: DateTime.now(),
        duration: product.duration,
        status: SubscriptionStatus.active,
      );
      _logger.i("Storing subscription for user: ${user.uid}");
      await subscriptionFirestore.addSubscription(
          user.uid, subscribedProduct.toJson());

      _logger.i("Product delivered successfully: ${product.id}");
      _subscriptionController.add(Right(subscribedProduct));
    } catch (e) {
      _logger.i("Error while deliver - $e");
    }
  }

  List<Product> _getProductsFromProductDetails(
      List<ProductDetails> productDetails) {
    List<Product> products = [];
    products.addAll(productDetails.map((product) {
      if (Platform.isAndroid) {
        return Product(
            productId: productDetails.indexOf(product) == 0
                ? 'weekly'
                : productDetails.indexOf(product) == 1
                    ? 'monthly'
                    : 'yearly',
            body: product.title.toLowerCase().contains('notempt')
                ? "NoTempt"
                : "Subscription",
            label: productDetails.indexOf(product) == 0
                ? 'Gold Plan'
                : productDetails.indexOf(product) == 1
                    ? 'Diamond Plan'
                    : 'Platinum Plan',
            id: product.id,
            title: product.title,
            description: product.description,
            price: product.rawPrice,
            localizedPrice: product.price,
            duration: productDetails.indexOf(product) == 0
                ? 7
                : productDetails.indexOf(product) == 1
                    ? 30
                    : 365,
            currencyCode: product.currencyCode,
            currencySymbol: product.currencySymbol);
      } else {
        return Product(
            id: product.id,
            title: product.title,
            productId: product.id,
            body: 'NoTempt',
            label: product.id.contains('weekly')
                ? 'Gold Plan'
                : product.id.contains('monthly')
                    ? 'Diamond Plan'
                    : 'Platinum Plan',
            description: product.description,
            price: product.rawPrice,
            localizedPrice: product.price,
            currencyCode: product.currencyCode,
            currencySymbol: product.currencySymbol,
            duration: product.id.contains('weekly')
                ? 7
                : product.id.contains('monthly')
                    ? 30
                    : 365);
      }
    }).toList());
    return products;
  }

  @override
  Future<Either<Failure, String>> purchaseWeb(String productId) async {
    final successUrl =
        "https://quittr-sable.vercel.app/#/subscription-status?checkout_id={CHECKOUT_SESSION_ID}";
    final createSessionUrl =
        "https://createcheckoutsession-hmxtfc3b6a-uc.a.run.app";

    final headers = {'Content-Type': 'application/json'};

    try {
      // creating a checkout session for web purchase by post request to the server

      final user = _firebaseAuth.currentUser;
      if (user == null) {
        _logger.e("No user logged in to purchase web product");
        return Left(AuthFailure("User not logged in"));
      }

      final body = jsonEncode({
        "productId": productId,
        "uid": user.uid,
        "email": user.email,
        "name": user.displayName ?? "NoTempt User",
        "successUrl": successUrl
      });

      _logger.i('Request body for creating checkout session: $body');

      final response = await http.post(
        Uri.parse(createSessionUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        _logger.i("Checkout session created successfully: $body");

        return Right(body['url'] as String);
      } else {
        _logger.e(
            "Failed to create checkout session: ${response.statusCode} - ${response.body}");
        return Left(ServerFailure(
            "Failed to create checkout session: ${response.statusCode}"));
      }
    } catch (e) {
      _logger.e("Error while purchasing web product - $e");
      return Left(ServerFailure("Failed to purchase web product: $e"));
    }
  }

  @override
  Future<Either<Failure, SubscribedProduct>> purchaseByCoupon(
      String couponCode) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        _logger.e("No user logged in to store subscription");
        return Left(AuthFailure("User not logged in"));
      }
      final subscribedProduct = SubscribedProductModel(
        purchaseId:
            'coupon_${couponCode}_${DateTime.now().millisecondsSinceEpoch}',
        productId: 'yearly_coupon',
        userId: user.uid,
        title: 'Unlimited Annual Plan (Coupon)',
        description: "NoTempt Annual Plan - Coupon Applied",
        price: "\$0.00",
        subscriptionEndDate: DateTime.now().add(Duration(days: 365)),
        subscriptionStartDate: DateTime.now(),
        duration: 365,
        status: SubscriptionStatus.active,
      );

      _logger.i("Storing subscription for user: ${user.uid}");
      await subscriptionFirestore.addSubscription(
          user.uid, subscribedProduct.toJson());

      return Right(subscribedProduct);
    } catch (e) {
      _logger.e("Error while purchasing by coupon - $e");
      return Left(ServerFailure("Failed to purchase by coupon: $e"));
    }
  }
}
