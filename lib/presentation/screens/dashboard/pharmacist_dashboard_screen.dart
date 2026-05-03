import 'package:flutter/material.dart';
import 'package:carelink_app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/name_utils.dart';
import '../../../data/models/user_model.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/donation/donation_bloc.dart';
import '../../blocs/medicine/medicine_bloc.dart';
import '../../blocs/notification/notification_bloc.dart';
import '../../blocs/request/request_bloc.dart';
import 'dart:math' as math;

class PharmacistDashboardScreen extends StatefulWidget {
  const PharmacistDashboardScreen({super.key});
  @override
  State<PharmacistDashboardScreen> createState() =>
      _PharmacistDashboardScreenState();
}

class _PharmacistDashboardScreenState extends State<PharmacistDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(
      NotificationsFetchRequested(forceRefresh: true),
    );
    context.read<MedicineBloc>().add(MedicinesFetchRequested());
    context.read<RequestBloc>().add(RequestsFetchRequested());
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<DonationBloc>().add(PendingDonationsFetchRequested());
    }
  }

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
        return Scaffold(
          extendBody: true,
          appBar: HomeAppBar(user: user),
          body: RefreshIndicator(
            onRefresh: () async => _refreshData(user),
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
                  const SizedBox(height: 32),

                  Text(
                    AppLocalizations.of(context)!.overview,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStatsGrid(context, user),

                  const SizedBox(height: 32),
                  Text(
                    AppLocalizations.of(context)!.quickActions,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildQuickActions(context, user),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildFloatingBottomNav(context, user),
        );
      },
    );
  }

  void _refreshData(UserModel user) {
    context.read<MedicineBloc>().add(MedicinesFetchRequested());
    context.read<NotificationBloc>().add(
      NotificationsFetchRequested(forceRefresh: true),
    );
    context.read<DonationBloc>().add(PendingDonationsFetchRequested());
    context.read<RequestBloc>().add(RequestsFetchRequested());
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
                        Icons.local_pharmacy_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _getRoleMsg(context, user.role),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.verifiedRole(user.role.label),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.95),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getRoleMsg(BuildContext context, UserRole role) => switch (role) {
    UserRole.pharmacist => AppLocalizations.of(context)!.pharmacistWelcome,
    _ => AppLocalizations.of(context)!.appTitle,
  };

  Widget _buildStatsGrid(BuildContext context, UserModel user) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.15,
      children: _statsForRole(context, user),
    );
  }

  List<Widget> _statsForRole(BuildContext context, UserModel user) {
    final donState = context.watch<DonationBloc>().state;
    final medState = context.watch<MedicineBloc>().state;
    final reqState = context.watch<RequestBloc>().state;

    final donPending = donState is DonationsLoaded
        ? donState.donations.where((d) => d.isPending).length.toString()
        : '0';
    final medCount = medState is MedicinesLoaded
        ? medState.medicines.length.toString()
        : '0';
    final reqCount = reqState is RequestsLoaded
        ? reqState.requests.length.toString()
        : '0';
    final urgentCount = reqState is RequestsLoaded
        ? reqState.requests.where((r) => r.isUrgent).length.toString()
        : '0';

    return [
      _stat(
        AppLocalizations.of(context)!.pendingReviews,
        donPending,
        Icons.rate_review_rounded,
        AppColors.warning,
      ),
      _stat(
        AppLocalizations.of(context)!.myRequests,
        reqCount,
        Icons.list_alt_rounded,
        AppColors.primary,
      ),
      _stat(
        AppLocalizations.of(context)!.availableMedicines,
        medCount,
        Icons.medication_rounded,
        AppColors.secondary,
      ),
      _stat(
        AppLocalizations.of(context)!.urgent,
        urgentCount,
        Icons.priority_high_rounded,
        AppColors.error,
      ),
    ];
  }

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
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
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, UserModel user) {
    final actions = [
      (
        AppLocalizations.of(context)!.reviewDonations,
        Icons.rate_review_rounded,
        AppColors.primary,
        '/review',
      ),
      (
        AppLocalizations.of(context)!.manageRequests,
        Icons.view_list_rounded,
        AppColors.secondary,
        '/manage-requests',
      ),
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final a = actions[index];
        return GestureDetector(
          onTap: () => context.push(a.$4),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: a.$3.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(a.$2, color: a.$3, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    a.$1,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: (Theme.of(context).brightness == Brightness.dark)
                          ? Colors.white.withValues(alpha: 0.95)
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).dividerColor,
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingBottomNav(BuildContext context, UserModel user) {
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
              Icons.medication_rounded,
              AppLocalizations.of(context)!.medicines,
              () => context.push('/medicines'),
            ),
            _navItem(
              context,
              Icons.qr_code_scanner_rounded,
              AppLocalizations.of(context)!.scan,
              () => context.push('/qr-scan'),
              isPrimary: true,
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
