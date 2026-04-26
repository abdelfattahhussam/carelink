import 'package:flutter/material.dart';
import 'package:carelink_app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../../../data/models/donation_model.dart';
import '../../../data/models/pharmacy_model.dart';
import '../../blocs/donation/donation_bloc.dart';
import '../../blocs/pharmacy/pharmacy_bloc.dart';
import 'pharmacy_picker_screen.dart';

/// Shows the list of donor's own donations with status
class MyDonationsScreen extends StatefulWidget {
  const MyDonationsScreen({super.key});
  @override
  State<MyDonationsScreen> createState() => _MyDonationsScreenState();
}

class _MyDonationsScreenState extends State<MyDonationsScreen> {
  String _selectedFilter = 'all';
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<DonationBloc>().add(DonationsFetchRequested());
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
      context.read<DonationBloc>().add(LoadMoreDonationsRequested());
    }
  }

  void _resubmit(BuildContext context, DonationModel donation) async {
    final pharmacy = await Navigator.push<PharmacyModel>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<PharmacyBloc>(),
          child: const PharmacyPickerScreen(),
        ),
      ),
    );
    if (pharmacy != null && context.mounted) {
      context.read<DonationBloc>().add(
        DonationCreateRequested(
          name: donation.medicineName,
          notes: donation.notes,
          expiryDate: donation.createdAt.toIso8601String(),
          quantity: donation.quantity,
          unit: donation.unit.toJson(),
          pharmacyId: pharmacy.id,
          pharmacyName: pharmacy.name,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.myDonations,
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
      body: BlocBuilder<DonationBloc, DonationState>(
        builder: (context, state) {
          Widget child;
          if (state is DonationLoading) {
            child = const ShimmerCardList(
              key: ValueKey('loading'),
              isListTileStyle: true,
            );
          } else if (state is DonationError) {
            child = Center(
              key: const ValueKey('error'),
              child: Text(state.message),
            );
          } else if (state is DonationsLoaded) {
            if (state.donations.isEmpty) {
              child = EmptyStateWidget(
                key: const ValueKey('empty'),
                icon: Icons.volunteer_activism,
                title: l10n.noDonationsYet,
                subtitle: l10n.startByDonating,
              );
            } else {
              var filteredDonations = state.donations.toList();
              // Sort newest first
              filteredDonations.sort(
                (a, b) => b.createdAt.compareTo(a.createdAt),
              );

              if (_selectedFilter != 'all') {
                filteredDonations = filteredDonations
                    .where((d) => d.status == _selectedFilter)
                    .toList();
              }

              child = Column(
                children: [
                  _buildFilterRow(context),
                  Expanded(
                    child: filteredDonations.isEmpty
                        ? EmptyStateWidget(
                            icon: Icons.filter_alt_off_outlined,
                            title: l10n.noDonationsFound,
                            subtitle: l10n.tryDifferentSearch,
                          )
                        : ListView.builder(
                            controller: _scrollCtrl,
                            key: const ValueKey('list'),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            itemCount: filteredDonations.length,
                            itemBuilder: (context, i) {
                              final d = filteredDonations[i];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: AppColors.divider.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.04,
                                      ),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Icon(
                                        Icons.medication_rounded,
                                        color: AppColors.primary,
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            d.medicineName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            "${d.quantity} ${d.unit.localizedName(context)} • ${DateFormatters.timeAgo(d.createdAt)}",
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: AppColors.textSecondary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          // Pharmacy name
                                          if (d.pharmacyName != null &&
                                              d.pharmacyName!.isNotEmpty) ...[
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.local_pharmacy_outlined,
                                                  size: 14,
                                                  color: AppColors.textLight,
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    '${l10n.donatedTo} ${d.pharmacyName}',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          AppColors.textLight,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                          const SizedBox(height: 14),
                                          Row(
                                            children: [
                                              StatusBadge(status: d.status),
                                              if (d.canShowQr) ...[
                                                const SizedBox(width: 8),
                                                GestureDetector(
                                                  onTap: () => context.push(
                                                    '/qr-display',
                                                    extra: {
                                                      'id': d.id,
                                                      'type': 'donation',
                                                      'qrCode': d.qrCode,
                                                    },
                                                  ),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 6,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.info
                                                          .withValues(
                                                            alpha: 0.1,
                                                          ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Icon(
                                                          Icons
                                                              .qr_code_2_rounded,
                                                          size: 16,
                                                          color: AppColors.info,
                                                        ),
                                                        const SizedBox(
                                                          width: 6,
                                                        ),
                                                        Text(
                                                          l10n.qr,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: AppColors
                                                                    .info,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                          if (d.isRejected &&
                                              (d.reviewReason ?? d.notes)
                                                  .isNotEmpty) ...[
                                            const SizedBox(height: 14),
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: AppColors.error
                                                    .withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: AppColors.error
                                                      .withValues(alpha: 0.2),
                                                ),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Icon(
                                                    Icons.info_outline_rounded,
                                                    size: 18,
                                                    color: AppColors.error,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          l10n.reasonForRejection,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppColors
                                                                    .error,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        Text(
                                                          d.reviewReason ??
                                                              d.notes,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 12,
                                                                color: AppColors
                                                                    .error,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                          // Resubmit button for rejected (non-permanent) donations
                                          if (d.canResubmit) ...[
                                            const SizedBox(height: 12),
                                            SizedBox(
                                              width: double.infinity,
                                              child: OutlinedButton.icon(
                                                icon: const Icon(
                                                  Icons.refresh,
                                                  size: 16,
                                                ),
                                                label: Text(
                                                  l10n.resubmitToAnotherPharmacy,
                                                ),
                                                onPressed: () =>
                                                    _resubmit(context, d),
                                                style: OutlinedButton.styleFrom(
                                                  foregroundColor:
                                                      AppColors.primary,
                                                  side: BorderSide(
                                                    color: AppColors.primary
                                                        .withValues(alpha: 0.4),
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
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
                  color: isActive
                      ? AppColors.primary
                      : AppColors.divider.withValues(alpha: 0.5),
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
