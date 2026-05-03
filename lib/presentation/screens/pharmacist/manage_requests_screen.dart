import 'package:flutter/material.dart';
import 'package:carelink_app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../../blocs/medicine/medicine_bloc.dart';
import '../../blocs/request/request_bloc.dart';
import '../../blocs/notification/notification_bloc.dart';
import '../../../data/models/request_model.dart';
import 'widgets/request_decision_bottom_sheet.dart';

/// Pharmacist screen to manage patient requests
class ManageRequestsScreen extends StatefulWidget {
  const ManageRequestsScreen({super.key});
  @override
  State<ManageRequestsScreen> createState() => _ManageRequestsScreenState();
}

class _ManageRequestsScreenState extends State<ManageRequestsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RequestBloc>().add(RequestsFetchRequested());
    context.read<MedicineBloc>().add(MedicinesFetchRequested());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.manageRequests,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<RequestBloc, RequestState>(
        listener: (context, state) {
          if (state is RequestActionCompleted) {
            final msg = state.action == 'approve'
                ? AppLocalizations.of(context)!.requestApprovedQrGenerated
                : AppLocalizations.of(context)!.requestRejected;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                backgroundColor: state.action == 'approve'
                    ? AppColors.success
                    : AppColors.error,
              ),
            );
            context.read<RequestBloc>().add(RequestsFetchRequested());
            context.read<NotificationBloc>().add(
              NotificationsFetchRequested(forceRefresh: true),
            );
          }
        },
        builder: (context, state) {
          Widget child;
          if (state is RequestLoading) {
            child = const ShimmerCardList(
              key: ValueKey('loading'),
              isListTileStyle: false,
            );
          } else if (state is RequestsLoaded) {
            if (state.requests.isEmpty) {
              child = EmptyStateWidget(
                key: const ValueKey('empty'),
                icon: Icons.inbox,
                title: AppLocalizations.of(context)!.noRequests,
                subtitle: AppLocalizations.of(
                  context,
                )!.noPatientRequestsAtMoment,
              );
            } else {
              final sortedRequests = state.requests.toList()
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
              child = ListView.builder(
                key: const ValueKey('list'),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                itemCount: sortedRequests.length,
                itemBuilder: (context, i) {
                  final r = sortedRequests[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
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
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: r.isPending
                            ? () => RequestDecisionBottomSheet.show(context, r)
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color:
                                          (r.isUrgent
                                                  ? AppColors.error
                                                  : AppColors.secondary)
                                              .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Icon(
                                      r.isUrgent
                                          ? Icons.priority_high_rounded
                                          : Icons.person_rounded,
                                      color: r.isUrgent
                                          ? AppColors.error
                                          : AppColors.secondary,
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
                                                r.medicineName,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                            if (r.isUrgent)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.error
                                                      .withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  l10n.urgent,
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
                                          r.isPending
                                              ? "By ${r.patientName} • ${l10n.pendingReview}"
                                              : "By ${r.patientName} • ${_formatQuantity(r, context)}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(
                                              alpha: 0.05,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.15),
                                            ),
                                          ),
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.badge_outlined,
                                                  size: 16,
                                                  color: AppColors.primary,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  '${l10n.nationalId}: ${r.patientNationalId}',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          '${r.reason} • ${DateFormatters.timeAgo(r.createdAt, context: context)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(fontSize: 12),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
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
                                  if (r.isPending) ...[
                                    Row(
                                      children: [
                                        Text(
                                          l10n.review,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primary,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 14,
                                          color: AppColors.primary,
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          } else if (state is RequestError) {
            child = Center(
              key: const ValueKey('error'),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.wifi_off_rounded,
                    size: 64,
                    color: AppColors.textLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(l10n.retry),
                    onPressed: () => context.read<RequestBloc>().add(
                      RequestsFetchRequested(),
                    ),
                  ),
                ],
              ),
            );
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
    if (r.isRejected) return AppLocalizations.of(context)!.rejected;
    final l10n = AppLocalizations.of(context)!;
    final List<String> parts = [];
    if ((r.approvedBoxes ?? 0) > 0) {
      parts.add(
        "${r.approvedBoxes} ${r.approvedBoxes == 1 ? l10n.boxSingular : l10n.boxes}",
      );
    }
    if ((r.approvedStrips ?? 0) > 0) {
      parts.add(
        "${r.approvedStrips} ${r.approvedStrips == 1 ? l10n.stripSingular : l10n.strips}",
      );
    }
    return parts.isEmpty
        ? "1 ${r.unit.localizedName(context)}"
        : parts.join(" + ");
  }
}
