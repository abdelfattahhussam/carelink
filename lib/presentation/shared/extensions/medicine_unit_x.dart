import 'package:flutter/material.dart';
import 'package:carelink_app/l10n/app_localizations.dart';
import 'package:carelink_app/data/models/medicine_unit.dart';

/// Presentation-layer localization for [MedicineUnit].
///
/// Moved from data model to respect Clean Architecture boundaries —
/// data models must have zero dependency on Flutter UI framework.
extension MedicineUnitX on MedicineUnit {
  /// Maps the unit into localized text if it's 'box' or 'strip'.
  /// For unknown API payload types, echoes the original string.
  String localizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return value;

    if (isBox) return l10n.box;
    if (isStrip) return l10n.strip;
    return value; // Preserved raw 'bottle', 'pack', etc.
  }
}
