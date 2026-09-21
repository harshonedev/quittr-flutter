import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class SubscribedProduct extends Equatable {
  final String purchaseId;
  final String productId;
  final String userId;
  final String title;
  final String description;
  final String price;
  final DateTime subscriptionEndDate;
  final DateTime subscriptionStartDate;
  final int duration;
  final SubscriptionStatus status;

  const SubscribedProduct({
    required this.productId,
    required this.userId,
    required this.purchaseId,
    required this.title,
    required this.description,
    required this.price,
    required this.subscriptionEndDate,
    required this.subscriptionStartDate,
    required this.duration,
    required this.status,
  });

  factory SubscribedProduct.fromJson(Map<String, dynamic> json) {
    return SubscribedProduct(
      productId: json['productId'] as String,
      purchaseId: json['purchaseId'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as String,
      subscriptionEndDate: (json['subscriptionEndDate'] as Timestamp).toDate(),
      subscriptionStartDate:
          (json['subscriptionStartDate'] as Timestamp).toDate(),
      duration: json['duration'] as int,
      status: SubscriptionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => SubscriptionStatus.unknown,
      ),
    );
  }

  @override
  List<Object> get props => [
        productId,
        purchaseId,
        userId,
        title,
        description,
        price,
        subscriptionEndDate,
        subscriptionStartDate,
        duration,
      ];
}

enum SubscriptionStatus {
  active,
  expired,
  cancelled,
  unknown,
}
