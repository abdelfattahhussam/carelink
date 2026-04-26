import 'package:flutter/material.dart';
import 'package:carelink_app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../data/models/notification_model.dart';
import '../../blocs/notification/notification_bloc.dart';

/// Notifications screen — shows all user notifications
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _scrollCtrl = ScrollController();
  @override
  void initState() {
    super.initState();
    // Always force refresh to catch new notifications from recent actions
    context.read<NotificationBloc>().add(
      NotificationsFetchRequested(forceRefresh: true),
    );
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >=
        _scrollCtrl.position.maxScrollExtent * 0.8) {
      context.read<NotificationBloc>().add(LoadMoreNotificationsRequested());
    }
  }

  IconData _iconForType(NotificationType type) => switch (type) {
    NotificationType.donationApproved => Icons.check_circle_rounded,
    NotificationType.donationRejected => Icons.cancel_rounded,
    NotificationType.newRequest => Icons.inbox_rounded,
    NotificationType.newDonation => Icons.volunteer_activism_rounded,
    NotificationType.requestApproved => Icons.thumb_up_rounded,
    NotificationType.requestRejected => Icons.thumb_down_rounded,
    NotificationType.expiryWarning => Icons.warning_amber_rounded,
  };

  Color _colorForType(NotificationType type) => switch (type) {
    NotificationType.donationApproved => AppColors.success,
    NotificationType.donationRejected => AppColors.error,
    NotificationType.newRequest => AppColors.info,
    NotificationType.newDonation => AppColors.info,
    NotificationType.requestApproved => AppColors.primary,
    NotificationType.requestRejected => AppColors.error,
    NotificationType.expiryWarning => AppColors.warning,
  };

  String _getLocalizedTitle(BuildContext context, NotificationModel n) {
    final l10n = AppLocalizations.of(context)!;
    return switch (n.type) {
      NotificationType.donationApproved => l10n.notifDonationApprovedTitle,
      NotificationType.donationRejected => l10n.notifDonationRejectedTitle,
      NotificationType.newRequest => l10n.notifNewRequestTitle,
      NotificationType.newDonation => l10n.notifNewDonationTitle,
      NotificationType.requestApproved => l10n.notifRequestApprovedTitle,
      NotificationType.requestRejected => l10n.notifRequestRejectedTitle,
      NotificationType.expiryWarning => l10n.notifExpiryWarningTitle,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.notifications,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NotificationError) {
            return Center(child: Text(state.message));
          }
          if (state is NotificationsLoaded) {
            if (state.notifications.isEmpty) {
              return EmptyStateWidget(
                icon: Icons.notifications_off_outlined,
                title: AppLocalizations.of(context)!.noNotificationsTitle,
                subtitle: AppLocalizations.of(context)!.youAreAllCaughtUp,
              );
            }
            return ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: state.notifications.length,
              itemBuilder: (context, i) {
                final n = state.notifications[i];
                final color = _colorForType(n.type);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Dismissible(
                    key: Key(n.id),
                    background: Container(
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      alignment: AlignmentDirectional.centerEnd,
                      padding: const EdgeInsetsDirectional.only(end: 24),
                      child: const Icon(
                        Icons.done_all,
                        color: AppColors.success,
                        size: 28,
                      ),
                    ),
                    onDismissed: (_) => context.read<NotificationBloc>().add(
                      NotificationDismissRequested(notificationId: n.id),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).dividerColor.withValues(alpha: 0.5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            // Mark as read (not dismiss) so it stays in the list
                            if (!n.isRead) {
                              context.read<NotificationBloc>().add(
                                NotificationMarkReadRequested(
                                  notificationId: n.id,
                                ),
                              );
                            }

                            switch (n.type) {
                              case NotificationType.donationApproved:
                              case NotificationType.donationRejected:
                                context.push('/my-donations');
                              case NotificationType.newRequest:
                                context.push('/manage-requests');
                              case NotificationType.newDonation:
                                context.push('/review');
                              case NotificationType.requestApproved:
                              case NotificationType.requestRejected:
                                context.push('/my-requests');
                              case NotificationType.expiryWarning:
                                context.push('/medicines');
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    _iconForType(n.type),
                                    color: color,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              _getLocalizedTitle(context, n),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    fontWeight: n.isRead
                                                        ? FontWeight.w600
                                                        : FontWeight.bold,
                                                    color: n.isRead
                                                        ? Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium
                                                              ?.color
                                                        : color,
                                                  ),
                                            ),
                                          ),
                                          if (!n.isRead)
                                            Container(
                                              width: 10,
                                              height: 10,
                                              margin: const EdgeInsets.only(
                                                left: 8,
                                              ),
                                              decoration: BoxDecoration(
                                                color: color,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        n.body,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).textTheme.bodySmall?.color,
                                              height: 1.5,
                                            ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        DateFormatters.timeAgo(n.createdAt),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
