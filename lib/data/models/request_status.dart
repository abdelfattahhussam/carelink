import 'package:carelink_app/core/models/display_status.dart';

/// Type-safe request status enum — replaces raw String status.
///
/// Exhaustive handling prevents silent undefined states when
/// the API returns unexpected values.
enum RequestStatus {
  pending,
  approved,
  rejected,
  delivering,
  delivered;

  /// Parses a raw JSON string into a [RequestStatus].
  ///
  /// Asserts in debug mode on unknown values to surface backend
  /// contract violations early. Falls back to [pending] in release.
  static RequestStatus fromJson(String? raw) {
    return RequestStatus.values.firstWhere(
      (e) => e.name == raw,
      orElse: () {
        assert(false, 'Unknown request status: $raw');
        return RequestStatus.pending;
      },
    );
  }

  String toJson() => name;

  /// Maps to the shared [DisplayStatus] for presentation layer.
  DisplayStatus get displayStatus => switch (this) {
    RequestStatus.pending => DisplayStatus.pending,
    RequestStatus.approved => DisplayStatus.approved,
    RequestStatus.rejected => DisplayStatus.rejected,
    RequestStatus.delivering => DisplayStatus.delivering,
    RequestStatus.delivered => DisplayStatus.delivered,
  };
}
