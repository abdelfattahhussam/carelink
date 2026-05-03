import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../domain/repositories/notification_repository.dart';
import '../models/notification_model.dart';
import 'service_helpers.dart';

/// Notification API service
class NotificationService implements NotificationRepository {
  final Dio _dio;
  NotificationService({required Dio dio}) : _dio = dio;

  /// Get all notifications for current user
  @override
  Future<List<NotificationModel>> getNotifications() async {
    return guardedDioCall(
      () => _dio.get(ApiEndpoints.notifications),
      (data) {
        final list = data['data'] as List;
        return list.map((e) => NotificationModel.fromJson(e)).toList();
      },
    );
  }

  /// Mark a notification as read
  @override
  Future<void> markAsRead(String notificationId) async {
    return guardedDioCall(
      () => _dio.post(ApiEndpoints.markRead(notificationId)),
      (_) {},
    );
  }

  /// Permanently dismiss/delete a notification
  @override
  Future<void> dismissNotification(String notificationId) async {
    return guardedDioCall(
      () => _dio.delete('${ApiEndpoints.notifications}/$notificationId'),
      (_) {},
    );
  }
}
