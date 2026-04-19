import 'package:flutter/material.dart';
import 'package:carelink_app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../../blocs/donation/donation_bloc.dart';

/// Shows the list of donor's own donations with status
class MyDonationsScreen extends StatefulWidget {
  const MyDonationsScreen({super.key});
  @override
  State<MyDonationsScreen> createState() => _MyDonationsScreenState();
}

class _MyDonationsScreenState extends State<MyDonationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DonationBloc>().add(DonationsFetchRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.myDonations,
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
            child = const ShimmerCardList(key: ValueKey('loading'), isListTileStyle: true);
          } else if (state is DonationError) {
            child = Center(key: const ValueKey('error'), child: Text(state.message));
          } else if (state is DonationsLoaded) {
            if (state.donations.isEmpty) {
              child = EmptyStateWidget(
                key: const ValueKey('empty'),
                icon: Icons.volunteer_activism,
                title: AppLocalizations.of(context)!.noDonationsYet,
                subtitle: AppLocalizations.of(context)!.startByDonating,
              );
            } else {
              child = ListView.builder(
                key: const ValueKey('list'),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                itemCount: state.donations.length,
                itemBuilder: (context, i) {
                  final d = state.donations[i];
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.medication_rounded, color: AppColors.primary, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                d.medicineName,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "${d.quantity} ${d.unit.localizedName(context)} • ${DateFormatters.timeAgo(d.createdAt)}",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  StatusBadge(status: d.status),
                                  if (d.canShowQr) ...[
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () => context.push('/qr-display', extra: {
                                        'id': d.id,
                                        'type': 'donation',
                                        'qrCode': d.qrCode,
                                      }),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppColors.info.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.qr_code_2_rounded, size: 16, color: AppColors.info),
                                            const SizedBox(width: 6),
                                            Text(
                                              AppLocalizations.of(context)!.qr,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.info,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              if (d.isRejected && (d.reviewReason ?? d.notes).isNotEmpty) ...[
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
                                           const Text("Reason for rejection:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.error)),
                                           const SizedBox(height: 2),
                                           Text(d.reviewReason ?? d.notes!, style: const TextStyle(fontSize: 12, color: AppColors.error, fontWeight: FontWeight.w500)),
                                         ],
                                       ),
                                     ),
                                   ],
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
}
