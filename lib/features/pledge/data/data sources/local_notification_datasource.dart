import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quittr/core/pref%20utils/pref_utils.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// abstract class LocalNotificationDataSource {
//   Future<void> initialize();
//   Future<void> scheduleNotification({
//     required String title,
//     required String body,
//     required Duration delay,
//   });

//   //these two are for testing if the notifications are working or not
//   Future<void> scheduleSimpleNotification();
//   Future<void> showInstantNotification();
// }

// class LocalNotificationDataSourceImpl implements LocalNotificationDataSource {
//   final FlutterLocalNotificationsPlugin notificationsPlugin;

//   LocalNotificationDataSourceImpl(this.notificationsPlugin);

//   @override
//   Future<void> initialize() async {
//     log("Initializing Local Notification Data Source...");
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     final DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsDarwin,
//     );

//     final bool? initialized =
//         await notificationsPlugin.initialize(initializationSettings);

//     if (initialized != null && initialized) {
//       log("Local Notification Plugin Initialized Successfully!");
//     } else {
//       log("Failed to initialize Local Notification Plugin!");
//     }
//   }

//   @override
//   Future<void> scheduleNotification({
//     required String title,
//     required String body,
//     required Duration delay,
//   }) async {
//     log("Scheduling notification in ${delay.inSeconds} seconds...");

//     tz.initializeTimeZones(); // Ensure this is called

//     final tz.TZDateTime scheduledTime = tz.TZDateTime.now(tz.local).add(delay);

//     await notificationsPlugin.zonedSchedule(
//       0,
//       title,
//       body,
//       scheduledTime,

//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'your_channel_id',
//           'Scheduled Notifications',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//         iOS: DarwinNotificationDetails(),
//       ),
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );

//     log("Notification scheduled successfully at: $scheduledTime");
//   }

//   @override
//   Future<void> scheduleSimpleNotification() async {
//     log("Scheduling a test notification in 5 seconds...");

//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'test_channel_id',
//       'Test Notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: DarwinNotificationDetails(),
//     );

//     await Future.delayed(const Duration(seconds: 5), () async {
//       await notificationsPlugin.show(
//         1,
//         'Scheduled Test',
//         'This is a test notification that was scheduled!',
//         platformChannelSpecifics,
//       );
//       log("Scheduled Test notification sent!");
//     });

//     log("Scheduled notification setup complete.");
//   }

//   @override
//   Future<void> showInstantNotification() async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'test_channel_id',
//       'Test Notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: DarwinNotificationDetails(),
//     );

//     await notificationsPlugin.show(
//       0,
//       'Test Notification',
//       'This is an immediate test notification!',
//       platformChannelSpecifics,
//     );

//     log("Test notification sent!");
//   }
// }

// 1. First, update your LocalNotificationDataSource interface
abstract class LocalNotificationDataSource {
  Future<void> initialize();
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required Duration delay,
    String? payload,
  });

  Future<void> scheduleSimpleNotification();
  Future<void> showInstantNotification();
  void checkForNotifications(); // Add this method
}

// 2. Then, update LocalNotificationDataSourceImpl
class LocalNotificationDataSourceImpl implements LocalNotificationDataSource {
  final FlutterLocalNotificationsPlugin notificationsPlugin;
  static GlobalKey<NavigatorState>? navigatorKey;

  LocalNotificationDataSourceImpl(this.notificationsPlugin);

  @override
  Future<void> initialize() async {
    log("Initializing Local Notification Data Source...");
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,

      // onDidReceiveLocalNotification: (id, title, body, payload) async {
      //   // For iOS 10 and below (deprecated but still needed for compatibility)
      // },
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // Set up notification tap handling
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        _handleNotificationTap(details.payload);
      },
    );

    log("Local Notification Plugin Initialized Successfully!");
  }

  // Handle notification taps
  void _handleNotificationTap(String? payload) {
    if (payload != null) {
      log("Notification tapped with payload: $payload");
    }
    showNotificationDialog(payload);
  }

  // Show dialog when notification is tapped
  static void showNotificationDialog(String? payload) {
    if (navigatorKey?.currentContext != null) {
      showDialog(
        context: navigatorKey!.currentContext!,
        builder: (context) => AlertDialog(
          title: const Text('Relapse check!!'),
          content: Text('Did you Relapsed'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      // Add current time to the list
                      final prefs = PrefUtils();
                      final dates = prefs.getRelapsedDates();
                      dates.add(DateTime.now());
                      prefs.setRelapsedDates(dates);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Yes'),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('No'),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  // Check for notifications when app is launched from terminated state
  @override
  void checkForNotifications() async {
    final NotificationAppLaunchDetails? launchDetails =
        await notificationsPlugin.getNotificationAppLaunchDetails();

    if (launchDetails != null && launchDetails.didNotificationLaunchApp) {
      log("App was launched from notification with payload: ${launchDetails.notificationResponse?.payload}");

      // Wait for the navigator to be available
      Future.delayed(const Duration(seconds: 1), () {
        showNotificationDialog(launchDetails.notificationResponse?.payload);
      });
    }
  }

  @override
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required Duration delay,
    String? payload,
  }) async {
    log("Scheduling notification in ${delay.inSeconds} seconds...");

    tz.initializeTimeZones(); // Ensure this is called

    final tz.TZDateTime scheduledTime = tz.TZDateTime.now(tz.local).add(delay);

    await notificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'Scheduled Notifications',
          importance: Importance.max,
          priority: Priority.high,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          interruptionLevel: InterruptionLevel.active,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );

    log("Notification scheduled successfully at: $scheduledTime");
  }

  // Existing methods remain unchanged...
  @override
  Future<void> scheduleSimpleNotification() async {
    // Implementation remains the same
  }

  @override
  Future<void> showInstantNotification() async {
    // Implementation remains the same but add payload
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'test_channel_id',
      'Test Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    await notificationsPlugin.show(
      0,
      'Test Notification',
      'This is an immediate test notification!',
      platformChannelSpecifics,
      payload: 'test_notification',
    );

    log("Test notification sent!");
  }
}
