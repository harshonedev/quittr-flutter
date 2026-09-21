import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/core/usecases/usecase.dart';
import 'package:quittr/features/paywall/domain/entities/product.dart';
import 'package:quittr/features/paywall/domain/entities/subscribed_product.dart';
import 'package:quittr/features/paywall/domain/usecases/check_subscription_status.dart';
import 'package:quittr/features/paywall/domain/usecases/dispose_subscription.dart';
import 'package:quittr/features/paywall/domain/usecases/purchase_by_coupon.dart';
import 'package:quittr/features/paywall/domain/usecases/purchase_web_product.dart';
import 'package:quittr/features/paywall/domain/usecases/restore_purchaces.dart';
import 'package:quittr/features/paywall/domain/usecases/start_listening_updates.dart';
import '../../domain/usecases/get_subscriptions.dart';
import '../../domain/usecases/initialize_purchases.dart';
import '../../domain/usecases/purchase_product.dart';
import '../../domain/usecases/get_purchase_updates.dart';

part 'paywall_event.dart';
part 'paywall_state.dart';
//new bloc

class SubscriptionBloc extends Bloc<PaywallEvent, IAPState> {
  final CheckSubscriptionAvailabilityUseCase _checkAvailabilityUseCase;
  final FetchProductsUseCase _fetchProductsUseCase;
  final PurchaseProductUseCase _purchaseProductUseCase;
  final ListenToPurchaseUpdatesUseCase _listenToPurchaseUpdatesUseCase;
  final RestorePurchasesUseCase _restorePurchasesUseCase;
  final DisposeSubscriptionUseCase _disposeSubscriptionUseCase;
  final CheckSubscriptionStatusUseCase _checkSubscriptionStatusUseCase;
  final StartListeningUpdatesUseCase _startListeningUpdatesUseCase;
  final PurchaseByCoupon _purchaseByCouponUseCase;

  StreamSubscription<List<PurchaseDetails>>? _purchaseUpdatesSubscription;

  SubscriptionBloc({
    required CheckSubscriptionAvailabilityUseCase checkAvailabilityUseCase,
    required FetchProductsUseCase fetchProductsUseCase,
    required PurchaseProductUseCase purchaseProductUseCase,
    required ListenToPurchaseUpdatesUseCase listenToPurchaseUpdatesUseCase,
    required RestorePurchasesUseCase restorePurchasesUseCase,
    required DisposeSubscriptionUseCase disposeSubscriptionUseCase,
    required CheckSubscriptionStatusUseCase checkSubscriptionStatusUseCase,
    required StartListeningUpdatesUseCase startListeningUpdatesUseCase,
    required PurchaseByCoupon purchaseByCouponUseCase,
    required PurchaseWebProduct purchaseWebProductUseCase,
  })  : _checkAvailabilityUseCase = checkAvailabilityUseCase,
        _fetchProductsUseCase = fetchProductsUseCase,
        _purchaseProductUseCase = purchaseProductUseCase,
        _listenToPurchaseUpdatesUseCase = listenToPurchaseUpdatesUseCase,
        _restorePurchasesUseCase = restorePurchasesUseCase,
        _disposeSubscriptionUseCase = disposeSubscriptionUseCase,
        _checkSubscriptionStatusUseCase = checkSubscriptionStatusUseCase,
        _startListeningUpdatesUseCase = startListeningUpdatesUseCase,
        _purchaseByCouponUseCase = purchaseByCouponUseCase,
        super(IAPInitialState()) {
    on<CheckIAPAvailabilityEvent>(_onCheckAvailability);
    on<FetchProductsEvent>(_onFetchProducts);
    on<PurchaseProductEvent>(_onPurchaseProduct);
    on<StartListeningToPurchaseUpdatesEvent>(
        _onStartListeningToPurchaseUpdates);
    on<RestorePurchasesEvent>(_onRestorePurchases);
    on<CheckSubscriptionEvent>(_onCheckSubscription);
    on<PurchaseUpdatedEvent>(_onPurchaseUpdated);
    on<PurchaseErrorEvent>(_onPurchaseError);
    on<FetchWebProductsEvent>(_onFetchWebProducts);
    on<PurchaseByCouponEvent>(_onPurchaseByCoupon);
  }

  Future<void> _onCheckSubscription(
      CheckSubscriptionEvent event, Emitter<IAPState> emit) async {
    final result = await _checkSubscriptionStatusUseCase(event.userId);

    result
        .fold((failure) => emit(IAPErrorState('Failed to verify subscription')),
            (subscribedProduct) {
      if (subscribedProduct != null) {
        emit(SubscribedState(subscribedProduct));
      } else {
        emit(SubscriptionStatusState(false));
      }
    });
  }

  Future<void> _onPurchaseByCoupon(
      PurchaseByCouponEvent event, Emitter<IAPState> emit) async {
    final result = await _purchaseByCouponUseCase(event.couponCode);
    result.fold((failure) => emit(IAPErrorState('Purchase by coupon failed')),
        (subscribedProduct) => emit(SubscribedState(subscribedProduct)));
  }

  void _onPurchaseError(PurchaseErrorEvent event, Emitter<IAPState> emit) {
    // Handle purchase error
    emit(IAPErrorState(event.error));
  }

  void _onPurchaseUpdated(PurchaseUpdatedEvent event, Emitter<IAPState> emit) {
    // Handle the purchase updates here
    log('Purchase updated: ${event.product}');
    emit(SubscribedState(event.product));
  }

  Future<void> _onCheckAvailability(
      CheckIAPAvailabilityEvent event, Emitter<IAPState> emit) async {
    emit(IAPAvailabilityLoadingState());
    final result = await _checkAvailabilityUseCase(NoParams());

    result.fold(
      (failure) => emit(IAPErrorState('IAP not available')),
      (isAvailable) => emit(IAPAvailableState(isAvailable)),
    );
  }

  Future<void> _onFetchProducts(
      FetchProductsEvent event, Emitter<IAPState> emit) async {
    emit(ProductsFetchingState());
    final result =
        await _fetchProductsUseCase(FetchProductsParams(event.productIds));

    result.fold((failure) => emit(IAPErrorState('Failed to fetch products')),
        (products) {
      emit(ProductsFetchedState(products));
    });
  }

  Future<void> _onFetchWebProducts(
      FetchWebProductsEvent event, Emitter<IAPState> emit) async {
    emit(ProductsFetchingState());
    // Hard Coded products for web products
    final products = [
      Product(
          productId: "f272d186-aa8f-4dca-be5e-92aef029bdb2",
          id: 'monthly',
          title: 'Unlimited Plan',
          description: 'NoTempt Platinum Plan',
          price: 9.00,
          body: 'Notempt Subscription',
          label: 'Unlimted Monthly Plan',
          localizedPrice: "\$9.00",
          currencyCode: 'usd',
          duration: 30,
          currencySymbol: '\$',
          paymentUrl:
              "https://buy.polar.sh/polar_cl_wWHDrroxc1ng8D3goZlDThHQ3YX3CBFWgAa7P3YteJ8"),
      Product(
          productId: "ff8d1e0b-4818-4267-b327-b720e1e1fa14",
          id: 'yearly',
          title: 'Unlimited Plan',
          description: 'NoTempt Diamond Plan',
          price: 19.00,
          body: 'Notempt Subscription',
          label: 'Unlimited Yearly Plan',
          localizedPrice: "\$19.00",
          currencyCode: 'usd',
          duration: 365,
          currencySymbol: '\$',
          paymentUrl:
              "https://buy.polar.sh/polar_cl_5SWVsbYUXyKL7Vm3lVWGNy4c0XC8EcVSSxPBm4eBnKu")
    ];

    emit(ProductsFetchedState(products));
  }

  Future<void> _onPurchaseProduct(
      PurchaseProductEvent event, Emitter<IAPState> emit) async {
    if (state is! ProductsFetchedState) {
      return;
    }
    final currentState = state as ProductsFetchedState;
    emit(PurchaseProcessingState(products: currentState.products));
    final result = await _purchaseProductUseCase(PurchaseParams(event.product));
    result.fold(
        (failure) => emit(IAPErrorState('Purchase failed')),
        (success) => emit(
              PurchaseProcessingState(products: currentState.products),
            ));
  }

  void _onStartListeningToPurchaseUpdates(
      StartListeningToPurchaseUpdatesEvent event,
      Emitter<IAPState> emit) async {
    _startListeningUpdatesUseCase(NoParams());
    final stream = _listenToPurchaseUpdatesUseCase(NoParams());

    stream.listen((result) {
      result.fold(
        (failure) {
          if (failure is IAPError) {
            add(PurchaseErrorEvent("Purchase failed"));
          } else if (failure is AuthFailure) {
            add(PurchaseErrorEvent('No authenticated'));
          } else if (failure is PurchaseFailedFailure) {
            add(PurchaseErrorEvent('Purchase failed'));
          } else if (failure is PurchaseCancelledFailure) {
            add(PurchaseErrorEvent('Purchase cancelled'));
          } else if (failure is PurchasePendingFailure) {
            add(PurchaseErrorEvent('Purchase pending'));
          } else {
            add(PurchaseErrorEvent('Unknown error: $failure'));
          }
        },
        (subscribedProduct) {
          // Handle the subscribed product
          add(PurchaseUpdatedEvent(
            subscribedProduct,
          ));
        },
      );
    }, onError: (error) {
      emit(IAPErrorState('Error listening to purchase updates: $error'));
    });
  }

  Future<void> _onRestorePurchases(
      RestorePurchasesEvent event, Emitter<IAPState> emit) async {
    emit(RestoringPurchasesState());
    final result = await _restorePurchasesUseCase(NoParams());

    result.fold(
      (failure) => emit(IAPErrorState('Failed to restore purchases')),
      (_) => emit(PurchasesRestoredState()),
    );
  }

  Future<void> _onDisposeSubscription() async {
    _purchaseUpdatesSubscription?.cancel();
    await _disposeSubscriptionUseCase(NoParams());
  }

  @override
  Future<void> close() {
    _onDisposeSubscription();
    return super.close();
  }
}
