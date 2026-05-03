import 'package:carelink_app/core/models/display_status.dart';

/// Type-safe medicine status — replaces raw String status field.
///
/// Maps to API values: 'pending', 'approved', 'rejected', 'expired'.
enum MedicineStatus {
  pending, approved, rejected, expired;

  static MedicineStatus fromJson(String? raw) {
    return MedicineStatus.values.firstWhere(
      (e) => e.name == raw,
      orElse: () {
        assert(false, 'Unknown medicine status: $raw');
        return MedicineStatus.pending;
      },
    );
  }

  String toJson() => name;

  /// Maps to the shared [DisplayStatus] for presentation layer.
  DisplayStatus get displayStatus => switch (this) {
    MedicineStatus.pending => DisplayStatus.pending,
    MedicineStatus.approved => DisplayStatus.approved,
    MedicineStatus.rejected => DisplayStatus.rejected,
    MedicineStatus.expired => DisplayStatus.expired,
  };
}
