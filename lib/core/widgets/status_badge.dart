import 'package:flutter/material.dart';
import 'package:carelink_app/l10n/app_localizations.dart';
import '../constants/app_colors.dart';

/// Status badge chip with color coding
class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Color bgColor;
    Color textColor;
    IconData icon;
    String label;

    switch (status.toLowerCase()) {
      case 'approved':
        bgColor = AppColors.approved.withValues(alpha: 0.1);
        textColor = AppColors.approved;
        icon = Icons.check_circle_outline;
        label = l10n.approved;
        break;
      case 'rejected':
        bgColor = AppColors.rejected.withValues(alpha: 0.1);
        textColor = AppColors.rejected;
        icon = Icons.cancel_outlined;
        label = l10n.rejected;
        break;
      case 'expired':
        bgColor = AppColors.expired.withValues(alpha: 0.1);
        textColor = AppColors.expired;
        icon = Icons.timer_off_outlined;
        label = l10n.expired;
        break;
      case 'delivered':
        bgColor = AppColors.info.withValues(alpha: 0.1);
        textColor = AppColors.info;
        icon = Icons.local_shipping_outlined;
        label = l10n.delivered;
        break;
      case 'pending':
      default:
        bgColor = AppColors.pending.withValues(alpha: 0.1);
        textColor = AppColors.pending;
        icon = Icons.schedule;
        label = l10n.pending;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
