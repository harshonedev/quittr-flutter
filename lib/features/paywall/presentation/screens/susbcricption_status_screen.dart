import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:quittr/features/paywall/domain/entities/subscribed_product.dart';
import '../bloc/paywall_bloc.dart';

class SusbcricptionStatusScreen extends StatefulWidget {
  final SubscriptionPlanType subscriptionPlanType;
  const SusbcricptionStatusScreen({
    this.subscriptionPlanType = SubscriptionPlanType.monthly,
    super.key,
  });

  @override
  State<SusbcricptionStatusScreen> createState() =>
      _SusbcricptionStatusScreenState();
}

class _SusbcricptionStatusScreenState extends State<SusbcricptionStatusScreen> {
  bool _isSubscriptionVerified = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _completeSubscrtiption();
  }

  void _completeSubscrtiption() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return;
    }

    final doc = _firestore.collection('purchases').doc(currentUser.uid);

    final duration =
        widget.subscriptionPlanType == SubscriptionPlanType.monthly ? 30 : 365;

    // set new subscription
    final data = {
      'userId': currentUser.uid,
      'title': widget.subscriptionPlanType == SubscriptionPlanType.monthly
          ? 'Unlimited Monthly Plan'
          : 'Unlimited Yearly Plan',
      'purchaseId': 'polar_purchase_id',
      'productId': widget.subscriptionPlanType == SubscriptionPlanType.monthly
          ? 'monthly'
          : 'yearly',
      'createdAt': Timestamp.now(),
      'status': 'active',
      'duration': duration,
      'description': "NoTempt Polar Subscription",
      'price': widget.subscriptionPlanType == SubscriptionPlanType.monthly
          ? "\$9.00"
          : "\$19.00",
      'subscriptionEndDate':
          Timestamp.fromDate(DateTime.now().add(Duration(days: duration))),
      'subscriptionStartDate': Timestamp.now()
    };
    await doc.set(data, SetOptions(merge: true));
    setState(() {
      context
          .read<SubscriptionBloc>()
          .add(PurchaseUpdatedEvent(SubscribedProduct.fromJson(data)));
      _isSubscriptionVerified = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: _isSubscriptionVerified
                  ? _buildSuccessState()
                  : _buildProcessingState(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProcessingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Placeholder for animation - replace with your actual asset
        Lottie.asset(
          'assets/animations/processing.json', // Use an appropriate loading animation
          width: 200,
          height: 200,
          repeat: true,
        ),
        const SizedBox(height: 24),
        Text(
          'Processing Your Subscription',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Please wait while we verify your payment. This might take a moment...',
          style: GoogleFonts.poppins(
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        const CircularProgressIndicator(),
      ],
    );
  }

  Widget _buildSuccessState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Placeholder for animation - replace with your actual asset
        Lottie.asset(
          'assets/animations/success.json', // Use a success animation
          width: 200,
          height: 200,
          repeat: false,
        ),
        const SizedBox(height: 24),
        Text(
          'Subscription Confirmed!',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Thank you for subscribing to Quittr Premium. You now have access to all premium features!',
          style: GoogleFonts.poppins(
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            context.go('/home');
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          child: Text(
            'Go to Home',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

enum SubscriptionPlanType {
  monthly,
  yearly,
}
