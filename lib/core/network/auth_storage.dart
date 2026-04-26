/// Abstract interface for secure key-value storage.
///
/// BLoCs depend on this interface; concrete implementations use
/// platform-specific secure storage (e.g., FlutterSecureStorage).
/// In tests, use an in-memory [FakeAuthStorage] implementation.
abstract class AuthStorage {
  /// Read the value for the given [key]. Returns null if not found.
  Future<String?> read(String key);

  /// Write a [value] for the given [key].
  Future<void> write(String key, String value);

  /// Delete the value for the given [key].
  Future<void> delete(String key);

  /// Delete all stored values.
  Future<void> deleteAll();
}
