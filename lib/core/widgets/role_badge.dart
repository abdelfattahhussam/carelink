import 'package:flutter/material.dart';
import 'package:carelink_app/l10n/app_localizations.dart';
import '../constants/app_colors.dart';
import '../../data/models/user_model.dart';

/// A subtle badge to indicate user role
class RoleBadge extends StatelessWidget {
  final UserRole role;
  const RoleBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final color = switch (role) {
      UserRole.pharmacist => AppColors.primary,
      UserRole.donor => AppColors.success,
      UserRole.patient => AppColors.secondary,
    };

    final label = switch (role) {
      UserRole.pharmacist => AppLocalizations.of(context)!.pharmacist,
      UserRole.donor => AppLocalizations.of(context)!.donor,
      UserRole.patient => AppLocalizations.of(context)!.patient,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
