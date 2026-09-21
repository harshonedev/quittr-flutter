import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quittr/features/paywall/domain/entities/subscribed_product.dart';

class SubscribedProductModel extends SubscribedProduct {
  const SubscribedProductModel({
    required super.purchaseId,
    required super.productId,
    required super.userId,
    required super.title,
    required super.description,
    required super.price,
    required super.subscriptionEndDate,
    required super.subscriptionStartDate,
    required super.duration,
    required super.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'purchaseId': purchaseId,
      'productId': productId,
      'userId': userId,
      'title': title,
      'description': description,
      'price': price,
      'subscriptionEndDate': Timestamp.fromDate(subscriptionEndDate),
      'subscriptionStartDate': Timestamp.fromDate(subscriptionStartDate),
      'duration': duration,
      'status': status.name,
    };
  }

  factory SubscribedProductModel.fromJson(Map<String, dynamic> json) {
    final status = json['status'] == 'active'
        ? SubscriptionStatus.active
        : SubscriptionStatus.expired;
    return SubscribedProductModel(
      purchaseId: json['purchaseId'],
      productId: json['productId'],
      title: json['title'],
      userId: json['userId'],
      description: json['description'],
      price: json['price'],
      subscriptionEndDate: (json['subscriptionEndDate'] as Timestamp?) != null
          ? (json['subscriptionEndDate'] as Timestamp).toDate()
          : DateTime.now().add(const Duration(days: 365)),
      subscriptionStartDate: (json['subscriptionStartDate'] as Timestamp?) != null
          ? (json['subscriptionStartDate'] as Timestamp).toDate()
          : DateTime.now(),
      duration: json['duration'],
      status: status,
    );
  }
}
