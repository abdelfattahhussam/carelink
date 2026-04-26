import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/notification_repository.dart';
import '../models/notification_model.dart';

/// Notification API service
class NotificationService implements NotificationRepository {
  final Dio _dio;
  NotificationService({required Dio dio}) : _dio = dio;

  /// Get all notifications for current user
  @override
  Future<List<NotificationModel>> getNotifications() async {
    final response = await _dio.get(ApiEndpoints.notifications);

    if (response.statusCode == 200 && response.data['success'] == true) {
      final list = response.data['data'] as List;
      return list.map((e) => NotificationModel.fromJson(e)).toList();
    }
    throw const ServerFailure(message: 'Failed to fetch notifications');
  }

  /// Mark a notification as read
  @override
  Future<void> markAsRead(String notificationId) async {
    await _dio.post(ApiEndpoints.markRead(notificationId));
  }

  /// Permanently dismiss/delete a notification
  @override
  Future<void> dismissNotification(String notificationId) async {
    await _dio.delete('${ApiEndpoints.notifications}/$notificationId');
  }
}
