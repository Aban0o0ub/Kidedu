part of 'notification_cubit.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationCountState extends NotificationState {
  final int count;
  
  NotificationCountState(this.count);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationCountState && other.count == count;
  }

  @override
  int get hashCode => count.hashCode;

  @override
  String toString() => 'NotificationCountState(count: $count)';
} 