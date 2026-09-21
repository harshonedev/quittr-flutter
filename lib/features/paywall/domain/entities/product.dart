import 'package:equatable/equatable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class Product extends Equatable {
  final String id;
  final String productId;
  final String label;
  final String body;
  final String title;
  final String description;
  final double price;
  final String localizedPrice;
  final String currencyCode;
  final int duration;
  final String currencySymbol;
  final String paymentUrl;

  const Product({
    required this.id,
    required this.title,
    required this.productId,
    required this.body,
    required this.label,
    required this.description,
    required this.price,
    required this.localizedPrice,
    required this.currencyCode,
    required this.currencySymbol,
    required this.duration,
    this.paymentUrl = '',
  });

    ProductDetails toProductDetails() {
    return ProductDetails(
        id: id,
        title: title,
        description: description,
        price: localizedPrice,
        rawPrice: price,
        currencyCode: currencyCode,
        currencySymbol: currencySymbol);
  }

  @override
  List<Object> get props => [
        id,
        title,
        description,
        price,
        localizedPrice,
        currencyCode,
        duration,
        body,
        label,
        productId,
        currencySymbol,
        paymentUrl,
      ];
}
