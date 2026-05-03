import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:carelink_app/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/display_status.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/utils/name_utils.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../data/models/donation_model.dart';
import '../../../data/models/request_model.dart';
import '../../../data/models/user_model.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/donation/donation_bloc.dart';
import '../../blocs/request/request_bloc.dart';
import '../../blocs/notification/notification_bloc.dart';
import 'dart:math' as math;

/// Typed QR item used by the unified QR selection sheet.
class _QrItem {
  final String type; // 'donation' or 'request'
  final String id;
  final String? qrCode;
  final String medicineName;
  final int quantity;
  final dynamic unit; // MedicineUnit

  const _QrItem({
    required this.type,
    required this.id,
    required this.qrCode,
    required this.medicineName,
    required this.quantity,
    required this.unit,
  });
}

/// Unified home screen for the `User` role.
///
/// Merges the old DonorHomeScreen and PatientHomeScreen into a single
/// dashboard with quick-action cards and dual stats grids
/// (donations + requests).
class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  bool _isConfirmDialogShowing = false;
  final Set<String> _shownConfirmationIds = {};

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(
      NotificationsFetchRequested(forceRefresh: true),
    );
    context.read<DonationBloc>().add(DonationsFetchRequested());
    context.read<RequestBloc>().add(RequestsFetchRequested());
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = authState.user;
        return _buildBlocListeners(
          Scaffold(
            extendBody: true,
            appBar: HomeAppBar(user: user),
            body: RefreshIndicator(
              onRefresh: () async {
                context.read<NotificationBloc>().add(
                  NotificationsFetchRequested(forceRefresh: true),
                );
                context.read<DonationBloc>().add(DonationsFetchRequested());
                context.read<RequestBloc>().add(RequestsFetchRequested());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeCard(context, user),
                    const SizedBox(height: 24),
                    _buildQuickActions(context),
                    const SizedBox(height: 32),
                    // Donations section
                    Text(
                      AppLocalizations.of(context)!.myDonations,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDonationsStats(context),
                    const SizedBox(height: 16),
                    _buildRecentDonations(context),
                    const SizedBox(height: 32),
                    // Requests section
                    Text(
                      AppLocalizations.of(context)!.myRequests,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildRequestsStats(context),
                    const SizedBox(height: 16),
                    _buildRecentRequests(context),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: _buildFloatingBottomNav(context),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Bloc Listeners — delivery confirmation dialogs
  // ---------------------------------------------------------------------------

  Widget _buildBlocListeners(Widget child) {
    return MultiBlocListener(
      listeners: [
        // Donation delivery confirmation
        BlocListener<DonationBloc, DonationState>(
          listenWhen: (previous, current) => current is DonationsLoaded,
          listener: (context, state) {
            if (state is DonationsLoaded) {
              final pendingConfirm = state.donations
                  .where((d) => d.isDelivering)
                  .firstOrNull;
              if (pendingConfirm != null &&
                  !_isConfirmDialogShowing &&
                  !_shownConfirmationIds.contains(pendingConfirm.id)) {
                _shownConfirmationIds.add(pendingConfirm.id);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted && !_isConfirmDialogShowing) {
                    _showConfirmationDialog(
                      context,
                      pendingConfirm.medicineName,
                      pendingConfirm.id,
                      isRequest: false,
                    );
                  }
                });
              }
            }
          },
        ),
        // Request pickup confirmation
        BlocListener<RequestBloc, RequestState>(
          listenWhen: (previous, current) => current is RequestsLoaded,
          listener: (context, state) {
            if (state is RequestsLoaded) {
              final pendingConfirm = state.requests
                  .where((r) => r.isDelivering)
                  .firstOrNull;
              if (pendingConfirm != null &&
                  !_isConfirmDialogShowing &&
                  !_shownConfirmationIds.contains(pendingConfirm.id)) {
                _shownConfirmationIds.add(pendingConfirm.id);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted && !_isConfirmDialogShowing) {
                    _showConfirmationDialog(
                      context,
                      pendingConfirm.medicineName,
                      pendingConfirm.id,
                      isRequest: true,
                    );
                  }
                });
              }
            }
          },
        ),
      ],
      child: child,
    );
  }

  void _showConfirmationDialog(
    BuildContext context,
    String medicineName,
    String id, {
    required bool isRequest,
  }) {
    _isConfirmDialogShowing = true;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Icon(Icons.verified_user_rounded, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(
              isRequest
                  ? AppLocalizations.of(context)!.confirmPickup
                  : AppLocalizations.of(context)!.confirmDeliveryLabel,
            ),
          ],
        ),
        content: Text(
          isRequest
              ? AppLocalizations.of(context)!.didYouReceiveMedicine(
                  medicineName,
                )
              : AppLocalizations.of(context)!.didYouDeliverMedicine(
                  medicineName,
                ),
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (isRequest) {
                context.read<RequestBloc>().add(RequestsFetchRequested());
              } else {
                context.read<DonationBloc>().add(DonationsFetchRequested());
              }
            },
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (isRequest) {
                context.read<RequestBloc>().add(RequestsFetchRequested());
              } else {
                context.read<DonationBloc>().add(DonationsFetchRequested());
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isRequest
                        ? AppLocalizations.of(context)!.confirmReceiptSuccess
                        : AppLocalizations.of(context)!.confirmDeliverySuccess,
                  ),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(AppLocalizations.of(context)!.approve),
          ),
        ],
      ),
    ).whenComplete(() {
      _isConfirmDialogShowing = false;
    });
  }

  // ---------------------------------------------------------------------------
  // Welcome Card
  // ---------------------------------------------------------------------------

  Widget _buildWelcomeCard(BuildContext context, UserModel user) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background decorative pattern
          Positioned(
            right: -30,
            top: -30,
            child: Transform.rotate(
              angle: math.pi / 4,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(
                          context,
                        )!.welcomeWithName(NameUtils.firstName(user.name)),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.userWelcome,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Quick Actions
  // ---------------------------------------------------------------------------

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _quickActionCard(
            context,
            icon: Icons.volunteer_activism,
            label: AppLocalizations.of(context)!.donateMedicine,
            color: AppColors.primary,
            onTap: () => context.push('/donate'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _quickActionCard(
            context,
            icon: Icons.search_rounded,
            label: AppLocalizations.of(context)!.requestMedicine,
            color: AppColors.secondary,
            onTap: () => context.push('/medicines'),
          ),
        ),
      ],
    );
  }

  Widget _quickActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.15 : 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: isDark ? 0.35 : 0.2)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Donation Stats
  // ---------------------------------------------------------------------------

  Widget _buildDonationsStats(BuildContext context) {
    return BlocBuilder<DonationBloc, DonationState>(
      builder: (context, state) {
        int total = 0;
        int approved = 0;
        int pending = 0;
        int rejected = 0;
        if (state is DonationsLoaded) {
          total = state.donations.length;
          approved = state.donations.where((d) => d.isApproved).length;
          pending = state.donations.where((d) => d.isPending).length;
          rejected = state.donations.where((d) => d.isRejected).length;
        }
        return GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          children: [
            _stat(
              AppLocalizations.of(context)!.myDonations,
              '$total',
              Icons.volunteer_activism,
              AppColors.primary,
            ),
            _stat(
              AppLocalizations.of(context)!.approved,
              '$approved',
              Icons.check_circle_rounded,
              AppColors.success,
            ),
            _stat(
              AppLocalizations.of(context)!.pending,
              '$pending',
              Icons.hourglass_empty_rounded,
              AppColors.warning,
            ),
            _stat(
              AppLocalizations.of(context)!.rejected,
              '$rejected',
              Icons.cancel_outlined,
              AppColors.error,
            ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Request Stats
  // ---------------------------------------------------------------------------

  Widget _buildRequestsStats(BuildContext context) {
    return BlocBuilder<RequestBloc, RequestState>(
      builder: (context, state) {
        int total = 0;
        int approved = 0;
        int urgent = 0;
        int rejected = 0;
        if (state is RequestsLoaded) {
          total = state.requests.length;
          approved = state.requests.where((r) => r.isApproved).length;
          urgent = state.requests
              .where((r) => r.isUrgent && r.isPending)
              .length;
          rejected = state.requests.where((r) => r.isRejected).length;
        }
        return GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          children: [
            _stat(
              AppLocalizations.of(context)!.myRequests,
              '$total',
              Icons.inbox_rounded,
              AppColors.primary,
            ),
            _stat(
              AppLocalizations.of(context)!.approved,
              '$approved',
              Icons.check_circle_rounded,
              AppColors.success,
            ),
            _stat(
              AppLocalizations.of(context)!.urgent,
              '$urgent',
              Icons.priority_high_rounded,
              AppColors.error,
            ),
            _stat(
              AppLocalizations.of(context)!.rejected,
              '$rejected',
              Icons.cancel_outlined,
              AppColors.error,
            ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Recent Donations List
  // ---------------------------------------------------------------------------

  Widget _buildRecentDonations(BuildContext context) {
    return BlocBuilder<DonationBloc, DonationState>(
      builder: (context, state) {
        if (state is! DonationsLoaded || state.donations.isEmpty) {
          return const SizedBox.shrink();
        }
        final sorted = List<DonationModel>.from(state.donations)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        final recent = sorted.take(3).toList();
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.recentDonations,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/my-donations'),
                  child: Text(AppLocalizations.of(context)!.seeAll),
                ),
              ],
            ),
            ...recent.map((d) => _recentItemTile(
              medicineName: d.medicineName,
              status: d.status.displayStatus,
              date: d.createdAt,
              icon: Icons.volunteer_activism,
              color: AppColors.primary,
            )),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Recent Requests List
  // ---------------------------------------------------------------------------

  Widget _buildRecentRequests(BuildContext context) {
    return BlocBuilder<RequestBloc, RequestState>(
      builder: (context, state) {
        if (state is! RequestsLoaded || state.requests.isEmpty) {
          return const SizedBox.shrink();
        }
        final sorted = List<RequestModel>.from(state.requests)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        final recent = sorted.take(3).toList();
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.recentRequests,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/my-requests'),
                  child: Text(AppLocalizations.of(context)!.seeAll),
                ),
              ],
            ),
            ...recent.map((r) => _recentItemTile(
              medicineName: r.medicineName,
              status: r.status.displayStatus,
              date: r.createdAt,
              icon: Icons.inbox_rounded,
              color: AppColors.secondary,
            )),
          ],
        );
      },
    );
  }

  Widget _recentItemTile({
    required String medicineName,
    required DisplayStatus status,
    required DateTime date,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.divider.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicineName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormatters.timeAgo(date, context: context),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          StatusBadge(status: status),
        ],
      ),
    );
  }

  //---------------------------------------------------------------------------
  // Stat Card
  // ---------------------------------------------------------------------------

  Widget _stat(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Floating Bottom Navigation
  // ---------------------------------------------------------------------------

  Widget _buildFloatingBottomNav(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navItem(
              context,
              Icons.add_circle,
              AppLocalizations.of(context)!.donate,
              () => context.push('/donate'),
              isPrimary: true,
            ),
            _navItem(
              context,
              Icons.list_alt_rounded,
              AppLocalizations.of(context)!.myDonations,
              () => context.push('/my-donations'),
            ),
            _navItem(
              context,
              Icons.inbox_rounded,
              AppLocalizations.of(context)!.myRequests,
              () => context.push('/my-requests'),
            ),
            _navItem(
              context,
              Icons.qr_code_rounded,
              AppLocalizations.of(context)!.qrCode,
              _handleQrTap,
            ),
          ],
        ),
      ),
    );
  }

  void _handleQrTap() {
    final donationState = context.read<DonationBloc>().state;
    final requestState = context.read<RequestBloc>().state;

    final List<_QrItem> qrItems = [];

    if (donationState is DonationsLoaded) {
      qrItems.addAll(
        donationState.donations.where((d) => d.canShowQr).map(
          (d) => _QrItem(
            type: 'donation',
            id: d.id,
            qrCode: d.qrCode,
            medicineName: d.medicineName,
            quantity: d.quantity,
            unit: d.unit,
          ),
        ),
      );
    }
    if (requestState is RequestsLoaded) {
      qrItems.addAll(
        requestState.requests.where((r) => r.canShowQr).map(
          (r) => _QrItem(
            type: 'request',
            id: r.id,
            qrCode: r.qrCode,
            medicineName: r.medicineName,
            quantity: r.quantity,
            unit: r.unit,
          ),
        ),
      );
    }

    if (qrItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.noApprovedDonations),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (qrItems.length == 1) {
      final item = qrItems.first;
      context.push(
        '/qr-display',
        extra: {
          'id': item.id,
          'type': item.type,
          'qrCode': item.qrCode,
        },
      );
    } else {
      _showQRSelectionSheet(context, qrItems);
    }
  }

  void _showQRSelectionSheet(
    BuildContext context,
    List<_QrItem> qrItems,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.selectMedicineForDelivery,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.waitPharmacistScan,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: qrItems.length,
                itemBuilder: (context, index) {
                  final item = qrItems[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.divider.withValues(alpha: 0.3),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.qr_code_2_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(
                        item.medicineName,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        "${item.quantity} ${item.unit.localizedName(context)}",
                      ),
                      trailing: Icon(
                        Directionality.of(context) == TextDirection.rtl
                            ? Icons.arrow_back_ios_rounded
                            : Icons.arrow_forward_ios_rounded,
                        size: 16,
                      ),
                      onTap: () {
                        context.pop();
                        context.push(
                          '/qr-display',
                          extra: {
                            'id': item.id,
                            'type': item.type,
                            'qrCode': item.qrCode,
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isPrimary = false,
  }) {
    final color = isPrimary
        ? AppColors.primary
        : Theme.of(context).textTheme.bodySmall?.color;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: isPrimary ? 28 : 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: isPrimary ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
