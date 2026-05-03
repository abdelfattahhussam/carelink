import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:carelink_app/l10n/app_localizations.dart';

/// Date and time formatting utilities
class DateFormatters {
  DateFormatters._();

  /// Format date as "Jan 01, 2025" — locale-aware
  static String formatDate(DateTime date, [String locale = 'en']) =>
      DateFormat.yMMMd(locale).format(date);

  /// Format as "Jan 01, 2025 • 02:30 PM" — locale-aware
  static String formatDateTime(DateTime date, [String locale = 'en']) {
    final datePart = DateFormat.yMMMd(locale).format(date);
    final timePart = DateFormat.jm(locale).format(date);
    return '$datePart • $timePart';
  }

  /// Returns relative time string using l10n keys.
  /// Requires BuildContext for localized strings.
  static String timeAgo(DateTime date, {BuildContext? context}) {
    final now = DateTime.now();
    final diff = now.difference(date);
    final locale = context != null
        ? Localizations.localeOf(context).languageCode
        : 'en';

    if (context != null) {
      final l10n = AppLocalizations.of(context)!;
      if (diff.inSeconds < 60) return l10n.justNow;
      if (diff.inMinutes < 60) return l10n.minutesAgo(diff.inMinutes);
      if (diff.inHours < 24) return l10n.hoursAgo(diff.inHours);
      if (diff.inDays < 7) return l10n.daysAgo(diff.inDays);
      return formatDate(date, locale);
    }

    // Fallback for non-context calls (e.g., background services)
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat.yMMMd().format(date);
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

  /// Format time only as "02:30 PM" — locale-aware
  static String formatTime(DateTime date, [String locale = 'en']) =>
      DateFormat.jm(locale).format(date);
}
