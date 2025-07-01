import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../core/widgets/appbar.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      isLoading = true;
    });

    // تحميل النوتيفيكيشنز المحفوظة من SharedPreferences
    List<Map<String, dynamic>> loadedNotifications = await _getSavedNotifications();

    setState(() {
      notifications = loadedNotifications;
      isLoading = false;
    });
  }

  // تحميل النوتيفيكيشنز المحفوظة
  Future<List<Map<String, dynamic>>> _getSavedNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedNotifications = prefs.getStringList('notifications');
    
    if (savedNotifications == null || savedNotifications.isEmpty) {
      return [];
    }

    List<Map<String, dynamic>> notifications = [];
    for (String notificationString in savedNotifications) {
      Map<String, dynamic> notification = jsonDecode(notificationString);
      // تحويل التاريخ من String إلى DateTime
      notification['timestamp'] = DateTime.parse(notification['timestamp']);
      notifications.add(notification);
    }

    // ترتيب النوتيفيكيشنز حسب الوقت (الأحدث أولاً)
    notifications.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

    return notifications;
  }

  // إضافة نوتيفيكيشن جديد
  static Future<void> addNotification({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedNotifications = prefs.getStringList('notifications') ?? [];

    Map<String, dynamic> newNotification = {
      'title': title,
      'message': message,
      'icon': icon.codePoint,
      'color': color.value,
      'timestamp': DateTime.now().toIso8601String(),
    };

    savedNotifications.insert(0, jsonEncode(newNotification));
    
    // الاحتفاظ بآخر 50 نوتيفيكيشن فقط
    if (savedNotifications.length > 50) {
      savedNotifications = savedNotifications.take(50).toList();
    }

    await prefs.setStringList('notifications', savedNotifications);
  }

  // دوال إضافة النوتيفيكيشنز المختلفة
  static Future<void> addWelcomeNotification() async {
    await addNotification(
      title: 'Welcome Back!',
      message: 'We\'re happy to see you again in KidEdu!',
      icon: Icons.waving_hand,
      color: Colors.amber,
    );
  }

  static Future<void> addKeepLearningNotification() async {
    await addNotification(
      title: 'Keep Learning!',
      message: 'Keep learning to gain more points!',
      icon: Icons.celebration,
      color: Colors.purple,
    );
  }

  static Future<void> addCourseAddedNotification() async {
    await addNotification(
      title: 'Course Added Successfully!',
      message: 'You added new course successfully',
      icon: Icons.add_circle_outline,
      color: Colors.green,
    );
  }

  static Future<void> addCourseCompletedNotification() async {
    await addNotification(
      title: 'Course Completed!',
      message: 'Congratulations! You just finished your course',
      icon: Icons.school,
      color: Colors.blue,
    );
  }

  static Future<void> addPaymentNotification(String courseName) async {
    await addNotification(
      title: 'Payment Successful',
      message: 'You have successfully paid for $courseName!',
      icon: Icons.payment,
      color: Colors.green,
    );
  }

  static Future<void> addAchievementNotification() async {
    await addNotification(
      title: 'Achievement Unlocked!',
      message: 'Congratulations! You\'ve completed a course!',
      icon: Icons.emoji_events,
      color: Colors.orange,
    );
  }

  static Future<void> addCourseEnrolledNotification(String courseName) async {
    await addNotification(
      title: 'Enrollment Confirmed',
      message: 'You have successfully enrolled in $courseName!',
      icon: Icons.bookmark_add,
      color: Colors.blue,
    );
  }

  // مسح كل النوتيفيكيشنز
  // Future<void> _clearAllNotifications() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('notifications');
  //   await _loadNotifications();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
        onBackPressed: () => Navigator.pop(context),
        // actions: [
        //   if (notifications.isNotEmpty)
        //     IconButton(
        //       icon: const Icon(Icons.clear_all),
        //       onPressed: () {
        //         showDialog(
        //           context: context,
        //           builder: (context) => AlertDialog(
        //             title: const Text('Clear Notifications'),
        //             content: const Text('Are you sure you want to clear all notifications?'),
        //             actions: [
        //               TextButton(
        //                 onPressed: () => Navigator.pop(context),
        //                 child: const Text('Cancel'),
        //               ),
        //               TextButton(
        //                 onPressed: () {
        //                   Navigator.pop(context);
        //                   _clearAllNotifications();
        //                 },
        //                 child: const Text('Clear'),
        //               ),
        //             ],
        //           ),
        //         );
        //       },
        //     ),
        // ],
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadNotifications,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      if (notifications.isEmpty)
                        _buildEmptyState()
                      else
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            return _buildNotificationCard(
                              notification['title'],
                              notification['message'],
                              IconData(notification['icon'], fontFamily: 'MaterialIcons'),
                              Color(notification['color']),
                              notification['timestamp'],
                            );
                          },
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Icon(
            Icons.notifications_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll notify you when something new happens!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(String title, String message, IconData icon, 
      Color color, DateTime timestamp) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(timestamp),
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ],
        ),
        onTap: () {
          _handleNotificationTap(title);
        },
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  void _handleNotificationTap(String title) {
    print('Notification tapped: $title');
  }
}