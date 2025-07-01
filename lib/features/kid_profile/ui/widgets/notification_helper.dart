import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

import '../views/notification.dart';
// تأكد من إضافة مسار الـ NotificationsPage الصحيح

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationHelper {
  // نوتيفيكيشن الترحيب
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
      'We\'re happy to see you again in KidEdu!',
      platformDetails,
    );

    // إضافة النوتيفيكيشن للقائمة الداخلية
    await NotificationsPageState.addWelcomeNotification();
  }

  // نوتيفيكيشن التشجيع على التعلم
  static Future<void> showKeepLearningNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'learning_channel',
      'Learning Encouragement',
      channelDescription: 'Notifications to encourage learning',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
    
    await flutterLocalNotificationsPlugin.show(
      1,
      '🎯 Keep Learning!',
      'Keep learning to gain more points!',
      platformDetails,
    );

    // إضافة النوتيفيكيشن للقائمة الداخلية
    await NotificationsPageState.addKeepLearningNotification();
  }

  // نوتيفيكيشن إضافة كورس جديد للمدرس
  static Future<void> showCourseAddedNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'course_added_channel',
      'Course Added Notifications',
      channelDescription: 'Notifications when instructor adds new course',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
    
    await flutterLocalNotificationsPlugin.show(
      2,
      '✅ Course Added Successfully!',
      'You added new course successfully',
      platformDetails,
    );

    // إضافة النوتيفيكيشن للقائمة الداخلية
    await NotificationsPageState.addCourseAddedNotification();
  }

  // نوتيفيكيشن إنهاء الكورس
  static Future<void> showCourseCompletedNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'course_completed_channel',
      'Course Completion Notifications',
      channelDescription: 'Notifications when course is completed',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
    
    await flutterLocalNotificationsPlugin.show(
      3,
      '🎉 Course Completed!',
      'Congratulations! You just finished your course',
      platformDetails,
    );

    // إضافة النوتيفيكيشن للقائمة الداخلية
    await NotificationsPageState.addCourseCompletedNotification();
  }

  // النوتيفيكيشن الأصلية
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
      4,
      title,
      message,
      platformDetails,
    );

    // إضافة نوتيفيكيشن مخصص للقائمة الداخلية
    await NotificationsPageState.addNotification(
      title: title,
      message: message,
      icon: Icons.notifications,
      color: Colors.blue,
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
      5,
      '🎉 Achievement Unlocked!',
      'Congratulations! You\'ve completed a course!',
      platformDetails,
    );

    // إضافة النوتيفيكيشن للقائمة الداخلية
    await NotificationsPageState.addAchievementNotification();
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
      6,
      'Payment Successful 💳',
      'You have successfully paid for $courseName!',
      platformDetails,
    );

    // إضافة النوتيفيكيشن للقائمة الداخلية
    await NotificationsPageState.addPaymentNotification(courseName);
  }

  static Future<void> showCourseEnrolledNotification([String? courseName]) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'enroll_channel',
      'Course Notifications',
      channelDescription: 'Notifications about course activities',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
    
    String message = courseName != null 
        ? 'You have successfully enrolled in $courseName!'
        : 'You have successfully enrolled in a new course!';
    
    await flutterLocalNotificationsPlugin.show(
      7,
      'Enrollment Confirmed 🎉',
      message,
      platformDetails,
    );

    // إضافة النوتيفيكيشن للقائمة الداخلية
    await NotificationsPageState.addCourseEnrolledNotification(
      courseName ?? 'the course'
    );
  }

  // دالة مساعدة لاستدعاء نوتيفيكيشن الترحيب والتشجيع معاً
  static Future<void> showWelcomeAndKeepLearningNotifications() async {
    await showWelcomeNotification();
    
    // تأخير بسيط لإظهار النوتيفيكيشن الثانية
    await Future.delayed(const Duration(seconds: 2));
    await showKeepLearningNotification();
  }

  // دالة لإظهار نوتيفيكيشن مخصص
  static Future<void> showCustomNotification({
    required int id,
    required String title,
    required String message,
    required String channelId,
    required String channelName,
    String? channelDescription,
    IconData icon = Icons.notifications,
    Color color = Colors.blue,
  }) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription ?? 'Custom notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
    
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      message,
      platformDetails,
    );

    // إضافة النوتيفيكيشن للقائمة الداخلية
    await NotificationsPageState.addNotification(
      title: title,
      message: message,
      icon: icon,
      color: color,
    );
  }
}