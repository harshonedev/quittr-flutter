import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quittr/core/pref%20utils/pref_utils.dart';
import 'package:quittr/core/widgets/app_rating_dialog.dart';
import 'package:quittr/features/achievements/presentation/bloc/achievements_bloc.dart';
import 'package:quittr/features/home/presentation/bloc/home_bloc.dart';
import 'package:quittr/features/pledge/data/data%20sources/local_notification_datasource.dart';
import 'package:quittr/features/relapse_tracker/presentation/bloc/relapse_tracker_bloc.dart';
import 'package:quittr/features/relapse_tracker/presentation/screens/relapse_tracker_screen.dart';
import 'package:quittr/core/injection_container.dart' as di;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //int _currentIndex = 0;

  // final List<Widget> _screens = [
  //   const RelapseTrackerScreen(),
  //   const LibraryScreen(), // Library tab
  //   const ProfileScreen(), // Profile tab
  // ];

  @override
  void initState() {
    // Initialize the HomeBloc to start tracking usage time
    BlocProvider.of<HomeBloc>(context).add(StartTrackUssageTimeEvent());

    if (PrefUtils().getRelapsedDates().isNotEmpty) {
      // Check for notification launch after app is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final localNotificationDataSource =
            di.sl<LocalNotificationDataSourceImpl>();
        localNotificationDataSource
            .checkForNotifications(); // Check for notifications
        LocalNotificationDataSourceImpl.showNotificationDialog(
            null); // Show dialog on app start
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<RelapseTrackerBloc>(
            create: (context) => di.sl<RelapseTrackerBloc>(),
          ),
          BlocProvider<AchievementsBloc>(
            create: (context) => di.sl<AchievementsBloc>(),
          ),
        ],
        child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is ShowRatingDialogState) {
                _showRatingDialog();
              }
            },
            child: const RelapseTrackerScreen()),
      ),
    );
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) => AppRatingDialog(
        onRatingSelected: (rating) {
          // You could log the rating internally
          debugPrint('User rated the app: $rating stars');
          // set the last rating prompt time
          BlocProvider.of<HomeBloc>(context).add(SetLastRatingPromptEvent());

          // show a thank you message in snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Thank you for your rating!')),
          );
        },
        onPlayStoreRatingRequested: () {

         if(Platform.isAndroid) {
           _showPlayStoreRatingRequest();
         }
        },
      ),
    );
  }

  void _showPlayStoreRatingRequest() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rate us on Play Store'),
        content: const Text(
            'Enjoying the app? Please consider rating us on the Play Store!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Not Now'),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              // Trigger the event to open the Play Store
              BlocProvider.of<HomeBloc>(context).add(OpenPlayStoreEvent());
            },
            child: const Text('Rate Now'),
          ),
        ],
      ),
    );
  }
}
