part of 'paywall_bloc.dart';

abstract class PaywallEvent extends Equatable {
  const PaywallEvent();

  @override
  List<Object?> get props => [];
}

class CheckIAPAvailabilityEvent extends PaywallEvent {}

class FetchProductsEvent extends PaywallEvent {
  final Set<String> productIds;

  const FetchProductsEvent(this.productIds);

  @override
  List<Object> get props => [productIds];
}

class PurchaseProductEvent extends PaywallEvent {
  final Product product;

  const PurchaseProductEvent(this.product);

  @override
  List<Object> get props => [product];
}

class RestorePurchasesEvent extends PaywallEvent {}

class CompletePurchaseEvent extends PaywallEvent {
  final PurchaseDetails purchaseDetails;

  const CompletePurchaseEvent(this.purchaseDetails);

  @override
  List<Object> get props => [purchaseDetails];
}

class StartListeningToPurchaseUpdatesEvent extends PaywallEvent {}

class PurchaseUpdatedEvent extends PaywallEvent {
  final SubscribedProduct product;

  const PurchaseUpdatedEvent(this.product);

  @override
  List<Object> get props => [product];
}

class CheckSubscriptionEvent extends PaywallEvent {
  final String userId;
  const CheckSubscriptionEvent({required this.userId});

  @override
  List<Object?> get props => [];
}

class PurchaseErrorEvent extends PaywallEvent {
  final String error;

  const PurchaseErrorEvent(this.error);

  @override
  List<Object> get props => [error];
}


class FetchWebProductsEvent extends PaywallEvent {
  const FetchWebProductsEvent();
}

class PurchaseByCouponEvent extends PaywallEvent {
  final String couponCode;

  const PurchaseByCouponEvent(this.couponCode);

  @override
  List<Object> get props => [couponCode];
}
