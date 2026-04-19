import 'package:equatable/equatable.dart';
import 'user_model.dart';

enum NotificationType {
  donationApproved,
  newRequest,
  requestApproved,
  expiryWarning;

  String toJson() => name;
  static NotificationType fromJson(String json) =>
      NotificationType.values.firstWhere((e) => e.name == json, orElse: () => NotificationType.donationApproved);
}

/// Notification model for in-app notifications
class NotificationModel extends Equatable {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final bool isRead;
  final String? userId; // nullable — null means role-wide notification
  final UserRole? targetRole;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    this.userId,
    this.targetRole,
    required this.createdAt,
  });

  /// Icon for notification type
  String get iconType {
    switch (type) {
      case NotificationType.donationApproved:
        return 'check_circle';
      case NotificationType.newRequest:
        return 'inbox';
      case NotificationType.requestApproved:
        return 'thumb_up';
      case NotificationType.expiryWarning:
        return 'warning';
    }
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: NotificationType.fromJson(json['type'] ?? ''),
      isRead: json['isRead'] ?? false,
      userId: json['userId'] as String?, // preserve null for role-wide notifications
      targetRole: json['targetRole'] != null ? UserRole.fromJson(json['targetRole']) : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.toJson(),
      'isRead': isRead,
      'userId': userId, // null is serialized as null — correct for role-wide
      'targetRole': targetRole?.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  NotificationModel copyWith({bool? isRead, String? userId}) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      type: type,
      isRead: isRead ?? this.isRead,
      userId: userId ?? this.userId,
      targetRole: targetRole,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, isRead, userId];
}
