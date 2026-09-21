import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:quittr/core/routing/app_router.dart';
import 'package:quittr/features/paywall/domain/entities/product.dart';
import 'package:quittr/features/paywall/domain/entities/subscribed_product.dart';
import '../bloc/paywall_bloc.dart';
import 'paywall_web_stub.dart' if (dart.library.html) 'paywall_web.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  Product? selectedProduct;

  @override
  void initState() {
    super.initState();

    final productIds = !kIsWeb && Platform.isIOS
        ? {'weekly1', 'monthly1', 'yearly1'}
        : {'notempt'};

    final state = context.read<SubscriptionBloc>().state;

    if (state is SubscribedState &&
        state.subscribedProduct.status == SubscriptionStatus.active) {
      // If already subscribed, redirect to home
      context.go('/home');
      return;
    }

    if (kIsWeb) {
      context.read<SubscriptionBloc>().add(
            FetchWebProductsEvent(),
          );
    } else {
      context.read<SubscriptionBloc>()
        ..add(CheckIAPAvailabilityEvent())
        ..add(StartListeningToPurchaseUpdatesEvent())
        ..add(FetchProductsEvent(productIds));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubscriptionBloc, IAPState>(
      listener: (context, state) {
        if (state is IAPErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
        if (state is SubscribedState) {
          AppRouter.isSubscribed = true;
          context.go('/home');
        }
        if (state is IAPAvailableState && !state.isAvailable) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('In-App Purchases are not available')),
          );
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primaryContainer.withAlpha(76),
                Theme.of(context).colorScheme.surface,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAppBar(),
                          const SizedBox(height: 24),
                          BlocBuilder<SubscriptionBloc, IAPState>(
                            buildWhen: (previous, current) =>
                                current is ProductsFetchedState ||
                                current is ProductsFetchingState,
                            builder: (context, state) {
                              if (state is ProductsFetchingState) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(32.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              if (state is ProductsFetchedState ||
                                  state is PurchaseProcessingState) {
                                final List<Product> products =
                                    state is ProductsFetchedState
                                        ? state.products
                                        : state is PurchaseProcessingState
                                            ? state.products
                                            : [];

                                if (products.isEmpty) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(32.0),
                                      child: Text(
                                        'No products available',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  );
                                }
                                return ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: products.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final product = products[index];
                                    return _SubscriptionCard(
                                      product: product,
                                      isSelected: selectedProduct?.productId ==
                                          product.productId,
                                      onSelected: (selected) {
                                        setState(() {
                                          selectedProduct =
                                              selected ? product : null;
                                        });
                                      },
                                    );
                                  },
                                );
                              }
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32.0),
                                  child: Text(
                                    'No products available',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(12),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BlocBuilder<SubscriptionBloc, IAPState>(
                          builder: (context, state) {
                            final isProcessing =
                                state is PurchaseProcessingState ||
                                    state is RestoringPurchasesState;
                            return FilledButton(
                              onPressed: isProcessing || selectedProduct == null
                                  ? null
                                  : () {
                                      if (kIsWeb) {
                                        launchPaymentUrl(
                                            selectedProduct!.paymentUrl);
                                      } else {
                                        context.read<SubscriptionBloc>().add(
                                              PurchaseProductEvent(
                                                selectedProduct!,
                                              ),
                                            );
                                      }
                                    },
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: isProcessing
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                  : Text(
                                      'Subscribe',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!kIsWeb) ...[
                              TextButton(
                                onPressed: () {
                                  context
                                      .read<SubscriptionBloc>()
                                      .add(RestorePurchasesEvent());
                                },
                                child: Text(
                                  'Restore Purchase',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                            ],
                            TextButton(
                              onPressed: () {
                                context.push('/terms');
                              },
                              child: Text(
                                'Terms of Service',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Your Plan',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select the plan that works best for you',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          const Spacer(),
          // Remove close button to force subscription
          // IconButton(
          //   icon: const Icon(Icons.close),
          //   onPressed: () {
          //     context.go('/home');
          //   },
          // ),
        ],
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final Product product;
  final bool isSelected;
  final Function(bool) onSelected;

  const _SubscriptionCard({
    required this.product,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 2 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => onSelected(!isSelected),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: isSelected,
                onChanged: (value) => onSelected(value ?? false),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    product.localizedPrice,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    _getPeriodText(product.duration),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPeriodText(int duration) {
    if (duration == 30) return 'per month';
    if (duration == 365) return 'per year';
    return 'per week';
  }
}
