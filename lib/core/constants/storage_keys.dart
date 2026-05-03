/// Single source of truth for secure-storage key names.
///
/// All reads / writes / deletes against [AuthStorage] must use these
/// constants to prevent key drift across the codebase.
class StorageKeys {
  StorageKeys._();

  static const String authToken = 'auth_token';
  static const String userData = 'user_data';

  /// All auth-scoped keys — used for scoped cleanup on logout / 401.
  /// Keys added here will be automatically cleared on sign-out.
  static const List<String> all = [authToken, userData];
}
