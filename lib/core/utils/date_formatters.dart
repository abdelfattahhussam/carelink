import 'package:intl/intl.dart';

/// Date and time formatting utilities
class DateFormatters {
  DateFormatters._();

  static final _dateFormat = DateFormat('MMM dd, yyyy');
  static final _dateTimeFormat = DateFormat('MMM dd, yyyy • hh:mm a');
  static final _relativeFormat = DateFormat('hh:mm a');

  /// Format date as "Jan 01, 2025"
  static String formatDate(DateTime date) => _dateFormat.format(date);

  /// Format as "Jan 01, 2025 • 02:30 PM"
  static String formatDateTime(DateTime date) => _dateTimeFormat.format(date);

  /// Returns relative time string (e.g., "2 hours ago", "Just now")
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return _dateFormat.format(date);
  }

  /// Check if a date is expired (before today)
  static bool isExpired(DateTime expiryDate) {
    return expiryDate.isBefore(DateTime.now());
  }

  /// Check if expiry is within N days
  static bool expiresSoon(DateTime expiryDate, {int days = 30}) {
    return expiryDate.difference(DateTime.now()).inDays <= days &&
        !isExpired(expiryDate);
  }

  /// Days until expiry (negative if expired)
  static int daysUntilExpiry(DateTime expiryDate) {
    return expiryDate.difference(DateTime.now()).inDays;
  }

  /// Format time only as "02:30 PM"
  static String formatTime(DateTime date) => _relativeFormat.format(date);
}
