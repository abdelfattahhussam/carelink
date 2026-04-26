import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../../presentation/blocs/notification/notification_bloc.dart';

/// Optimized notification bell icon with unread badge.
///
/// Uses [buildWhen] to only rebuild when the unread count actually changes,
/// preventing the entire [HomeAppBar] from rebuilding on every
/// notification state transition.
class NotificationBadge extends StatelessWidget {
  const NotificationBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      buildWhen: (prev, curr) {
        final prevCount = prev is NotificationsLoaded ? prev.unreadCount : 0;
        final currCount = curr is NotificationsLoaded ? curr.unreadCount : 0;
        return prevCount != currCount;
      },
      builder: (context, state) {
        int unread = 0;
        if (state is NotificationsLoaded) unread = state.unreadCount;
        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () => context.push('/notifications'),
            ),
            if (unread > 0)
              PositionedDirectional(
                end: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$unread',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
