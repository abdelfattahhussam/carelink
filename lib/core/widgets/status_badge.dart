import 'package:flutter/material.dart';
import 'package:carelink_app/l10n/app_localizations.dart';
import 'package:carelink_app/core/models/display_status.dart';
import '../constants/app_colors.dart';

/// Status badge chip with color coding.
///
/// Accepts [DisplayStatus] — a single concrete type shared across all
/// domain status enums. Callers must convert via `.displayStatus` getter.
class StatusBadge extends StatelessWidget {
  final DisplayStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (Color bg, Color text, IconData icon, String label) = switch (status) {
      DisplayStatus.approved => (
        AppColors.approved.withValues(alpha: 0.1),
        AppColors.approved,
        Icons.check_circle_outline,
        l10n.approved,
      ),
      DisplayStatus.rejected => (
        AppColors.rejected.withValues(alpha: 0.1),
        AppColors.rejected,
        Icons.cancel_outlined,
        l10n.rejected,
      ),
      DisplayStatus.expired => (
        AppColors.expired.withValues(alpha: 0.1),
        AppColors.expired,
        Icons.timer_off_outlined,
        l10n.expired,
      ),
      DisplayStatus.delivered => (
        AppColors.info.withValues(alpha: 0.1),
        AppColors.info,
        Icons.local_shipping_outlined,
        l10n.delivered,
      ),
      DisplayStatus.delivering => (
        AppColors.info.withValues(alpha: 0.1),
        AppColors.info,
        Icons.local_shipping_outlined,
        l10n.delivering,
      ),
      DisplayStatus.pending => (
        AppColors.pending.withValues(alpha: 0.1),
        AppColors.pending,
        Icons.schedule,
        l10n.pending,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: text),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: text,
            ),
          ),
        ],
      ),
    );
  }
}
