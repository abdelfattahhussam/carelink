import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:carelink_app/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../data/models/user_model.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/request/request_bloc.dart';
import '../../blocs/medicine/medicine_bloc.dart';
import '../../blocs/notification/notification_bloc.dart';
import 'dart:math' as math;

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  bool _isConfirmDialogShowing = false;

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(NotificationsFetchRequested());
    context.read<RequestBloc>().add(RequestsFetchRequested());
    context.read<MedicineBloc>().add(MedicinesFetchRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        final user = authState.user;
        return _buildBlocListener(
          Scaffold(
            extendBody: true, // For floating bottom nav
            appBar: HomeAppBar(user: user),
            body: RefreshIndicator(
              onRefresh: () async {
                context.read<NotificationBloc>().add(NotificationsFetchRequested());
                context.read<RequestBloc>().add(RequestsFetchRequested());
                context.read<MedicineBloc>().add(MedicinesFetchRequested());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeCard(context, user),
                    const SizedBox(height: 32),
                    Text(
                      AppLocalizations.of(context)!.overview,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 16),
                    _buildStatsGrid(context),
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

  /// Listen for status changes to show the confirmation dialog
  Widget _buildBlocListener(Widget child) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RequestBloc, RequestState>(
          listenWhen: (previous, current) => current is RequestsLoaded,
          listener: (context, state) {
            if (state is RequestsLoaded) {
              debugPrint('🏠 Home: Requests Loaded. Count: ${state.requests.length}');
              // Check if any request is in 'delivering' status
              final pendingConfirm = state.requests.where((r) => r.status == 'delivering').firstOrNull;
              if (pendingConfirm != null && !_isConfirmDialogShowing) {
                debugPrint('🚨 Home: Found pending confirm for ${pendingConfirm.medicineName}');
                // Schedule dialog after the current frame to avoid build-phase conflicts
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted && !_isConfirmDialogShowing) {
                    _showConfirmationDialog(context, pendingConfirm.medicineName, pendingConfirm.id, isRequest: true);
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

  void _showConfirmationDialog(BuildContext context, String medicineName, String id, {required bool isRequest}) {
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
            Text(AppLocalizations.of(context)!.confirmPickup),
          ],
        ),
        content: Text(
          AppLocalizations.of(context)!.didYouReceiveMedicine(medicineName),
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              // Finalize status to 'delivered'
              if (isRequest) {
                context.read<RequestBloc>().add(RequestFinalizeRequested(id: id));
              }
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.confirmReceiptSuccess),
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
          // Background elegant pattern
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
                        AppLocalizations.of(context)!.welcomeWithName(user.name.split(' ').first),
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
                      child: const Icon(Icons.person, color: Colors.white, size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.patientWelcome,
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

  Widget _buildStatsGrid(BuildContext context) {
    return BlocBuilder<RequestBloc, RequestState>(
      builder: (context, state) {
        int total = 0;
        int approved = 0;
        int urgent = 0;
        int rejected = 0;
        if (state is RequestsLoaded) {
          total = state.requests.length;
          approved = state.requests.where((r) => r.isApproved).length;
          urgent = state.requests.where((r) => r.isUrgent && r.isPending).length;
          rejected = state.requests.where((r) => r.isRejected).length;
        }
        return GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.15,
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

  Widget _stat(String label, String value, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {},
      child: Container(
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
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
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
              Icons.inbox_rounded,
              AppLocalizations.of(context)!.myRequests,
              () => context.push('/my-requests'),
            ),
            _navItem(
              context,
              Icons.search_rounded,
              AppLocalizations.of(context)!.browse,
              () => context.push('/medicines'),
              isPrimary: true,
            ),
            _navItem(
              context,
              Icons.qr_code_rounded,
              AppLocalizations.of(context)!.qrCode,
              () {
                final state = context.read<RequestBloc>().state;
                if (state is RequestsLoaded) {
                  // Filter for items with active (non-finalized) QR codes
                  final approved = state.requests.where((r) => r.canShowQr).toList();
                  if (approved.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.noApprovedRequests),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else if (approved.length == 1) {
                    final item = approved.first;
                    context.push('/qr-display', extra: {
                      'id': item.id,
                      'type': 'request',
                      'qrCode': item.qrCode,
                    });
                  } else {
                    _showQRSelectionSheet(context, approved);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showQRSelectionSheet(BuildContext context, List<dynamic> items) {
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
                decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.selectMedicineForPickup,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.waitPharmacistScan,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 24),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.divider.withValues(alpha: 0.3)),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.qr_code_2_rounded, color: AppColors.primary),
                      ),
                      title: Text(item.medicineName, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text("${item.quantity} ${item.unit.localizedName(context)}"),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      onTap: () {
                        context.pop();
                        context.push('/qr-display', extra: {
                          'id': item.id,
                          'type': 'request',
                          'qrCode': item.qrCode,
                        });
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
    final color = isPrimary ? AppColors.primary : Theme.of(context).textTheme.bodySmall?.color;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: isPrimary ? 28 : 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
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
