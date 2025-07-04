import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial()) {
    _loadNotificationCount();
  }



  // Load notification count from storage
  Future<void> _loadNotificationCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Always show a fixed number for decoration unless notifications were cleared
      final wasCleared = prefs.getBool('notifications_cleared') ?? false;
      int count = wasCleared ? 0 : 3; // Fixed count of 3 for decoration
      
      emit(NotificationCountState(count));
    } catch (e) {
      emit(NotificationCountState(3)); // Default to 3 for decoration
    }
  }

  // Public method to reload notification count
  Future<void> loadNotificationCount() async {
    await _loadNotificationCount();
  }

  // Add new notifications (optional for future use)
  Future<void> addNotifications(int count) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notifications_cleared', false);
      emit(NotificationCountState(3)); // Always show 3 for decoration
    } catch (e) {
      emit(NotificationCountState(3));
    }
  }

  // Clear all notifications (when user views notification page)
  Future<void> clearNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notifications_cleared', true);
      emit(NotificationCountState(0));
    } catch (e) {
      emit(NotificationCountState(0));
    }
  }

  // Set specific notification count
  Future<void> setNotificationCount(int count) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notifications_cleared', count == 0);
      emit(NotificationCountState(count == 0 ? 0 : 3));
    } catch (e) {
      emit(NotificationCountState(count == 0 ? 0 : 3));
    }
  }

  // Get current notification count
  int get currentCount {
    final currentState = state;
    if (currentState is NotificationCountState) {
      return currentState.count;
    }
    return 0;
  }


} 