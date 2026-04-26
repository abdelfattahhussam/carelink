import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carelink_app/l10n/app_localizations.dart';
import 'package:carelink_app/core/constants/app_colors.dart';
import 'package:carelink_app/core/widgets/shared_widgets.dart';
import 'package:carelink_app/data/models/request_model.dart';
import 'package:carelink_app/data/models/medicine_model.dart';
import 'package:carelink_app/presentation/blocs/medicine/medicine_bloc.dart';
import 'package:carelink_app/presentation/blocs/request/request_bloc.dart';

class RequestDecisionBottomSheet extends StatefulWidget {
  final RequestModel request;
  final MedicineModel? medicine;

  const RequestDecisionBottomSheet({
    super.key,
    required this.request,
    this.medicine,
  });

  static void show(BuildContext context, RequestModel request) {
    // Attempt to find the medicine in MedicineBloc
    final medicineState = context.read<MedicineBloc>().state;
    MedicineModel? medicine;
    if (medicineState is MedicinesLoaded) {
      medicine = medicineState.medicines
          .where((m) => m.id == request.medicineId)
          .firstOrNull;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          RequestDecisionBottomSheet(request: request, medicine: medicine),
    );
  }

  @override
  State<RequestDecisionBottomSheet> createState() =>
      _RequestDecisionBottomSheetState();
}

class _RequestDecisionBottomSheetState
    extends State<RequestDecisionBottomSheet> {
  int _boxes = 0;
  int _strips = 0;

  bool get _isBoxEnabled =>
      widget.medicine?.unit.isBox ?? true; // fallback to true
  bool get _isStripEnabled => widget.medicine?.unit.isStrip ?? true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final med = widget.medicine;

    // We assume the quantity of the medicine represents the unit.
    // Since medicine unit currently supports either 'box' or 'strip'.
    final int availableQuantity = med?.quantity ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.requestDetails,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  StatusBadge(status: widget.request.status),
                ],
              ),
              const SizedBox(height: 24),

              // Patient Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.secondary.withValues(
                        alpha: 0.1,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.request.patientName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${l10n.nationalId}: ${widget.request.patientNationalId}",
                            style: TextStyle(
                              color: theme.textTheme.bodySmall?.color,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Medicine & Prescription
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.medication,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.request.medicineName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.request.reason,
                                style: TextStyle(
                                  color: theme.textTheme.bodySmall?.color,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (widget.request.prescriptionPath != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        l10n.prescription,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _showFullScreenImage(
                          context,
                          widget.request.prescriptionPath!,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(widget.request.prescriptionPath!),
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  height: 120,
                                  width: double.infinity,
                                  color: theme.dividerColor.withValues(
                                    alpha: 0.1,
                                  ),
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
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Available Stock
              Text(
                l10n.decisionPanel,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.inventory_2,
                      color: AppColors.info,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "${l10n.availableStock}: ${med?.quantity ?? 'Unknown'} ${med?.unit.localizedName(context) ?? 'Units'}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.info,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Counters
              if (_isBoxEnabled) ...[
                _buildCounterRow(
                  label: l10n.boxes,
                  value: _boxes,
                  onDecrement: () => setState(() {
                    if (_boxes > 0) _boxes--;
                  }),
                  onIncrement: () => setState(() {
                    if (_boxes < availableQuantity) _boxes++;
                  }),
                ),
                const SizedBox(height: 16),
              ],
              if (_isStripEnabled) ...[
                _buildCounterRow(
                  label: l10n.strips,
                  value: _strips,
                  onDecrement: () => setState(() {
                    if (_strips > 0) _strips--;
                  }),
                  onIncrement: () => setState(() {
                    if (_strips < availableQuantity) _strips++;
                  }),
                ),
              ],

              const SizedBox(height: 32),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        final bloc = context.read<RequestBloc>();
                        Navigator.pop(context);
                        _showRejectBottomSheet(
                          context,
                          widget.request.id,
                          bloc,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppColors.error),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        l10n.reject,
                        style: const TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (_boxes == 0 && _strips == 0)
                          ? null
                          : () {
                              context.read<RequestBloc>().add(
                                RequestApproveRequested(
                                  requestId: widget.request.id,
                                  action: RequestReviewAction.approve,
                                  approvedBoxes: _boxes,
                                  approvedStrips: _strips,
                                ),
                              );
                              Navigator.pop(context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.success.withValues(
                          alpha: 0.3,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        l10n.approve,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
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

  Widget _buildCounterRow({
    required String label,
    required int value,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    final theme = Theme.of(context);
    final color = theme.textTheme.bodyLarge?.color;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Row(
          children: [
            _counterButton(Icons.remove, onDecrement),
            SizedBox(
              width: 40,
              child: Center(
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ),
            _counterButton(Icons.add, onIncrement),
          ],
        ),
      ],
    );
  }

  Widget _counterButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
          ),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }
}

void _showRejectBottomSheet(
  BuildContext parentContext,
  String requestId,
  RequestBloc bloc,
) {
  final l10n = AppLocalizations.of(parentContext)!;
  final reasons = [
    "Prescription is unclear",
    "Medicine unavailable",
    "Quantity is unreasonable",
    "Prescription expired",
    l10n.otherReason,
  ];
  String? selectedReason;

  showModalBottomSheet(
    context: parentContext,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      final otherCtrl = TextEditingController();
      return StatefulBuilder(
        builder: (context, setState) {
          return PopScope(
            onPopInvokedWithResult: (_, _) => otherCtrl.dispose(),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.selectRejectionReason,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    RadioGroup<String>(
                      groupValue: selectedReason,
                      onChanged: (val) {
                        setState(() => selectedReason = val);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: reasons
                            .map(
                              (reason) => RadioListTile<String>(
                                title: Text(
                                  reason,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                value: reason,
                                toggleable: true,
                                activeColor: AppColors.error,
                                contentPadding: EdgeInsets.zero,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    if (selectedReason == l10n.otherReason) ...[
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: otherCtrl,
                        hint: l10n.enterCustomReason,
                        prefixIcon: Icons.edit,
                      ),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: selectedReason == null
                          ? null
                          : () {
                              final reason = selectedReason == l10n.otherReason
                                  ? otherCtrl.text
                                  : selectedReason;
                              if (selectedReason == l10n.otherReason &&
                                  otherCtrl.text.trim().isEmpty) {
                                return;
                              }

                              bloc.add(
                                RequestApproveRequested(
                                  requestId: requestId,
                                  action: RequestReviewAction.reject,
                                  reviewReason: reason,
                                ),
                              );
                              Navigator.pop(context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.error.withValues(
                          alpha: 0.3,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        l10n.confirmRejection,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
