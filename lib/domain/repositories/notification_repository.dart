import '../../data/models/notification_model.dart';

/// Abstract notification repository contract.
abstract class NotificationRepository {
  /// Get all notifications for current user
  Future<List<NotificationModel>> getNotifications();

  /// Mark a notification as read
  Future<void> markAsRead(String notificationId);

  /// Permanently dismiss/delete a notification
  Future<void> dismissNotification(String notificationId);
}
