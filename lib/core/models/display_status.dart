/// Shared display-level status used by [StatusBadge] and presentation layer.
///
/// Each domain status enum maps to a [DisplayStatus] via its
/// `.displayStatus` getter, providing a single strongly-typed
/// surface for the UI without leaking domain semantics.
enum DisplayStatus {
  pending,
  approved,
  rejected,
  delivering,
  delivered,
  expired;
}
