import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/notification_model.dart';
import '../../../domain/repositories/notification_repository.dart';
import '../auth/auth_bloc.dart';

// ─── EVENTS ───

abstract class NotificationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationsFetchRequested extends NotificationEvent {
  final bool forceRefresh;
  NotificationsFetchRequested({this.forceRefresh = false});
  @override
  List<Object?> get props => [forceRefresh];
}

class NotificationMarkReadRequested extends NotificationEvent {
  final String notificationId;
  NotificationMarkReadRequested({required this.notificationId});
  @override
  List<Object?> get props => [notificationId];
}

class NotificationDismissRequested extends NotificationEvent {
  final String notificationId;
  NotificationDismissRequested({required this.notificationId});
  @override
  List<Object?> get props => [notificationId];
}

/// Pagination scaffolding — dispatched when the user scrolls near the bottom.
class LoadMoreNotificationsRequested extends NotificationEvent {}

/// Internal event dispatched when auth state transitions to unauthenticated.
/// Replaces the previous direct emit() call from the StreamSubscription,
/// which bypassed BLoC's event pipeline and concurrency guards.
class _NotificationReset extends NotificationEvent {}

// ─── STATES ───

abstract class NotificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  int get unreadCount => notifications.where((n) => !n.isRead).length;
  NotificationsLoaded({required this.notifications});
  @override
  List<Object?> get props => [notifications];
}

class NotificationError extends NotificationState {
  final String message;
  NotificationError({required this.message});
  @override
  List<Object?> get props => [message];
}

// ─── BLOC ───

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _service;
  final AuthBloc _authBloc;
  late final StreamSubscription<AuthState> _authSubscription;

  NotificationBloc({
    required AuthBloc authBloc,
    required NotificationRepository service,
  }) : _authBloc = authBloc,
       _service = service,
       super(NotificationInitial()) {
    on<NotificationsFetchRequested>(_onFetch);
    on<NotificationMarkReadRequested>(_onMarkRead);
    on<NotificationDismissRequested>(_onDismiss);
    on<LoadMoreNotificationsRequested>(_onLoadMore);
    on<_NotificationReset>((_, emit) => emit(NotificationInitial()));

    // Reset state on logout — dispatches event instead of calling emit() directly
    _authSubscription = _authBloc.stream.listen((state) {
      if (state is AuthUnauthenticated) add(_NotificationReset());
    });
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

  Future<void> _onFetch(
    NotificationsFetchRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final authState = _authBloc.state;
    if (authState is! AuthAuthenticated) {
      emit(NotificationsLoaded(notifications: const []));
      return;
    }

    final userId = authState.user.id;
    final userRole = authState.user.role;

    emit(NotificationLoading());
    try {
      final notifications = await _service.getNotifications();

      // Secondary safety filtering
      final filtered = notifications.where((n) {
        return n.userId == userId || n.targetRole == userRole;
      }).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      emit(NotificationsLoaded(notifications: filtered));
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }

  Future<void> _onMarkRead(
    NotificationMarkReadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    // Optimistic update to avoid full screen flicker
    if (state is NotificationsLoaded) {
      final currentList = List<NotificationModel>.from(
        (state as NotificationsLoaded).notifications,
      );
      final index = currentList.indexWhere((n) => n.id == event.notificationId);
      if (index != -1 && !currentList[index].isRead) {
        currentList[index] = currentList[index].copyWith(isRead: true);
        emit(NotificationsLoaded(notifications: currentList));
      }
    }

    try {
      await _service.markAsRead(event.notificationId);
    } catch (e) {
      // Background failure can be ignored for optimistic UI
    }
  }

  Future<void> _onDismiss(
    NotificationDismissRequested event,
    Emitter<NotificationState> emit,
  ) async {
    // Capture full pre-optimistic state for safe rollback
    final previousState = state;

    // Optimistically remove from list immediately
    if (previousState is NotificationsLoaded) {
      final currentList = List<NotificationModel>.from(
        previousState.notifications,
      );
      final removedIndex = currentList.indexWhere(
        (n) => n.id == event.notificationId,
      );
      if (removedIndex >= 0) {
        currentList.removeAt(removedIndex);
      }
      emit(NotificationsLoaded(notifications: currentList));
    }

    // Permanently delete from backend
    try {
      await _service.dismissNotification(event.notificationId);
    } catch (e) {
      debugPrint('NotificationBloc: Failed to dismiss notification: $e');
      // Rollback: restore full original state — avoids race with concurrent events
      if (previousState is NotificationsLoaded) {
        emit(previousState);
      }
    }
  }

  // TODO(pagination): Replace with cursor/offset logic when backend is ready.
  Future<void> _onLoadMore(
    LoadMoreNotificationsRequested event,
    Emitter<NotificationState> emit,
  ) async {
    if (state is! NotificationsLoaded) return;
    // TODO: implement cursor/offset pagination
  }
}
