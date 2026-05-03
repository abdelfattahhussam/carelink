import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carelink_app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../../blocs/donation/donation_bloc.dart';
import '../../blocs/notification/notification_bloc.dart';

/// Pharmacist review screen — approve/reject pending donations
class PharmacistReviewScreen extends StatefulWidget {
  const PharmacistReviewScreen({super.key});
  @override
  State<PharmacistReviewScreen> createState() => _PharmacistReviewScreenState();
}

class _PharmacistReviewScreenState extends State<PharmacistReviewScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DonationBloc>().add(PendingDonationsFetchRequested());
  }

  void _review(String donationId, String action) {
    final rootContext = context; // Capture context safely
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogCtx) {
        final notesCtrl = TextEditingController();
        String? selectedReason;
        final rejectReasons = [
          l10n.rejectReasonDamaged,
          l10n.rejectReasonExpired,
          l10n.rejectReasonUnreadable,
          l10n.rejectReasonRecalled,
          l10n.rejectReasonOther,
        ];

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            l10n.reviewDonationTitle('${action[0].toUpperCase()}${action.substring(1)}'),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          content: StatefulBuilder(
            builder: (sbCtx, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.confirmActionDonation(action),
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 20),
                    if (action == 'reject') ...[
                      Text(
                        l10n.selectRejectionReasonLabel,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Loop through reasons
                      RadioGroup<String>(
                        groupValue: selectedReason,
                        onChanged: (val) {
                          setState(() => selectedReason = val);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: rejectReasons
                              .map(
                                (reason) => RadioListTile<String>(
                                  title: Text(
                                    reason,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  value: reason,
                                  toggleable: true,
                                  activeColor: AppColors.error,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      if (selectedReason == l10n.rejectReasonOther) ...[
                        const SizedBox(height: 12),
                        TextField(
                          controller: notesCtrl,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.enterCustomReason,
                            filled: true,
                            fillColor: Theme.of(
                              context,
                            ).dividerColor.withValues(alpha: 0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ] else ...[
                      TextField(
                        controller: notesCtrl,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(
                            sbCtx,
                          )!.addReviewNotesOptional,
                          filled: true,
                          fillColor: Theme.of(
                            context,
                          ).dividerColor.withValues(alpha: 0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(
                AppLocalizations.of(dialogCtx)!.cancel,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: action == 'approve'
                    ? AppColors.success
                    : AppColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              onPressed: () {
                String notes = '';
                if (action == 'reject') {
                  if (selectedReason == null) {
                    ScaffoldMessenger.of(dialogCtx).showSnackBar(
                      SnackBar(
                        content: Text(l10n.rejectionReasonRequired),
                        backgroundColor: AppColors.error,
                      ),
                    );
                    return;
                  }
                  notes = selectedReason == l10n.rejectReasonOther
                      ? notesCtrl.text.trim()
                      : selectedReason!;
                  if (selectedReason == l10n.rejectReasonOther && notes.isEmpty) {
                    ScaffoldMessenger.of(dialogCtx).showSnackBar(
                      SnackBar(
                        content: Text(l10n.customReasonRequired),
                        backgroundColor: AppColors.error,
                      ),
                    );
                    return;
                  }
                } else {
                  notes = notesCtrl.text.trim();
                }

                Navigator.pop(dialogCtx);
                final reviewAction = action == 'approve'
                    ? DonationReviewAction.approve
                    : DonationReviewAction.reject;
                // Use rootContext.read to avoid issues if dialogCtx is invalid
                rootContext.read<DonationBloc>().add(
                  DonationReviewRequested(
                    donationId: donationId,
                    action: reviewAction,
                    notes: notes,
                  ),
                );
              },
              child: Text(
                action[0].toUpperCase() + action.substring(1),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.reviewDonations,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,

      ),
      body: BlocConsumer<DonationBloc, DonationState>(
        listener: (context, state) {
          if (state is DonationReviewed) {
            final msg = state.action == DonationReviewAction.approve
                ? AppLocalizations.of(context)!.donationApprovedQr
                : AppLocalizations.of(context)!.donationRejectedMsg;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                backgroundColor: state.action == DonationReviewAction.approve
                    ? AppColors.success
                    : AppColors.error,
              ),
            );
            context.read<DonationBloc>().add(PendingDonationsFetchRequested());
            context.read<NotificationBloc>().add(
              NotificationsFetchRequested(forceRefresh: true),
            );
          }
        },
        builder: (context, state) {
          Widget child;
          if (state is DonationLoading) {
            child = const ShimmerCardList(
              key: ValueKey('loading'),
              isListTileStyle: false,
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
                icon: Icons.rate_review,
                title: AppLocalizations.of(context)!.allCaughtUp,
                subtitle: AppLocalizations.of(context)!.noPendingDonations,
              );
            } else {
              final sortedDonations = state.donations.toList()
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
              child = ListView.builder(
                key: const ValueKey('list'),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                itemCount: sortedDonations.length,
                itemBuilder: (context, i) {
                  final d = sortedDonations[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
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
                          color: Colors.black.withValues(alpha: 0.04),
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
                                color: AppColors.warning.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.medication_rounded,
                                color: AppColors.warning,
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
                                          d.medicineName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "${AppLocalizations.of(context)!.byNameQty(d.donorName, d.quantity.toString())} ${d.unit.localizedName(context)}",
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    DateFormatters.timeAgo(d.createdAt, context: context),
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const StatusBadge(status: 'pending'),
                          ],
                        ),
                        if (d.boxImagePath != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context)!.boxImageLabel,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () =>
                                _showFullScreenImage(context, d.boxImagePath!),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(d.boxImagePath!),
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      height: 120,
                                      width: double.infinity,
                                      color: Theme.of(
                                        context,
                                      ).dividerColor.withValues(alpha: 0.1),
                                      child: const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 40,
                                          color: AppColors.textLight,
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  foregroundColor: AppColors.error,
                                  side: BorderSide(
                                    color: AppColors.error.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () => _review(d.id, 'reject'),
                                icon: const Icon(Icons.close_rounded, size: 18),
                                label: Text(
                                  AppLocalizations.of(context)!.reject,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  backgroundColor: AppColors.success,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () => _review(d.id, 'approve'),
                                icon: const Icon(Icons.check_rounded, size: 18),
                                label: Text(
                                  AppLocalizations.of(context)!.approve,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
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

  void _showFullScreenImage(BuildContext context, String path) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              child: Image.file(File(path), fit: BoxFit.contain),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
