import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:quittr/features/paywall/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel(
      {required super.id,
      required super.title,
      required super.description,
      required super.productId,
      required super.body,
      required super.label,
      required super.price,
      required super.localizedPrice,
      required super.currencyCode,
      required super.currencySymbol,
      required super.duration});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'localizedPrice': localizedPrice,
      'currencyCode': currencyCode,
      'duration': duration
    };
  }


  factory ProductModel.fromProductDetails(ProductDetails details) {
    return ProductModel(
        id: details.id,
        title: details.title,
        description: details.description,
        price: details.rawPrice,
        localizedPrice: details.price,
        currencyCode: details.currencyCode,
        productId: details.id,
        body: details.description,
        label: details.title,
        currencySymbol: details.currencySymbol,
        duration: 7 // default to 7 days
        );
  }



  ProductModel copyWith(
      {String? id,
      String? title,
      String? description,
      double? price,
      String? localizedPrice,
      String? currencyCode,
      String? productId,
      String? body,
      String? label,
      int? duration,
      String? currencySymbol
    }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      localizedPrice: localizedPrice ?? this.localizedPrice,
      currencyCode: currencyCode ?? this.currencyCode,
      duration: duration ?? this.duration,
      productId: productId ?? this.productId,
      body: body ?? this.body,
      label: label ?? this.label,
      currencySymbol: this.currencySymbol,
    );
  }
}
