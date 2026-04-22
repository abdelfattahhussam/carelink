import 'package:flutter/material.dart';
import 'package:carelink_app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../../blocs/request/request_bloc.dart';
import '../../blocs/pharmacy/pharmacy_bloc.dart';
import '../../../data/models/request_model.dart';

/// Shows patient's own requests with status tracking
class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});
  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    context.read<RequestBloc>().add(RequestsFetchRequested());
    context.read<PharmacyBloc>().add(PharmaciesLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.myRequests,
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
      body: BlocBuilder<RequestBloc, RequestState>(
        builder: (context, state) {
          Widget child;
          if (state is RequestLoading) {
            child = const ShimmerCardList(key: ValueKey('loading'), isListTileStyle: false);
          } else if (state is RequestError) {
            child = Center(key: const ValueKey('error'), child: Text(state.message));
          } else if (state is RequestsLoaded) {
            if (state.requests.isEmpty) {
              child = EmptyStateWidget(
                key: const ValueKey('empty'),
                icon: Icons.inbox,
                title: AppLocalizations.of(context)!.noRequestsYet,
                subtitle: AppLocalizations.of(context)!.browseMedicinesAndSubmit,
              );
            } else {
              var filteredRequests = state.requests.toList();
              // Sort newest first
              filteredRequests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
              
              if (_selectedFilter != 'all') {
                filteredRequests = filteredRequests.where((r) => r.status == _selectedFilter).toList();
              }

              child = Column(
                children: [
                  _buildFilterRow(context),
                  Expanded(
                    child: filteredRequests.isEmpty
                        ? EmptyStateWidget(
                            icon: Icons.filter_alt_off_outlined,
                            title: AppLocalizations.of(context)!.noRequestsFound,
                            subtitle: AppLocalizations.of(context)!.tryDifferentSearch,
                          )
                        : ListView.builder(
                key: const ValueKey('list'),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                itemCount: state.requests.length,
                itemBuilder: (context, i) {
                  final r = state.requests[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.divider.withValues(alpha: 0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: r.isUrgent
                                    ? AppColors.error.withValues(alpha: 0.1)
                                    : AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                r.isUrgent ? Icons.priority_high_rounded : Icons.medication_rounded,
                                color: r.isUrgent ? AppColors.error : AppColors.primary,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          r.medicineName,
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                        ),
                                      ),
                                      if (r.isUrgent)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.error.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            AppLocalizations.of(context)!.urgent,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.error,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    r.isApproved || r.isDelivered || r.isDelivering
                                        ? "${_formatQuantity(r, context)} • ${DateFormatters.timeAgo(r.createdAt)}"
                                        : DateFormatters.timeAgo(r.createdAt),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (r.pharmacyName != null && r.pharmacyName!.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    BlocBuilder<PharmacyBloc, PharmacyState>(
                                      builder: (context, pState) {
                                        String addressText = '';
                                        if (pState is PharmaciesLoaded) {
                                          try {
                                            final p = pState.pharmacies.firstWhere((p) => p.id == r.pharmacyId);
                                            addressText = p.fullLocation;
                                          } catch (_) {}
                                        }
                                        return Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(alpha: 0.04),
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(Icons.local_pharmacy_outlined, size: 14, color: AppColors.primary),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      r.pharmacyName!,
                                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (addressText.isNotEmpty) ...[
                                                const SizedBox(height: 4),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textLight),
                                                    const SizedBox(width: 6),
                                                    Expanded(
                                                      child: Text(
                                                        addressText,
                                                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            StatusBadge(status: r.status),
                            const Spacer(),
                            if (r.canShowQr)
                              GestureDetector(
                                onTap: () => context.push('/qr-display', extra: {
                                  'id': r.id,
                                  'type': 'request',
                                  'qrCode': r.qrCode,
                                }),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [AppColors.primary, AppColors.secondary],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(alpha: 0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.qr_code_scanner_rounded, size: 16, color: Colors.white),
                                      const SizedBox(width: 6),
                                      Text(
                                        AppLocalizations.of(context)!.showQr,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (r.isRejected && r.reviewReason != null && r.reviewReason!.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.error),
                                const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(AppLocalizations.of(context)!.reasonForRejection, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.error)),
                                        const SizedBox(height: 2),
                                        Text(r.reviewReason!, style: const TextStyle(fontSize: 12, color: AppColors.error, fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
      } else {
        child = const SizedBox.shrink(key: ValueKey('none'));
      }

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: child,
      );
    },
      ),
    );
  }

  String _formatQuantity(RequestModel r, BuildContext context) {
    if (r.isRejected) return "";
    final l10n = AppLocalizations.of(context)!;
    final List<String> parts = [];
    if ((r.approvedBoxes ?? 0) > 0) {
      parts.add("${r.approvedBoxes} ${r.approvedBoxes == 1 ? l10n.boxSingular : l10n.boxes}");
    }
    if ((r.approvedStrips ?? 0) > 0) {
      parts.add("${r.approvedStrips} ${r.approvedStrips == 1 ? l10n.stripSingular : l10n.strips}");
    }
    return parts.isEmpty ? "1 ${r.unit.localizedName(context)}" : parts.join(" + ");
  }

  Widget _buildFilterRow(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filters = [
      {'key': 'all', 'label': l10n.all},
      {'key': 'pending', 'label': l10n.pending},
      {'key': 'approved', 'label': l10n.approved},
      {'key': 'rejected', 'label': l10n.rejected},
      {'key': 'delivered', 'label': l10n.delivered},
    ];

    return Container(
      height: 48,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, i) {
          final f = filters[i];
          final isActive = _selectedFilter == f['key'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              showCheckmark: false,
              label: Text(
                f['label']!,
                style: TextStyle(
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                  fontSize: 13,
                  color: isActive ? Colors.white : AppColors.textSecondary,
                ),
              ),
              selected: isActive,
              selectedColor: AppColors.primary,
              backgroundColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isActive ? AppColors.primary : AppColors.divider.withValues(alpha: 0.5),
                ),
              ),
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedFilter = f['key']!);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
