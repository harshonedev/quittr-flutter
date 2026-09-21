import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

import '../../domain/entities/subscribed_product.dart';
import '../bloc/paywall_bloc.dart';

class SubscriptionManagementScreen extends StatefulWidget {
  const SubscriptionManagementScreen({super.key});

  @override
  State<SubscriptionManagementScreen> createState() =>
      _SubscriptionManagementScreenState();
}

class _SubscriptionManagementScreenState
    extends State<SubscriptionManagementScreen> {
  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // User is not logged in, redirect to login screen in a post-frame callback
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go('/login');
        }
      });
      return;
    }

    // Check subscription status
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SubscriptionBloc>().add(
              CheckSubscriptionEvent(userId: user.uid),
            );
      }
    });
  }

  Future<void> _launchManageSubscriptions() async {
    if (!mounted) return;

    String url;

    if (Platform.isAndroid) {
      // Open Google Play subscription management page
      url = 'https://play.google.com/store/account/subscriptions';
    } else if (Platform.isIOS) {
      // Open iOS settings for subscription management
      url = 'https://apps.apple.com/account/subscriptions';
    } else {
      // Unsupported platform
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Subscription management is not supported on this platform.'),
        ),
      );
      return;
    }

    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open subscription settings'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Subscription',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocBuilder<SubscriptionBloc, IAPState>(
        builder: (context, state) {
          if (state is IAPAvailabilityLoadingState ||
              state is ProductsFetchingState ||
              state is RestoringPurchasesState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SubscribedState) {
            return _buildSubscribedContent(context, state.subscribedProduct);
          } else if (state is IAPErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.errorMessage}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            );
          } else {
            // No subscription or other states
            return _buildNoSubscriptionContent(context);
          }
        },
      ),
    );
  }

  Widget _buildSubscribedContent(
      BuildContext context, SubscribedProduct subscription) {
    String formattedEndDate =
        "${subscription.subscriptionEndDate.day}/${subscription.subscriptionEndDate.month}/${subscription.subscriptionEndDate.year}";

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Subscription',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 24),
          _buildInfoCard(
            context,
            leading: Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
              size: 36,
            ),
            title: 'Active Subscription',
            description: 'You have an active ${subscription.title} plan',
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            leading: Icon(
              Icons.calendar_today,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: 'Next Renewal',
            description: 'Your subscription will renew on $formattedEndDate',
          ),
          const SizedBox(height: 24),
          if (!kIsWeb)
            FilledButton.icon(
              onPressed: _launchManageSubscriptions,
              icon: const Icon(Icons.settings),
              label: const Text('Manage Subscription'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNoSubscriptionContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Subscription',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 24),
          _buildInfoCard(
            context,
            leading: Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.error,
              size: 36,
            ),
            title: 'No Active Subscription',
            description: 'You don\'t have an active subscription',
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              if (!mounted) return;

              context.pop();
              context.go('/paywall');
            },
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Subscribe Now',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required Widget leading,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
