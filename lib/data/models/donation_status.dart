import 'package:carelink_app/core/models/display_status.dart';

/// Type-safe donation status enum — replaces raw String status.
///
/// Exhaustive handling prevents silent undefined states when
/// the API returns unexpected values.
enum DonationStatus {
  pending,
  approved,
  rejected,
  rejectedPermanent,
  delivering,
  delivered;

  /// Parses a raw JSON string into a [DonationStatus].
  ///
  /// Asserts in debug mode on unknown values to surface backend
  /// contract violations early. Falls back to [pending] in release.
  static DonationStatus fromJson(String? raw) {
    return DonationStatus.values.firstWhere(
      (e) => e.name == raw,
      orElse: () {
        assert(false, 'Unknown donation status: $raw');
        return DonationStatus.pending;
      },
    );
  }

  String toJson() => name;

  /// Maps to the shared [DisplayStatus] for presentation layer.
  DisplayStatus get displayStatus => switch (this) {
    DonationStatus.pending => DisplayStatus.pending,
    DonationStatus.approved => DisplayStatus.approved,
    DonationStatus.rejected => DisplayStatus.rejected,
    // rejectedPermanent intentionally maps to the same display value.
    // The UI badge does not distinguish temporary vs permanent rejection;
    // domain-level logic should check DonationStatus directly if needed.
    DonationStatus.rejectedPermanent => DisplayStatus.rejected,
    DonationStatus.delivering => DisplayStatus.delivering,
    DonationStatus.delivered => DisplayStatus.delivered,
  };
}
