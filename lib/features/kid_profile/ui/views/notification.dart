import 'package:flutter/material.dart';
import '../../../../core/widgets/appbar.dart';


class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
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

    await Future.delayed(const Duration(seconds: 1));

    List<Map<String, dynamic>> loadedNotifications = await _getNotificationsBasedOnUserState();

    setState(() {
      notifications = loadedNotifications;
      isLoading = false;
    });
  }

  Future<List<Map<String, dynamic>>> _getNotificationsBasedOnUserState() async {
    List<Map<String, dynamic>> dynamicNotifications = [];

    dynamicNotifications.add({
      'title': 'Welcome Back!',
      'message': 'We\'re happy to see you again in KidEdu!',
      'icon': Icons.waving_hand,
      'color': Colors.amber,
      'timestamp': DateTime.now(),
    });

    // هنا هتضيف النوتيفكيشن التانية حسب الحالات اللي إنت عايزها

    /*
    bool hasNewCourse = await _checkForNewCourses();
    if (hasNewCourse) {
      dynamicNotifications.add({
        'title': 'New Course Added',
        'message': 'A new course has been added! Check it out now!',
        'icon': Icons.add_circle_outline,
        'color': Colors.blue,
        'timestamp': DateTime.now(),
      });
    }
    */

    dynamicNotifications.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

    return dynamicNotifications;
  }

  // void _addNewCourseNotification() {
  //   setState(() {
  //     notifications.insert(0, {
  //       'title': 'New Course Added',
  //       'message': 'A new course has been added! Check it out now!',
  //       'icon': Icons.add_circle_outline,
  //       'color': Colors.blue,
  //       'timestamp': DateTime.now(),
  //     });
  //   });
  // }

  // void _addCompletedCourseNotification() {
  //   setState(() {
  //     notifications.insert(0, {
  //       'title': 'Course Completed!',
  //       'message': 'Congratulations! You have completed a course. Check your Achievements.',
  //       'icon': Icons.celebration,
  //       'color': Colors.purple,
  //       'timestamp': DateTime.now(),
  //     });
  //   });
  // }

  // void _addNewFeedbackNotification() {
  //   setState(() {
  //     notifications.insert(0, {
  //       'title': 'New Feedback',
  //       'message': 'You\'ve received new feedback! Check it now.',
  //       'icon': Icons.feedback,
  //       'color': Colors.teal,
  //       'timestamp': DateTime.now(),
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
        onBackPressed: () => Navigator.pop(context),
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
                      notifications.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: notifications.length,
                              itemBuilder: (context, index) {
                                return _buildNotificationCard(
                                  notifications[index]['title'],
                                  notifications[index]['message'],
                                  notifications[index]['icon'],
                                  notifications[index]['color'],
                                  notifications[index]['timestamp'],
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

  // Widget _buildWelcomeCard() {
  //   return Card(
  //     margin: const EdgeInsets.all(16),
  //     elevation: 4,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(20),
  //       child: Row(
  //         children: [
  //           const Icon(
  //             Icons.waving_hand,
  //             size: 50,
  //             color: Colors.amber,
  //           ),
  //           const SizedBox(width: 16),
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   'Welcome Back!',
  //                   style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.grey[800],
  //                   ),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Text(
  //                   'We\'re happy to see you again in KidEdu!',
  //                   style: TextStyle(
  //                     fontSize: 14,
  //                     color: Colors.grey[600],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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

    if (difference.inMinutes < 60) {
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