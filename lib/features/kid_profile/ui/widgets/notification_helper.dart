import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationHelper {
  static Future<void> showWelcomeNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'welcome_channel',
      'Welcome Notifications',
      channelDescription: 'Notifications shown when app is opened',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      '👋 Welcome Back!',
      'We’re happy to see you again in KidEdu!',
      platformDetails,
    );
  }

   static Future<void> showCourseNotification(String title, String message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'course_channel',
      'Course Notifications',
      channelDescription: 'Notifications for course updates',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      1,
      title,
      message,
      platformDetails,
    );
  }

  static Future<void> showAchievementNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'achievement_channel',
      'Achievement Notifications',
      channelDescription: 'Notifications for achievements',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      2,
      '🎉 Achievement Unlocked!',
      'Congratulations! You\'ve completed a course!',
      platformDetails,
    );
  }


  static Future<void> showPaymentNotification(String courseName) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'payment_channel',
      'Payment Notifications',
      channelDescription: 'Notifications after course payment',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      2,
      'Payment Successful 💳',
      'You have successfully paid for $courseName!',
      platformDetails,
    );
  }

  static Future<void> showCourseEnrolledNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'enroll_channel',
      'Course Notifications',
      channelDescription: 'Notifications about course activities',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      1,
      'Enrollment Confirmed 🎉',
      'You have successfully enrolled in a new course!',
      platformDetails,
    );
  }
}
