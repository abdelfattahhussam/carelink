import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_storage.dart';

/// Concrete [AuthStorage] implementation backed by platform-native encryption
/// (Keychain on iOS, EncryptedSharedPreferences on Android).
///
/// Non-sensitive preferences (theme, locale) should remain in [SharedPreferences].
class SecureStorage implements AuthStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  /// Default const constructor for DI / inline instantiation.
  const SecureStorage();

  /// Convenience singleton for use outside of DI contexts (e.g., DioClient).
  static final instance = const SecureStorage();

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> deleteAll() => _storage.deleteAll();
}
