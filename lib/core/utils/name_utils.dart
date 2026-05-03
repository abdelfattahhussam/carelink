/// Utility for safely extracting display-friendly name parts.
class NameUtils {
  NameUtils._();

  /// Returns the first word of [fullName], or the entire string if it
  /// contains no spaces.  Returns an empty string when [fullName] is null
  /// or blank — this avoids a crash when the backend sends an empty name.
  static String firstName(String? fullName) {
    if (fullName == null || fullName.trim().isEmpty) return '';
    return fullName.trim().split(' ').first;
  }
}
