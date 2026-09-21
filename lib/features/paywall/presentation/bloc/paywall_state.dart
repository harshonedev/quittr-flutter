part of 'paywall_bloc.dart';

// States for the SubscriptionBloc
abstract class IAPState extends Equatable {
  @override
  List<Object> get props => [];
}

class IAPInitialState extends IAPState {}

class IAPAvailabilityLoadingState extends IAPState {}

class IAPAvailableState extends IAPState {
  final bool isAvailable;

  IAPAvailableState(this.isAvailable);

  @override
  List<Object> get props => [isAvailable];
}

class ProductsFetchingState extends IAPState {}

class ProductsFetchedState extends IAPState {
  final List<Product> products;

  ProductsFetchedState(this.products);

  @override
  List<Object> get props => [products];
}

class IAPErrorState extends IAPState {
  final String errorMessage;

  IAPErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class PurchaseProcessingState extends IAPState {
  final List<Product> products;
  final String? paymentUrl;
  PurchaseProcessingState({
    required this.products,
    this.paymentUrl,
  });
  @override
  List<Object> get props => [products, paymentUrl ?? ''];
}

class PurchaseSuccessState extends IAPState {
  final bool success;

  PurchaseSuccessState(this.success);

  @override
  List<Object> get props => [success];
}

class SubscriptionStatusState extends IAPState {
  final bool isSubscribed;

  SubscriptionStatusState(this.isSubscribed);

  @override
  List<Object> get props => [isSubscribed];
}

class SubscribedState extends IAPState {
  final SubscribedProduct subscribedProduct;

  SubscribedState(this.subscribedProduct);

  @override
  List<Object> get props => [subscribedProduct];
}

class RestoringPurchasesState extends IAPState {}

class PurchasesRestoredState extends IAPState {}

class PurchaseUpdatesState extends IAPState {
  final List<PurchaseDetails> purchaseDetails;

  PurchaseUpdatesState(this.purchaseDetails);

  @override
  List<Object> get props => [purchaseDetails];
}
