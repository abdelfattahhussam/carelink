import 'package:flutter/material.dart';
import 'package:carelink_app/l10n/app_localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:carelink_app/presentation/blocs/qr/qr_bloc.dart';
import 'package:carelink_app/presentation/blocs/request/request_bloc.dart';
import 'package:carelink_app/presentation/blocs/donation/donation_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';

/// Displays a QR code for pickup/delivery confirmation
class QrDisplayScreen extends StatelessWidget {
  final String? qrData;
  final String? itemId;
  final String? itemType;

  const QrDisplayScreen({super.key, this.qrData, this.itemId, this.itemType});

  @override
  Widget build(BuildContext context) {
    final code = qrData ?? 'NO-QR-DATA';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.qrCode,
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.heroGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.local_pharmacy_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.carelink,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // QR Code
                    QrImageView(
                      data: code,
                      version: QrVersions.auto,
                      size: 220,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: AppColors.primaryDark,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Code text
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        code,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          letterSpacing: 1.5,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.warning,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.deliveryConfirmedOnlyIf,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.warning,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              // --- DEBUG SIMULATION BUTTON ---
              TextButton.icon(
                onPressed: () async {
                  if (itemId != null && itemType != null) {
                    // Captured variables for async use
                    final qrBloc = context.read<QrBloc>();
                    final donationBloc = context.read<DonationBloc>();
                    final requestBloc = context.read<RequestBloc>();
                    final navigator = Navigator.of(context);

                    // 1. Close this screen FIRST
                    navigator.pop();

                    // 2. Wait a tiny bit for the pop animation to finish
                    await Future.delayed(const Duration(milliseconds: 100));

                    // 3. Tell Mock Backend to change status to 'delivering'
                    qrBloc.add(
                      QrConfirmProcessed(id: itemId!, type: itemType!),
                    );

                    // 4. Wait longer to ensure mock latency (500ms) is covered
                    await Future.delayed(const Duration(milliseconds: 1000));

                    // 5. Trigger a refresh on the relevant Bloc
                    if (itemType == 'donation') {
                      donationBloc.add(DonationsFetchRequested());
                    } else {
                      requestBloc.add(RequestsFetchRequested());
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Simulation error: Missing ID or Type'),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.bug_report_rounded, size: 18),
                label: const Text(
                  'DEBUG: Simulate Pharmacist Scan',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary.withValues(alpha: 0.6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  backgroundColor: AppColors.primary.withValues(alpha: 0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              // -------------------------------
            ],
          ),
        ),
      ),
    );
  }
}
